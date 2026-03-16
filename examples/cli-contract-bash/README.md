# Script Bash CLI Contract Example

This example keeps coverage on the Bash-facing contract of `script`: help output and version
output.

## Testing

```bash
# should show the debug flag in help output
script --help | grep -- '--debug'

# should show the version flag in help output
script --help | grep -- '--version'

# should show the invoked command name in usage output
script --help | grep -E 'Usage: .*script '

# should print a version string
test -n "$(script --version)"
```
