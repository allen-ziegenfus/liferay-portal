MOCK ?= tests/arz_dev2025_params.json

.PHONY: all fmt lint test run-all pkg clean generate generate-models

all: fmt lint test

fmt:
	kcl fmt *.k
	kcl fmt tests/*.k

generate:
	./scripts/generate_kcl_bindings.sh

generate-models:
	./scripts/generate_models.sh

lint: generate
	@kcl run dist/pipeline.k -D params='{"oxr": {"spec": {"database": {}}}, "ctx": {"apiextensions.crossplane.io/environment": {}}}' > /dev/null

test:
	@PARAMS=$$(cat tests/arz_dev2025_params.json | jq -c) && \
	CLUSTER_REFS=$$(cat tests/cluster_extracted_resources.json | jq -c) && \
	cd tests && kcl test . -D params="$$PARAMS" -D cluster_refs="$$CLUSTER_REFS"

run-all: generate
	@if [ ! -f $(MOCK) ]; then echo "Please provide a mock.json file."; exit 1; fi
	@kcl run dist/pipeline.k -D params=$$(cat $(MOCK) | jq -r '.params | tojson')

pkg: generate
	cd dist && /home/allenz/go/bin/kpm pkg

clean:
	rm -rf vendor/ kcl.mod.lock dist/
