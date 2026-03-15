# Script Bash Minimal Example

This example is the smallest markdown-first smoke test for `script.sh`. It runs the default
no-argument flow and verifies the placeholder output from the prepared `dist/script.sh` artifact.

## Setup

```bash
# should run the default placeholder flow
script.sh > run.log 2>&1
```

## Testing

```bash
# should print the placeholder execution message
grep -F 'Replace the body of script.sh with your project logic.' run.log
```

## Destroy tests

```bash
# should remove the placeholder run log
rm -f run.log
```
