# Script PowerShell CLI Contract Example

This example keeps coverage on the PowerShell-facing contract of `script`: help output and
version output.

## Testing

```powershell
# should show the debug flag in help output
script -Help | Select-String -Pattern '-Debug'

# should show the version flag in help output
script -Help | Select-String -Pattern '-Version'

# should show the invoked command name in usage output
script -Help | Select-String -Pattern 'Usage: .*script '

# should print a version string
$version = script -Version
if ([string]::IsNullOrWhiteSpace($version)) { throw 'expected version output' }
```
