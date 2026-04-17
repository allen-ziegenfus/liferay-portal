MOCK ?= tests/arz_dev2025_params.json

.PHONY: all fmt lint test run-all pkg clean generate

all: fmt lint test

fmt:
	kcl fmt *.k
	kcl fmt tests/*.k

generate:
	./scripts/generate_kcl_bindings.sh

lint: generate
	@kcl run pipeline.k -D params='{"oxr": {"spec": {"database": {}}}, "ctx": {"apiextensions.crossplane.io/environment": {}}}' > /dev/null

test: generate
	@PARAMS=$$(cat tests/arz_dev2025_params.json | jq -c) && \
	CLUSTER_REFS=$$(cat tests/cluster_extracted_resources.json | jq -c) && \
	kcl test tests/... -Y . -D params="$$PARAMS" -D cluster_refs="$$CLUSTER_REFS"

run-all: generate
	@if [ ! -f $(MOCK) ]; then echo "Please provide a mock.json file."; exit 1; fi
	@kcl run pipeline.k -D params=$$(cat $(MOCK) | jq -r '.params | tojson')

pkg:
	/home/allenz/go/bin/kpm pkg

clean:
	rm -rf vendor/ kcl.mod.lock pipeline.k models.k
