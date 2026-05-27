# KCL Multi-Step Pipeline for Crossplane Compositions — Prototype

A working prototype demonstrating an alternative architecture for KCL-based Crossplane compositions: each composition layer as its own `function-kcl` pipeline step, with Helm handling shared-context concatenation at template time.

## Branch context

This branch (`LCD-51066`) is preserved on this personal fork as portfolio material. It originated as a prototype evaluating [KCL](https://github.com/kcl-lang/kcl) as a replacement for Go templates in Crossplane composition pipelines. The branch is kept here for future reference and writeup; the originating Jira ticket is closed and the originating PR has been closed.

## What this demonstrates

A Crossplane composition that needs to produce many resources can be implemented in `function-kcl` in two architectural shapes:

1. **Single bundled `function-kcl` step.** Concatenate all layers (`init.k`, `k8s_resources.k`, `sql.k`, etc.) into one input. Requires a Python bundler to assemble inputs, a `schema {layer}_layer:` indirection per layer so the bundled input stays addressable, and an indent step that can leak into string literals depending on YAML-anchor placement.

2. **Multi-step pipeline (this prototype).** Each composition layer is its own `function-kcl` step in the Crossplane pipeline. Helm concatenates the shared context (`context_variables.k`) into each step's input at template time. **No Python bundler. No `schema {layer}_layer:` wrapper. No indent step that can leak into string literals.**

Trade-off: more pipeline steps to define, but simpler per-step input, faster KCL compilation per step (smaller scope), and easier debugging when a single layer fails — the failing layer is named explicitly in the pipeline status, rather than buried inside a bundled multi-layer input.

## Key files

- `cloud/helm/gcp-infrastructure-provider/compositions/init.k` — initial KCL layer wired as its own pipeline step
- `cloud/helm/gcp-infrastructure-provider/compositions/main.k` — composition entry point
- `cloud/helm/gcp-infrastructure-provider/compositions/context_variables.k` — shared context concatenated into each pipeline step at template time
- `cloud/helm/gcp-infrastructure-provider/compositions/Makefile` — build / lint workflow for the KCL modules
- `cloud/helm/gcp-infrastructure-provider/compositions/models/` — type stubs for GCP and Kubernetes Crossplane CRDs (IAM, SQL, KMS, Storage, Kubernetes objects)
- `cloud/helm/gcp-infrastructure-provider/compositions/dist/` — compiled output artifact

## Future writeup

This prototype is source material for a planned blog post: *"When Go templates outgrow you: a typed-language replacement for Crossplane compositions."*

The argument: once a Crossplane composition has many resource types and shared logic across them, Go templates' lack of types and limited shared-context become structural pain. KCL is one credible alternative; this branch shows what the migration shape looks like in practice — including the *multi-step pipeline* architectural choice that avoids the Python-bundler / wrapper-schema / indent-leak issues of the single-step approach.

## Provenance

- Branch preserved on this personal fork for portfolio reference.
- Original prototype work was done as part of an internal Crossplane-composition refactor exploration.
- The single-step and multi-step approaches were compared in a separate architectural writeup; only the multi-step approach is materialized on this branch.
