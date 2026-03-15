# Script PowerShell Minimal Example

This example is the smallest markdown-first smoke test for `script.ps1`. It runs the default
no-argument flow and verifies the placeholder output from the prepared `dist/script.ps1` artifact.

## Setup

```powershell
# should reset the example scratch directory
Remove-Item -Recurse -Force .tmp -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path .tmp | Out-Null

# should run the default placeholder flow
script.ps1 *> .tmp/run.log
```

## Testing

```powershell
# should print the placeholder execution message
Get-Content .tmp/run.log | Select-String -Pattern 'Replace the body of script.ps1 with your project logic.'
```

## Destroy tests

```powershell
# should remove the example scratch directory
Remove-Item -Recurse -Force .tmp -ErrorAction SilentlyContinue
```
