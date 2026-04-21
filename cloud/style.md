# Style Guide

Derived from Brian Chan's source formatting commits in `cloud/`.

## Sorting

- Case-sensitive ASCII sort everywhere (uppercase before lowercase — matches Sublime Text sort)
- YAML map keys, Helm values, Terraform attributes, locals, template variables — all alphabetical
- Exception: only break order for strict functional dependencies
- Sort `customVolumeMounts` entries by `mountPath`
- Sort Helm template variables (`{{- $elasticsearch := ... }}`) alphabetically

## Shell Scripts

### Structure

- `set -o errexit` / `set -o nounset` (long form) at the top of standalone scripts, before any function definitions, followed by a blank line
- `set -eu` (short form) for inline scripts embedded in YAML
- `function main {` defined first; all helper functions (`_` prefix) defined after, in alphabetical order
- `main "${@}"` call at the very bottom of the file

### `local` Declarations

- Simple/parameter expansion — combine on one line: `local var="${val}"`
- Subshell assignment — split with a blank line between declaration and assignment:

  ```sh
  local var

  var=$(cmd)
  ```

- Multiple independent `local` declarations with literal values — no blank lines between them
- Script-level (global) constants with no dependency — no blank lines between them; add a blank line only when one depends on another

### `if` / Loops

- `then` on its own line — no semicolon before it
- `do` on its own line — no semicolon before it

### Commands

- `curl` — URL is the last argument, after all flags
- Multi-line subshell — space before backslash: `$( \` not `$(\`
- Array literals — closing `)` on the same line as the last element
- `rm -fr` not `rm -rf`

### Logging and Messages

- Every message ends with a single period `.` — never `!`
- Waiting-loop messages end with `...` (the only exception to the period rule)
- Use `\"value\"` to highlight values — never `'value'`
- Lowercase common technical nouns unless starting a sentence
- Key/value status output uses colon style: `echo "Region: ${region}."`
- Completion messages use past tense: `"The file was generated successfully."`
- Error messages: complete sentences, specific context, prefer "does not exist" over "not found"
- Compound proper nouns spelled as two words in messages: "Liferay Infrastructure" not "LiferayInfrastructure"
- Multi-part user instructions separated by `echo ""`

### Naming

- No abbreviations — `configuration_json_file` not `config_file`, `argument` not `arg`
- File-path variables end with `_file` (local) or `_FILE` (script-level constants)
- "set up" is a verb (two words); "setup" is a noun
- Brand names: "Argo CD" (space, capital CD)
- Acronyms stay uppercase in identifiers: `aws_output` not `amazon_web_services_output`

### Comments

- No comments that restate what the code does
- Important notes use block style:

  ```sh
  #
  # Note text.
  #
  ```

## YAML / Helm

- List items indented with dash + 3 spaces: `- value` (content at 4th character)
- No blank lines between `---` document separators in Helm templates
- `data:` before `metadata:` in ConfigMaps and Secrets
- In `selectorLabels`, `app.kubernetes.io/instance` before `app.kubernetes.io/name`
- Template file names use full resource kind: `horizontalpodautoscaler.yaml` not `hpa.yaml`
- No blank lines between related resource/output blocks (vertical density)

## Terraform / HCL

- Tabs for indentation, not spaces
- Trailing commas on every list element
- `jsonencode(` / `yamlencode(` / `toset(` — opening bracket on its own line, closing `})` on the same line as the closing `}`:

  ```hcl
  assume_role_policy=jsonencode(
      {
          Statement=[...]
      })
  ```

- No blank lines between top-level resource/output/variable blocks