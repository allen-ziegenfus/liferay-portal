#!/bin/bash

set -e

function main {
    local compositions_directory_path="/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/compositions"

    local output_directory_path="${compositions_directory_path}/models"

    local providers_configuration_file_path="/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/templates/providers.yaml"

    local temporary_working_directory_path
    temporary_working_directory_path=$(mktemp -d)

    declare -A resource_groups=(
        ["databaseinstances.sql.gcp.m.upbound.io"]="sql"
        ["databases.sql.gcp.m.upbound.io"]="sql"
        ["users.sql.gcp.m.upbound.io"]="sql"
        ["buckets.storage.gcp.m.upbound.io"]="storage"
        ["bucketiammembers.storage.gcp.m.upbound.io"]="storage"
        ["serviceaccounts.cloudplatform.gcp.m.upbound.io"]="cloudplatform"
        ["serviceaccountiammembers.cloudplatform.gcp.m.upbound.io"]="cloudplatform"
        ["projectiammembers.cloudplatform.gcp.m.upbound.io"]="cloudplatform"
        ["keyrings.kms.gcp.m.upbound.io"]="kms"
        ["cryptokeys.kms.gcp.m.upbound.io"]="kms"
        ["cryptokeyiammembers.kms.gcp.m.upbound.io"]="kms"
        ["objects.kubernetes.m.crossplane.io"]="kubernetes"
    )

    trap 'rm -rf "${temporary_working_directory_path}"' EXIT

    echo ""
    echo "Parsing providers..."

    local provider_image_urls
    provider_image_urls=$(yq -N -r '.spec.package | select(. != null)' "${providers_configuration_file_path}")

    echo "Extracting selected resource definitions..."

    for provider_image_url in ${provider_image_urls}
    do
        echo "Processing ${provider_image_url}..."

        docker pull -q "${provider_image_url}"

        local container_identifier
        container_identifier=$(docker create "${provider_image_url}")

        docker cp "${container_identifier}:/package.yaml" "${temporary_working_directory_path}/package.yaml"

        docker rm -v "${container_identifier}" > /dev/null

        local custom_resource_definition_names
        custom_resource_definition_names=$(yq -N -r 'select(.kind == "CustomResourceDefinition") | .metadata.name' "${temporary_working_directory_path}/package.yaml")

        for custom_resource_definition_name in ${custom_resource_definition_names}
        do
            if [[ -v resource_groups["${custom_resource_definition_name}"] ]]
            then
                yq -N "select(.kind == \"CustomResourceDefinition\" and .metadata.name == \"${custom_resource_definition_name}\")" "${temporary_working_directory_path}/package.yaml" >> "${temporary_working_directory_path}/all_selected.yaml"

                echo "---" >> "${temporary_working_directory_path}/all_selected.yaml"
            fi
        done

        rm -f "${temporary_working_directory_path}/package.yaml"
    done

    echo ""
    echo "Generating unified KCL models..."

    rm -rf "${output_directory_path}"

    mkdir -p "${output_directory_path}/tmp"

    # kcl-openapi has issues with combined files containing multiple CRDs,
    # so we generate them individually.

    mkdir -p "${temporary_working_directory_path}/all_selected"

    yq -N -s "\"${temporary_working_directory_path}/all_selected/\" + .metadata.name" "${temporary_working_directory_path}/all_selected.yaml"

    for crd_file in "${temporary_working_directory_path}/all_selected/"*
    do
        [ -e "${crd_file}" ] || continue

        local crd_name
        crd_name=$(basename "${crd_file}")

        if [[ "${crd_name}" == "null" ]]
        then
            continue
        fi

        echo "Generating model for ${crd_name}..."

        local crd_version
        crd_version=$(yq -N -r '.spec.versions[] | select(.storage == true) | .name' "${crd_file}")

        mkdir -p "${output_directory_path}/tmp/${crd_version}"

        kcl-openapi generate model --spec "${crd_file}" --crd --target "${output_directory_path}/tmp/${crd_version}" --model-package "models"
    done

    for version_dir in "${output_directory_path}/tmp"/*/
    do
        [ -d "${version_dir}" ] || continue
        local version_name
        version_name=$(basename "${version_dir}")
        
        mkdir -p "${output_directory_path}/${version_name}"
        cp -r "${version_dir}models/"* "${output_directory_path}/${version_name}/"
    done

    rm -rf "${output_directory_path}/tmp"

    echo "Fixing Kubernetes dependency conflicts..."

    rm -rf "${output_directory_path}/k8s"

    find "${output_directory_path}" -name "*.k" -exec sed -i 's/import k8s\.apimachinery/import k8s.apimachinery/g' {} +

    echo "Consolidating models into a single models.k file..."

    python3 - <<EOF
import os
import glob
import re

model_files = glob.glob('${output_directory_path}/**/*.k', recursive=True)

merged_content = 'import k8s.apimachinery.pkg.apis.meta.v1\\n\\n'

for f in model_files:
    if f.endswith('kcl.mod') or f.endswith('kcl.mod.lock'):
        continue
    with open(f, 'r') as file:
        content = file.read()
        # Remove the generated header and imports
        content = re.sub(r'"""\\nThis file was generated.*?\\n"""\\n', '', content, flags=re.DOTALL)
        content = re.sub(r'(?m)^import .*\\n', '', content)
        merged_content += content + '\\n'

lines = merged_content.split('\\n')
new_lines = []
seen_schemas = set()
skip_current = False

for line in lines:
    m = re.match(r'^schema ([a-zA-Z0-9_]+):', line)
    if m:
        current_schema = m.group(1)
        if current_schema in seen_schemas:
            skip_current = True
        else:
            skip_current = False
            seen_schemas.add(current_schema)
            new_lines.append(line)
    else:
        if not skip_current:
            new_lines.append(line)

with open('${compositions_directory_path}/models.k', 'w') as f:
    f.write('\\n'.join(new_lines))
EOF

    echo "Cleaning up temporary models directory..."
    rm -rf "${output_directory_path}"

    echo ""
    echo "Done."
}

main
