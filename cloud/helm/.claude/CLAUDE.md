---

alwaysApply: true
description: Coding style rules for Liferay cloud/helm — shell scripts, YAML, Helm, logging
globs: *

---

# Style Rules

## Sorting

Sort everything by ASCII value (uppercase before lowercase):

- YAML map keys, Helm values, Terraform attributes — alphabetical
- All lists (unless order carries meaning)
- `locals` and template variables — alphabetical
- Exception: only break order for strict functional dependencies

## Shell Scripts

**`set -e` / `set -eu` placement:** Put `set -e` (or `set -eu`) immediately after the shebang, before any function definitions.

**Function ordering:** Define `main` first, helper functions (e.g. `_log_json`) after it. Call `main` (or `main "${@}"`) at the very bottom.

**`local` declarations:**
- Simple/parameter expansion: combine on one line — `local var="${val}"`
- Subshell assignments: split with a blank line between declaration and assignment:

  ```sh
  local var

  var=$(cmd)
  ```

**`if` blocks:** Put blank lines between distinct operations inside an `if` block.

**`if` condition syntax:** No semicolon before `then` — put `then` on its own line:

```sh
if [ condition ]
then
    ...
fi
```

**Loop syntax:** `do` on its own line, no preceding semicolon:

```sh
until condition
do
    ...
done
```

**`curl`:** URL is the last argument, after all flags.

**Multi-line subshell spacing:** `$( \` with a space before the backslash, not `$(\`.

**Naming:** No abbreviations — `configuration_json_file` not `config_file`. Acronyms stay uppercase in identifiers — `AWS` not `Aws` (e.g. `liferayAWSBackupRestore`).

**No spaces around `=`:** `key=value`.

**Wrap non-trivial scripts** in `function main {}`.

## Logging

- End every log message with a single period `.` — never `!` or `...`
- Use escaped double quotes `\"value\"` to highlight values — never single quotes
- **"Tesla car" rule:** lowercase for common technical nouns (`cluster`, `green`, `infrastructure`, `password`, `ready`, `red`, `unreachable`, `username`, `yellow`) unless starting a sentence
- Prefer "does not exist" over "not found"
- No trailing slashes in URIs or bucket paths

## YAML / Helm

- Trailing commas on every list element (Terraform/HCL — not JSON or YAML)
- Attributes within blocks sorted alphabetically
- Top-level Kubernetes YAML keys sorted alphabetically — `data` before `metadata` in ConfigMaps
- List items indented with dash + 3 spaces: `- value` (content at 4th character)
- No empty lines between related resource/output blocks (vertical density)
- No blank lines between `---` document separators in Helm templates
- Helm template variables sorted alphabetically

## Prose (Chart.yaml, error messages, comments)

- "cloud native" — no hyphen
- Spell out compound words in messages — "Liferay Infrastructure" not "LiferayInfrastructure"