# template-netscript

`template-netscript` is a GitHub template starter for repositories whose main product is hosted
Bash and PowerShell scripts. The primary entrypoints live at repo root, support tooling lives under
`scripts/`, and `dist/script.sh` plus `dist/script.ps1` are the release-shaped artifacts that
Netlify serves.

> Supports Bash on macOS and Linux plus PowerShell on Windows.

## Quickstart

```sh
curl -fsSL https://script.tanaab.sh/script.sh | bash
```

```powershell
irm https://script.tanaab.sh/script.ps1 | iex
```

## Installation

`template-netscript` is designed around hosted raw scripts at `https://script.tanaab.sh/script.sh`
and `https://script.tanaab.sh/script.ps1`.

- The Bash path requires Bash and cURL.
- The PowerShell path requires PowerShell.
- The hosted URLs serve the generated `dist/script.sh` and `dist/script.ps1` entrypoints used for
  release-shaped validation and Netlify publishing.
- In a repository created from this template, replace `script.sh`, `script.ps1`, and
  `https://script.tanaab.sh` before publishing.

## Usage

The default starter behavior is intentionally small while you replace the placeholder command body.

```sh
script.sh --help
script.sh --version
DEBUG=1 script.sh
```

```powershell
script.ps1 -Help
script.ps1 -Version
$env:DEBUG = '1'
script.ps1
```

If you are working from a local checkout instead of a hosted URL, replace `script.sh` with
`./script.sh` and `script.ps1` with `./script.ps1`.

The `examples/` directory contains generic Leia-backed scenario folders for the Bash and PowerShell
CLI contract plus the default no-argument flow:

- `cli-contract-bash`
- `minimal-bash`
- `cli-contract-powershell`
- `minimal-powershell`

## Advanced

If you want a reusable local command instead of piping the hosted script every time, install it into
a directory that is already in your `PATH` or one you manage yourself.

```sh
mkdir -p "$HOME/.local/bin"
curl -fsSL https://script.tanaab.sh/script.sh -o "$HOME/.local/bin/script"
chmod +x "$HOME/.local/bin/script"

script --help
script --version
```

```powershell
$target = Join-Path $HOME 'bin\script.ps1'
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
Invoke-WebRequest https://script.tanaab.sh/script.ps1 -OutFile $target

& $target -Help
& $target -Version
```

If you are using this repository as a GitHub template, the adoption flow is:

1. Create a new repository from this template.
2. Rename `script.sh` and `script.ps1`, then update the same paths in `README.md`, `scripts/build-dist.js`,
   `site/index.html`, `netlify.toml`, `examples/`, and `.github/workflows/`.
3. Replace the placeholder command bodies in `script.sh` and `script.ps1`.
4. Replace the placeholder origin `https://script.tanaab.sh`.
5. Run the local checks before pushing.

## Development

`template-netscript` uses Bun for repo-local tooling and treats `dist/` as a tracked, Netlify-ready
release surface.

```sh
bun install
bun run lint
```

Use `bun run build` only when you intentionally want to refresh the tracked `dist/` publish surface
or inspect the release-shaped artifact locally.

The `examples/` directory exists as executable scenario coverage, and those scenarios are exercised
in CI with Leia on Ubuntu and macOS for Bash plus Windows for PowerShell. Repositories created from
this starter can decide later whether examples should stay CI-only, become local developer flows, or
move onto more specialized runners.

## Issues, Questions and Support

Use the [GitHub issue queue](https://github.com/tanaabased/template-netscript/issues) for bugs,
regressions, or feature requests.

## Changelog

See [`CHANGELOG.md`](./CHANGELOG.md) for release history and
[GitHub releases](https://github.com/tanaabased/template-netscript/releases) for published artifacts.

## Maintainers

- `@pirog`

## Contributors

<a href="https://github.com/tanaabased/template-netscript/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=tanaabased/template-netscript" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
