# Script Bash CLI Contract Example

This example keeps coverage on the Bash-facing contract of `script.sh`: help output and version
output.

## Testing

```bash
# should show the debug flag in help output
script.sh --help | grep -- '--debug'

# should show the version flag in help output
script.sh --help | grep -- '--version'

# should print a version string
test -n "$(script.sh --version)"
```
