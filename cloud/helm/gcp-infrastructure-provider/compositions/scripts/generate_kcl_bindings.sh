#!/bin/bash
set -e
function main {
    local compositions_dir="/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/compositions"
    local tmp_dir=$(mktemp -d)
    trap 'rm -rf "${tmp_dir}"' EXIT

    echo "Extracting provider CRDs..."
    local provider_image_urls=$(yq -N -r '.spec.package | select(. != null)' "/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/templates/providers.yaml")
    for provider_image_url in ${provider_image_urls}; do
        docker pull -q "${provider_image_url}"
        local cid=$(docker create "${provider_image_url}")
        docker cp "${cid}:/package.yaml" "${tmp_dir}/package.yaml"
        docker rm -v "${cid}" > /dev/null
        yq -N -r 'select(.kind == "CustomResourceDefinition")' "${tmp_dir}/package.yaml" >> "${tmp_dir}/all_crds.yaml"
        echo "---" >> "${tmp_dir}/all_crds.yaml"
    done

    echo "Generating KCL models..."
    mkdir -p "${tmp_dir}/src"
    yq -N -s "\"${tmp_dir}/split/\" + .metadata.name" "${tmp_dir}/all_crds.yaml"
    for crd in "${tmp_dir}/split/"*; do
        [ -e "${crd}" ] || continue
        kcl-openapi generate model --spec "${crd}" --crd --target "${tmp_dir}/src" --model-package "models"
    done

    echo "Bundling models.k and pipeline.k..."
    python3 - <<'PY_EOF'
import os, glob, re
compositions_dir = "/home/allenz/liferay/liferay-portal/cloud/helm/gcp-infrastructure-provider/compositions"
src_dir = glob.glob("/tmp/tmp.*/src/models")[0]

# 1. Merge models
merged_models = ""
for root, _, files in os.walk(src_dir):
    for f in files:
        if not f.endswith('.k'): continue
        with open(os.path.join(root, f), 'r') as file:
            c = file.read()
            c = re.sub(r'"""\nThis file was generated.*?\n"""\n', '', c, flags=re.DOTALL)
            c = re.sub(r'(?m)^import .*', '', c)
            merged_models += c + "\n"

lines = merged_models.split('\n')
deduped_models = []
seen_schemas = set()
skip = False
for line in lines:
    m = re.match(r'^schema ([a-zA-Z0-9_]+):', line)
    if m:
        if m.group(1) in seen_schemas: skip = True
        else: skip = False; seen_schemas.add(m.group(1))
    if not skip: deduped_models.append(line)

with open(os.path.join(compositions_dir, 'models.k'), 'w') as f:
    f.write('import k8s.apimachinery.pkg.apis.meta.v1\n\n' + '\n'.join(deduped_models))

# 2. Build pipeline.k
layers = ["init", "security", "sql", "storage", "overlay", "k8s", "elasticsearch", "backup", "managed_service_details"]
shared_imports = ["import crypto", "import yaml", "import json", "import k8s.api.core.v1 as k8s_core", "import k8s.api.batch.v1 as k8s_batch", "import k8s.api.rbac.v1 as k8s_rbac", "import k8s.apimachinery.pkg.apis.meta.v1 as v1"]
pipeline_content = "\n".join(shared_imports) + "\n\n# --- MODELS ---\n" + "\n".join(deduped_models) + "\n\n"
with open(os.path.join(compositions_dir, 'context_variables.k'), 'r') as f:
    pipeline_content += "# --- CONTEXT ---\n" + re.sub(r'(?m)^import .*', '', f.read()) + "\n\n"

for layer in layers:
    with open(os.path.join(compositions_dir, f"{layer}.k"), 'r') as f:
        l_content = re.sub(r'(?m)^import .*', '', f.read()).replace('models.', '').replace('cv.', '')
        indented = "\n".join(["    " + line if line.strip() else line for line in l_content.split("\n")])
        pipeline_content += f"schema {layer}_layer:\n{indented}\n\n_{layer} = {layer}_layer {{}}\nitems_{layer} = _{layer}.items\n\n"

pipeline_content += "items = {\"items\": [item for layer in [" + ",".join([f"items_{l}" for l in layers]) + "] for item in layer.items]}\n"
with open(os.path.join(compositions_dir, 'pipeline.k'), 'w') as f:
    f.write(pipeline_content)
PY_EOF
    echo "Done."
}
main
