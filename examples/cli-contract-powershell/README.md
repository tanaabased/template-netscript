# Script PowerShell CLI Contract Example

This example keeps coverage on the PowerShell-facing contract of `script.ps1`: help output, version
output, and a clear failure for unexpected positional arguments.

## Testing

```powershell
# should show the debug flag in help output
& script.ps1 -Help | Select-String -Pattern '-Debug'

# should show the version flag in help output
& script.ps1 -Help | Select-String -Pattern '-Version'

# should print a version string
$version = & script.ps1 -Version
if ([string]::IsNullOrWhiteSpace($version)) { throw 'expected version output' }

# should fail for an unexpected positional argument
$succeeded = $true
try {
  & script.ps1 definitely-bogus 1> invalid.out.log 2> invalid.err.log
} catch {
  $succeeded = $false
}
if ($succeeded) { throw 'expected script.ps1 definitely-bogus to fail' }

# should explain the positional argument failure
Get-Content invalid.err.log | Select-String -Pattern 'does not accept positional arguments yet'
```

## Destroy tests

```powershell
# should remove the cli-contract failure logs
Remove-Item invalid.out.log,invalid.err.log -Force -ErrorAction SilentlyContinue
```
