#!/bin/bash
# Refreshes compositions/models/ from the provider CRDs declared in
# templates/providers.yaml. Run manually when the provider set or versions
# change; the output is checked in so routine builds/tests don't need docker.
set -e
function main {
    local compositions_dir="/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/compositions"
    local models_dir="${compositions_dir}/models"
    local tmp_dir=$(mktemp -d)
    trap 'rm -rf "${tmp_dir}"' EXIT

    echo "Extracting provider CRDs..."
    local provider_image_urls=$(yq -N -r '.spec.package | select(. != null)' "/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/templates/providers.yaml")
    for provider_image_url in ${provider_image_urls}; do
        echo "  ${provider_image_url}"
        docker pull -q "${provider_image_url}"
        local cid=$(docker create "${provider_image_url}")
        docker cp "${cid}:/package.yaml" "${tmp_dir}/package.yaml"
        docker rm -v "${cid}" > /dev/null
        # Keep only the namespaced (*.m.*) CRDs that v2 Crossplane uses. The
        # kubernetes provider group is already namespaced (kubernetes.m.crossplane.io).
        if [[ "${provider_image_url}" == *"provider-kubernetes"* ]]; then
            yq -N 'select(.kind == "CustomResourceDefinition")' "${tmp_dir}/package.yaml" >> "${tmp_dir}/all_crds.yaml"
        else
            yq -N 'select(.kind == "CustomResourceDefinition" and (.spec.group | contains(".m.")))' "${tmp_dir}/package.yaml" >> "${tmp_dir}/all_crds.yaml"
        fi
        echo "---" >> "${tmp_dir}/all_crds.yaml"
    done

    echo "Generating KCL models..."
    mkdir -p "${tmp_dir}/src" "${tmp_dir}/split"
    yq -N -s "\"${tmp_dir}/split/\" + .metadata.name" "${tmp_dir}/all_crds.yaml"
    for crd in "${tmp_dir}/split/"*; do
        [ -e "${crd}" ] || continue
        local crd_name=$(basename "${crd}")
        mkdir -p "${tmp_dir}/src/${crd_name}"
        kcl-openapi generate model --spec "${crd}" --crd --target "${tmp_dir}/src/${crd_name}" --model-package "models"
    done

    echo "Copying into ${models_dir}..."
    rm -rf "${models_dir}"
    mkdir -p "${models_dir}"
    # Each kcl-openapi invocation produces a `models/` tree; merge them all.
    for crd_src in "${tmp_dir}/src"/*/models; do
        [ -d "${crd_src}" ] || continue
        cp -rn "${crd_src}"/. "${models_dir}/" || cp -r "${crd_src}"/* "${models_dir}/"
    done
    echo "Done. Models written to ${models_dir}"
}
main
