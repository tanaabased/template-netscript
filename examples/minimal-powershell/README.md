# Script PowerShell Minimal Example

This example is the smallest markdown-first smoke test for `script.ps1`. It runs the default
no-argument flow and verifies the placeholder output from the prepared `dist/script.ps1` artifact.

## Setup

```powershell
# should run the default placeholder flow
script.ps1 *> run.log
```

## Testing

```powershell
# should print the placeholder execution message
Get-Content run.log | Select-String -Pattern 'Replace the body of script.ps1 with your project logic.'
```

## Destroy tests

```powershell
# should remove the placeholder run log
Remove-Item run.log -Force -ErrorAction SilentlyContinue
```
