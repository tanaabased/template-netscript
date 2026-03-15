<#
.SYNOPSIS
Minimal hosted PowerShell starter for Windows.

.DESCRIPTION
Replace the placeholder command body in Invoke-RunCli with your project behavior.

.EXAMPLE
./script.ps1 -Help

.EXAMPLE
./script.ps1 -Version

.EXAMPLE
$env:DEBUG = '1'
./script.ps1

Run `./script.ps1 -Help` for more advanced usage.
#>
[CmdletBinding()]
param(
  [switch]$Help,
  [switch]$Version,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Positionals
)

Set-StrictMode -Version 3
$ErrorActionPreference = 'Stop'

$CLI_NAME = if ($PSCommandPath) { Split-Path -Leaf $PSCommandPath } else { $MyInvocation.MyCommand.Name }
# Keep a single top-level assignment so release automation can stamp the entrypoint in place.
$SCRIPT_VERSION = if (-not [string]::IsNullOrWhiteSpace($env:SCRIPT_VERSION)) { $env:SCRIPT_VERSION } else { try { $resolved = (& git describe --tags --always --abbrev=1 2>$null | Out-String).Trim(); if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($resolved)) { $resolved } else { '0.0.0-dev' } } catch { '0.0.0-dev' } }
$ESCAPE = [char]27
$USE_COLOR = $false
$script:DebugEnabled = $false

function Test-Truthy {
  param([AllowNull()][object]$Value)

  $normalized = ''
  if (-not [string]::IsNullOrWhiteSpace([string]$Value)) {
    $normalized = ([string]$Value).Trim().ToLowerInvariant()
  }

  switch ($normalized) {
    '' { return $false }
    '0' { return $false }
    'false' { return $false }
    'no' { return $false }
    'off' { return $false }
    default { return $true }
  }
}

# Normalize debug preference using the common -Debug parameter plus env fallbacks.
$DebugPreference = if (
  $PSBoundParameters.ContainsKey('Debug') -or
  (Test-Truthy $env:DEBUG) -or
  (Test-Truthy $env:RUNNER_DEBUG)
) {
  'Continue'
} else {
  $DebugPreference
}

if ($DebugPreference -eq 'Inquire' -or $DebugPreference -eq 'Continue') {
  $script:DebugEnabled = $true
}

function Test-ColorEnabled {
  if (-not [string]::IsNullOrWhiteSpace($env:NO_COLOR)) {
    return $false
  }

  if (Test-Truthy $env:FORCE_COLOR) {
    return $true
  }

  if (
    $env:OS -eq 'Windows_NT' -and
    $PSVersionTable.PSVersion.Major -lt 7 -and
    [string]::IsNullOrWhiteSpace($env:WT_SESSION) -and
    [string]::IsNullOrWhiteSpace($env:TERM)
  ) {
    return $false
  }

  try {
    return (-not [Console]::IsOutputRedirected) -or (-not [Console]::IsErrorRedirected)
  } catch {
    return $true
  }
}

function Format-Style {
  param(
    [string]$Code,
    [string]$Text
  )

  if (-not $script:USE_COLOR) {
    return $Text
  }

  return '{0}[{1}m{2}{0}[0m' -f $script:ESCAPE, $Code, $Text
}

function bold {
  param([string]$Text)
  return Format-Style -Code '1;39' -Text $Text
}

function dim {
  param([string]$Text)
  return Format-Style -Code '2;39' -Text $Text
}

function red {
  param([string]$Text)
  return Format-Style -Code '1;31' -Text $Text
}

function tp {
  param([string]$Text)
  return Format-Style -Code '38;2;0;200;138' -Text $Text
}

function ts {
  param([string]$Text)
  return Format-Style -Code '38;2;219;39;119' -Text $Text
}

function Expand-Message {
  param(
    [AllowNull()][object]$Message,
    [object[]]$MessageArgs = @()
  )

  $normalized = if ($Message -is [string]) {
    $Message
  } else {
    ($Message | Out-String).TrimEnd()
  }

  if ($MessageArgs.Count -gt 0) {
    return $normalized -f $MessageArgs
  }

  return $normalized
}

function Write-StreamLine {
  param(
    [ValidateSet('stdout', 'stderr')]
    [string]$Stream = 'stdout',
    [string]$Message = ''
  )

  if ($Stream -eq 'stderr') {
    [Console]::Error.WriteLine($Message)
    return
  }

  [Console]::Out.WriteLine($Message)
}

function Write-StatusLine {
  param(
    [ValidateSet('stdout', 'stderr')]
    [string]$Stream,
    [string]$Label,
    [scriptblock]$Colorizer,
    [AllowNull()][object]$Message = '',
    [object[]]$MessageArgs = @()
  )

  $text = Expand-Message -Message $Message -MessageArgs $MessageArgs
  Write-StreamLine -Stream $Stream -Message ('{0}: {1}' -f (& $Colorizer $Label), $text)
}

function debug {
  param(
    [AllowNull()][object]$Message = '',
    [object[]]$MessageArgs = @()
  )

  if (-not $script:DebugEnabled) {
    return
  }

  $text = Expand-Message -Message $Message -MessageArgs $MessageArgs
  Write-StreamLine -Stream 'stderr' -Message ('{0} {1}' -f (dim 'debug'), $text)
}

function note {
  param(
    [AllowNull()][object]$Message = '',
    [object[]]$MessageArgs = @()
  )

  Write-StatusLine -Stream 'stdout' -Label 'note' -Colorizer ${function:ts} -Message $Message -MessageArgs $MessageArgs
}

function fail {
  param(
    [string]$Message,
    [int]$ExitCode = 1
  )

  Write-StatusLine -Stream 'stderr' -Label 'error' -Colorizer ${function:red} -Message $Message
  throw ([System.Exception]::new(('exit {0}: {1}' -f $ExitCode, $Message)))
}

function Show-Version {
  Write-StreamLine -Stream 'stdout' -Message $script:SCRIPT_VERSION
}

function Show-Usage {
  param(
    [Parameter(Mandatory)]
    [bool]$DebugEnabled
  )

  $debugDisplay = if ($DebugEnabled) { 'on' } else { 'off' }
  $lines = @(
    ('Usage: {0} {1}' -f (bold $script:CLI_NAME), (dim '[-Debug] [-Version] [-Help] [arguments...]'))
    ''
    ('{0}:' -f (tp 'Options'))
    ('  -Debug    enable debug logging {0}' -f (dim ('[default: {0}]' -f $debugDisplay)))
    ('  -Version  print the script version {0}' -f (dim ('[default: {0}]' -f $script:SCRIPT_VERSION)))
    '  -Help     show this help message'
    ''
    'This starter intentionally has no product logic yet.'
    ('Replace the body of {0} with your project behavior.' -f $script:CLI_NAME)
  )

  Write-StreamLine -Stream 'stdout' -Message ($lines -join [Environment]::NewLine)
}

function Invoke-RunCli {
  if ($script:Resolved.Positionals.Count -gt 0) {
    $joined = ($script:Resolved.Positionals -join ' ')
    fail ('This starter does not accept positional arguments yet: {0}.' -f (bold $joined))
  }

  debug 'running placeholder command body'
  note 'Replace the body of {0} with your project logic.' $script:CLI_NAME
}

$script:USE_COLOR = Test-ColorEnabled

$script:Resolved = [pscustomobject]@{
  Debug = $script:DebugEnabled
  Positionals = @($Positionals)
}

if ($Help) {
  Show-Usage -DebugEnabled $script:Resolved.Debug
  return
}

if ($Version) {
  Show-Version
  return
}

Invoke-RunCli
