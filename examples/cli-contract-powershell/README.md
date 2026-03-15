# Script PowerShell CLI Contract Example

This example keeps coverage on the PowerShell-facing contract of `script.ps1`: help output, version
output, and a clear failure for unexpected positional arguments.

## Setup

```powershell
# should reset the example scratch directory
Remove-Item -Recurse -Force .tmp -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path .tmp | Out-Null
```

## Testing

```powershell
# should show the debug flag in help output
script.ps1 -Help | Select-String -Pattern '-Debug'

# should show the version flag in help output
script.ps1 -Help | Select-String -Pattern '-Version'

# should print a version string
$version = script.ps1 -Version
if ([string]::IsNullOrWhiteSpace($version)) { throw 'expected version output' }

# should fail for an unexpected positional argument
$stderrPath = Join-Path .tmp 'invalid.err.log'
$stdoutPath = Join-Path .tmp 'invalid.out.log'
$succeeded = $true
try {
  script.ps1 definitely-bogus 1> $stdoutPath 2> $stderrPath
} catch {
  $succeeded = $false
}
if ($succeeded) { throw 'expected script.ps1 definitely-bogus to fail' }

# should explain the positional argument failure
Get-Content $stderrPath | Select-String -Pattern 'does not accept positional arguments yet'
```

## Destroy tests

```powershell
# should remove the example scratch directory
Remove-Item -Recurse -Force .tmp -ErrorAction SilentlyContinue
```
