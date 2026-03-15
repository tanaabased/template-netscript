# Script Bash CLI Contract Example

This example keeps coverage on the Bash-facing contract of `script.sh`: help output, version output,
and a clear failure for unknown options.

## Testing

```bash
# should show the debug flag in help output
script.sh --help | grep -- '--debug'

# should show the version flag in help output
script.sh --help | grep -- '--version'

# should print a version string
test -n "$(script.sh --version)"

# should fail for an unknown option
! script.sh --definitely-bogus > invalid.log 2>&1

# should explain the unknown option failure
grep -F 'Unrecognized option' invalid.log
```

## Destroy tests

```bash
# should remove the cli-contract failure log
rm -f invalid.log
```
