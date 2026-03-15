# Template Setup

`template-netscript` is meant to be copied, renamed, and simplified into a repo whose main product is
one or two hosted scripts served from Netlify.

This document has two jobs:

- describe the manual steps to turn this template into a real project
- act as a human-readable spec for AI-agent-driven setup

## Agent-Driven Setup

This document is also meant to work as an AI-agent setup spec. You can hand this file plus a small
set of inputs to an agent such as Codex and let it perform the repo adoption directly.

That is the preferred path while the template is still evolving.

## Agent Inputs

If you use an AI agent to adopt this template, give it these inputs up front:

- `project-slug`
- `github-owner`
- `public-origin`
- `script-basename`
- `runtime-support`: `bash`, `powershell`, or `both`
- `package-name`: optional, only if package publication is planned
- `description`: optional but useful

Everything else should be derived where possible.

## Copy-Paste Agent Prompt

Use this prompt as the default setup handoff for an AI agent:

```md
Use `TEMPLATE-SETUP.md` in this repository as the source of truth for adopting the template.

Inputs:

- project-slug: <replace>
- github-owner: <replace>
- public-origin: <replace>
- script-basename: <replace>
- runtime-support: <bash|powershell|both>
- package-name: <optional>
- description: <optional>

Tasks:

1. Follow `TEMPLATE-SETUP.md` in order.
2. Prune unsupported runtimes and remove their files, examples, workflows, and release logic.
3. Rename the kept script entrypoints and update all repo metadata, docs, workflow references, redirects, and build metadata to match the chosen name and origin.
4. Replace the placeholder script logic with project-specific logic only if requested; otherwise preserve the starter logic and just rename and re-scope it.
5. Reconfigure the hosted origin and Netlify-facing files to match the provided domain.
6. Intentionally refresh `dist` after source changes so tracked publish artifacts match the new repo.
7. Perform template cleanup after the setup is complete:
   - remove `TEMPLATE-SETUP.md`
   - remove the `TEMPLATE-SETUP.md` reference from `README.md`
   - reset `CHANGELOG.md` so it is immediately usable by `prepare-release-action`
   - keep the standard top header `## {{ UNRELEASED_VERSION }} - [{{ UNRELEASED_DATE }}]({{ UNRELEASED_LINK }})`
   - keep a single bullet under that header recording that the project was initialized from this template
   - remove or rewrite template-specific README sections that only make sense in the source template repo
   - remove any leftover `template-netscript`, `script.tanaab.sh`, `script.sh`, or `script.ps1` placeholders that should no longer exist
   - remove unused workflow files, examples, and runtime-specific config for dropped platforms
8. Run the relevant validation commands and report what was run and what could not be run.
9. Summarize:
   - runtime support kept
   - files removed
   - files renamed
   - final hosted URLs
   - any follow-up work still recommended

Use the smallest defensible diff that fully completes the adoption.
```

## Setup Order

Follow these steps in order. The later steps assume the earlier decisions are already made.

## 1. Choose Runtime Support

Decide which script surfaces the new repo will support:

- Bash on macOS and Linux via `script.sh`
- PowerShell on Windows via `script.ps1`
- both

Then prune the repo to match that decision.

If you keep Bash only:

- keep [script.sh](/Users/pirog/tanaab/template-netscript/script.sh)
- remove [script.ps1](/Users/pirog/tanaab/template-netscript/script.ps1)
- remove [examples/cli-contract-powershell/README.md](/Users/pirog/tanaab/template-netscript/examples/cli-contract-powershell/README.md)
- remove [examples/minimal-powershell/README.md](/Users/pirog/tanaab/template-netscript/examples/minimal-powershell/README.md)
- remove [.github/workflows/pr-powershell-examples-tests.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-powershell-examples-tests.yml)
- remove the `powershell-lint` job from [.github/workflows/pr-linter.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-linter.yml)
- remove the Windows release job from [.github/workflows/release-tests.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/release-tests.yml)
- remove PowerShell references from [netlify.toml](/Users/pirog/tanaab/template-netscript/netlify.toml), [site/index.html](/Users/pirog/tanaab/template-netscript/site/index.html), and [scripts/build-dist.js](/Users/pirog/tanaab/template-netscript/scripts/build-dist.js)

If you keep PowerShell only:

- keep [script.ps1](/Users/pirog/tanaab/template-netscript/script.ps1)
- remove [script.sh](/Users/pirog/tanaab/template-netscript/script.sh)
- remove [examples/cli-contract-bash/README.md](/Users/pirog/tanaab/template-netscript/examples/cli-contract-bash/README.md)
- remove [examples/minimal-bash/README.md](/Users/pirog/tanaab/template-netscript/examples/minimal-bash/README.md)
- remove [.github/workflows/pr-bash-examples-tests.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-bash-examples-tests.yml)
- remove the `bash-lint` job from [.github/workflows/pr-linter.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-linter.yml)
- remove the Bash release job from [.github/workflows/release-tests.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/release-tests.yml)
- remove Bash references from [netlify.toml](/Users/pirog/tanaab/template-netscript/netlify.toml), [site/index.html](/Users/pirog/tanaab/template-netscript/site/index.html), and [scripts/build-dist.js](/Users/pirog/tanaab/template-netscript/scripts/build-dist.js)

If you keep both:

- keep the current runtime split
- only rename and replace placeholders in later steps

## 2. Rename Scripts And Replace Repo Identity

Pick the final script basename first. The template assumes `script`, but a real repo should replace
that with the actual project name.

At minimum, update:

- [script.sh](/Users/pirog/tanaab/template-netscript/script.sh) and or [script.ps1](/Users/pirog/tanaab/template-netscript/script.ps1)
- [dist/script.sh](/Users/pirog/tanaab/template-netscript/dist/script.sh) and or [dist/script.ps1](/Users/pirog/tanaab/template-netscript/dist/script.ps1) after rebuilding
- [README.md](/Users/pirog/tanaab/template-netscript/README.md)
- [scripts/build-dist.js](/Users/pirog/tanaab/template-netscript/scripts/build-dist.js)
- [site/index.html](/Users/pirog/tanaab/template-netscript/site/index.html)
- [package.json](/Users/pirog/tanaab/template-netscript/package.json)
- [CHANGELOG.md](/Users/pirog/tanaab/template-netscript/CHANGELOG.md)
- [`.github/workflows/`](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-bash-examples-tests.yml)
- the example README files under [examples/](/Users/pirog/tanaab/template-netscript/examples/cli-contract-bash/README.md)

Replace all template identity placeholders too:

- `template-netscript`
- `script.tanaab.sh`
- `script.sh`
- `script.ps1`
- `@tanaabased/template-netscript`
- `tanaabased/template-netscript`

If the new repo will publish a real package later, also update the package name, description,
repository URL, bugs URL, and any org or maintainer metadata in [package.json](/Users/pirog/tanaab/template-netscript/package.json).

## 3. Replace The Placeholder Script Logic

Both starter entrypoints intentionally ship with minimal behavior:

- help output
- version output
- debug toggles
- one placeholder execution path

The next real customization step is to replace the placeholder command body in:

- [script.sh](/Users/pirog/tanaab/template-netscript/script.sh)
- [script.ps1](/Users/pirog/tanaab/template-netscript/script.ps1)

Keep the top-level `SCRIPT_VERSION` assignment intact so release stamping continues to work with
`prepare-release-action`.

If the real project eventually needs strict positional handling, subcommands, or richer option
parsing, introduce that after the repo has been renamed and the hosted path is working.

## 4. Configure Hosting And Netlify

This template assumes Netlify publishes the tracked [dist/](/Users/pirog/tanaab/template-netscript/dist) directory.

Set up the new repo so that:

- Netlify publishes `dist`
- the custom domain points at the repo's real hosted origin
- the final origin replaces `https://script.tanaab.sh` everywhere
- the raw script headers in [netlify.toml](/Users/pirog/tanaab/template-netscript/netlify.toml) still match the kept script types
- the landing page in [site/index.html](/Users/pirog/tanaab/template-netscript/site/index.html) redirects to the correct default script

After the custom domain is known, update the canonical origin in:

- [README.md](/Users/pirog/tanaab/template-netscript/README.md)
- [scripts/build-dist.js](/Users/pirog/tanaab/template-netscript/scripts/build-dist.js)

Then intentionally rebuild `dist` so [dist/robots.txt](/Users/pirog/tanaab/template-netscript/dist/robots.txt) and [dist/sitemap.xml](/Users/pirog/tanaab/template-netscript/dist/sitemap.xml) match the real domain.

## 5. Review CI And Release Scope

Runtime pruning changes the CI and release contract, not just the file tree.

Before shipping the new repo, make sure:

- the example workflows only test the runtimes you kept
- [.github/workflows/pr-linter.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/pr-linter.yml) only lints the maintained surfaces
- [.github/workflows/release-tests.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/release-tests.yml) only verifies the artifacts you still publish
- [.github/workflows/release.yml](/Users/pirog/tanaab/template-netscript/.github/workflows/release.yml) only stamps the entrypoints you still ship
- example names, runner names, and docs still match the real runtime support

If the repo no longer ships one of the two script types, remove its `version-injector` step instead
of leaving dead release logic behind.

## 6. Template Cleanup

Once the new repo identity is in place, remove template-only traces so the adopted repository looks
native rather than “generated from a template”.

At minimum, clean up:

- [TEMPLATE-SETUP.md](/Users/pirog/tanaab/template-netscript/TEMPLATE-SETUP.md)
- the `TEMPLATE-SETUP.md` reference in [README.md](/Users/pirog/tanaab/template-netscript/README.md)
- [CHANGELOG.md](/Users/pirog/tanaab/template-netscript/CHANGELOG.md), resetting it so it is immediately useful for `prepare-release-action`
- any README wording that only makes sense in the source template repo, especially the “If you are using this repository as a GitHub template” framing
- leftover `template-netscript` naming in docs and metadata
- leftover `script.tanaab.sh` placeholder references once the real domain is known
- workflow files, examples, and runtime-specific config for any dropped runtime

For `CHANGELOG.md`, do not keep this template repo's release history in the adopted project.

Reset it to this exact starting shape:

```md
## {{ UNRELEASED_VERSION }} - [{{ UNRELEASED_DATE }}]({{ UNRELEASED_LINK }})

- Initialized this project from `tanaabased/template-netscript`.
```

That gives `prepare-release-action` a clean file to update on the first real release instead of
carrying forward irrelevant template history.

Do not leave both the adopted project identity and template instructions in the same repo unless that
is an explicit product choice.

## 7. Refresh Dist And Verify The Hosted Surface

Once naming, hosting, and runtime support are settled:

1. Run `bun install`
2. Run `bun run lint`
3. Intentionally run `bun run build`
4. Review the contents of `dist`
5. Verify the local release-shaped entrypoints
6. Verify the actual hosted install commands from the README

The important check is not just whether source files look right. The important check is whether the
generated `dist` surface matches the docs and the real hosted URLs.

That is the reason this document is checklist-shaped rather than purely narrative.
