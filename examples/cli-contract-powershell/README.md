# Script PowerShell CLI Contract Example

This example keeps coverage on the PowerShell-facing contract of `script.ps1`: help output and
version output.

## Testing

```powershell
# should show the debug flag in help output
& script.ps1 -Help | Select-String -Pattern '-Debug'

# should show the version flag in help output
& script.ps1 -Help | Select-String -Pattern '-Version'

# should print a version string
$version = & script.ps1 -Version
if ([string]::IsNullOrWhiteSpace($version)) { throw 'expected version output' }
```
