# Script Bash Minimal Example

This example is the smallest markdown-first smoke test for `script.sh`. It runs the default
no-argument flow and verifies the placeholder output from the prepared `dist/script.sh` artifact.

## Setup

```bash
# should reset the example scratch directory
rm -rf .tmp && mkdir -p .tmp

# should run the default placeholder flow
script.sh > .tmp/run.log 2>&1
```

## Testing

```bash
# should print the placeholder execution message
grep -F 'Replace the body of script.sh with your project logic.' .tmp/run.log
```

## Destroy tests

```bash
# should remove the example scratch directory
rm -rf .tmp
```
