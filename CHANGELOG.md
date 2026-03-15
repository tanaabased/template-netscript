## {{ UNRELEASED_VERSION }} - [{{ UNRELEASED_DATE }}]({{ UNRELEASED_LINK }})

## v1.0.0-beta.1 - [March 15, 2026](https://github.com/tanaabased/template-netscript/releases/tag/v1.0.0-beta.1)

- Added [TEMPLATE-SETUP.md](./TEMPLATE-SETUP.md) as the agent-driven template adoption and seeding spec, including a copy-paste prompt plus cleanup and changelog-reset rules.
- Added Bash and PowerShell starter entrypoints at repo root for hosted script repositories on macOS, Linux, and Windows.
- Added CI linting for the maintained shell surfaces with `shellcheck` for Bash and `PSScriptAnalyzer` for PowerShell.
- Added Netlify-ready tracked `dist/` publishing for both `script.sh` and `script.ps1`, plus landing-page, robots, and sitemap metadata.
- Added release workflows that stamp both distributed entrypoints with `prepare-release-action` and verify the shipped artifacts before release.
- Added runtime-specific Leia example suites for Bash and PowerShell, with Bash coverage on Ubuntu and macOS plus PowerShell coverage on Windows.
- Documented the starter's hosted install, local usage, and agent-driven post-fork setup flow for both runtime paths.
