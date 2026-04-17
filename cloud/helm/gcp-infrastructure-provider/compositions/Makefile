MOCK ?= mock.json

LAYERS = backup elasticsearch init k8s_resources managed_service_details overlay security sql storage

.PHONY: all fmt lint lint-layers test run run-all pkg clean generate generate-models $(LAYERS)

all: fmt lint test

fmt:
	kcl fmt *.k
	kcl fmt tests/*.k

generate:
	./scripts/generate_kcl_bindings.sh

generate-models:
	./scripts/generate_models.sh

# Type-check the bundled pipeline against an empty input.
lint: generate
	@kcl run dist/pipeline.k -D params='{"oxr": {"spec": {"database": {}}}, "ctx": {"apiextensions.crossplane.io/environment": {}}}' > /dev/null

# Type-check each source layer standalone. Faster feedback loop when iterating
# on a single layer — doesn't require regenerating the bundle.
lint-layers:
	@for layer in $(LAYERS); do \
		kcl run $${layer}.k -D params='{"oxr": {"spec": {"database": {}}}, "ctx": {"apiextensions.crossplane.io/environment": {}}}' > /dev/null || exit 1; \
	done

test:
	@PARAMS=$$(cat tests/arz_dev2025_params.json | jq -c) && \
	CLUSTER_REFS=$$(cat tests/cluster_extracted_resources.json | jq -c) && \
	cd tests && kcl test . -D params="$$PARAMS" -D cluster_refs="$$CLUSTER_REFS"

# Render the full composite (all layers aggregated via main.k) using MOCK.
run:
	@if [ ! -f $(MOCK) ]; then echo "Please provide a mock.json file."; exit 1; fi
	@kcl run main.k -D params=$$(cat $(MOCK) | jq -r '.params | tojson')

# Render the bundled dist/pipeline.k using MOCK (what crossplane actually runs).
run-all: generate
	@if [ ! -f $(MOCK) ]; then echo "Please provide a mock.json file."; exit 1; fi
	@kcl run dist/pipeline.k -D params=$$(cat $(MOCK) | jq -r '.params | tojson')

# Per-layer render target: `make backup` prints only that layer's YAML for MOCK.
$(LAYERS):
	@if [ ! -f $(MOCK) ]; then echo "Please provide a mock.json file."; exit 1; fi
	@kcl run $@.k -D params=$$(cat $(MOCK) | jq -r '.params | tojson')

pkg: generate
	cd dist && /home/allenz/go/bin/kpm pkg

clean:
	rm -rf vendor/ kcl.mod.lock dist/
