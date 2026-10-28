---
name: pixi-skill
description: Manage project-specific, reproducible bioinformatics environments using pixi. This skill ensures that all tools (from Conda, Bioconda, and PyPI) are locked to specific versions, enabling one-click reproducibility across different machines and AI agents.
version: 7
updated: "2026-10-28"
triggers:
  - "set up environment"
  - "pixi install"
  - "conda environment"
  - "manage dependencies"
  - "pixi env"
  - "reproducible environment"
  - "bioconda environment"
  - "install bioinformatics tools"
  - "pixi add"
  - "environment lockfile"
  - "project dependencies"
  - "pixi run"
  - "dependency conflict"
  - "pixi feature environment"
  - "exclude-newer"
  - "pixi global install"
---

# Skill: pixi-skill

## Description

Manage project-specific, reproducible bioinformatics environments using `pixi`. This skill ensures that all tools (from Conda, Bioconda, and PyPI) are locked to specific versions, enabling "one-click" reproducibility across different machines and AI agents.

## When to Use

- Initializing a new bioinformatics project.
- Adding new tools to an existing pipeline.
- Resolving dependency conflicts between biological software.
- Verifying that a project's environment is exactly as defined in the lockfile.
- Creating reusable task aliases for complex CLI commands.

## Installation

This skill requires `pixi`. If not already installed, run the following command:

```bash
curl -fsSL https://pixi.sh/install.sh | sh
```

Restart your terminal after installation to ensure `pixi` is in your PATH.

## Procedure

### 1. Project Initialization

Before adding tools, the project root must be initialized as a pixi workspace.

```bash
pixi init
# Set the essential channels for bioinformatics
pixi workspace channel add conda-forge
pixi workspace channel add bioconda
```

### 2. Dependency Addition

Add tools based on their source. Always prefer Conda/Bioconda for core bioinformatics binaries.

- **Standard Conda/Bioconda**:
  
  ```bash
  pixi add <package_name>
  ```

- **PyPI Packages**:
  
  ```bash
  pixi add --pypi <package_name>
  ```

- **Git-based Tools** (for cutting-edge research tools):
  
  ```bash
  pixi add -g <git-url> --branch <branch-name>
  ```

### 3. Pipeline Orchestration via Tasks

Instead of writing long shell strings in other skills, use `pixi task` to create named, version-locked aliases.

```bash
# Example: Adding a 'clean-reads' task to the project
pixi task add clean-reads "fastp -i data/R1.fq.gz -I data/R2.fq.gz -o results/R1_trim.fq.gz -O results/R2_trim.fq.gz --json results/fastp.json"
```

Run the task using: `pixi run clean-reads`.

For multi-step pipelines, chain tasks with `--depends-on` instead of one long shell string — each stage stays independently runnable and cacheable:

```bash
pixi task add trim "fastp -i data/R1.fq.gz -I data/R2.fq.gz -o results/R1_trim.fq.gz -O results/R2_trim.fq.gz"
pixi task add align "bwa mem ref.fa results/R1_trim.fq.gz results/R2_trim.fq.gz > results/aln.sam" --depends-on trim
pixi run align   # runs trim first, then align
```

### 4. Multiple Environments for Clashing Tools

When two tools can't share one solve (different Python pins, `setuptools<81` for CheckM, an old tool pinning an ancient `libgcc`), don't create a second project or a `pixi.toml` per tool/sub-pipeline. Keep **one manifest and one lockfile**, and move only the clashing tool into a **feature** with its own **environment**:

```bash
# 1. Everything that co-solves stays in the default feature
pixi add python=3.9 seqkit samtools

# 2. The clashing tool (plus its fix-ups) goes into a named feature
pixi add --feature checkm checkm-genome "setuptools<81"

# 3. Give that feature its own environment, WITHOUT the default deps (that's what avoids the clash)
pixi workspace environment add checkm --feature checkm --no-default-feature

# 4. Tasks can belong to the feature too
pixi task add --feature checkm checkm-qc "checkm lineage_wf bins/ checkm_out/"

pixi lock                              # solves default AND checkm into the one pixi.lock
pixi run -e checkm checkm-qc           # run in the isolated env
pixi run -e checkm python -V           # ad-hoc command in that env
```

Resulting manifest:

```toml
[dependencies]
python = "3.9.*"
seqkit = ">=2.14.0,<3"

[feature.checkm.dependencies]
checkm-genome = "*"
setuptools = "<81"

[feature.checkm.tasks]
checkm-qc = "checkm lineage_wf bins/ checkm_out/"

[environments]
checkm = { features = ["checkm"], no-default-feature = true }
```

- **Split only on a real clash.** Try the normal `pixi add` first. Isolate a tool only when the solve fails, because each extra environment costs a full solve (the files themselves are hard-linked from the shared cache).
- **Always pass `-e <env>` from agents.** Pixi picks the environment for a task when only one environment has it, but when the task is ambiguous it opens an interactive picker, which blocks a captured shell.
- **`--no-default-feature` is the point.** Without it the environment inherits `[dependencies]`, and you get the same clash again.
- A spec added with `--feature` before its environment exists is saved as `"*"`. It's still pinned in `pixi.lock`. Run `pixi upgrade --feature <name>` if you want a range written into `pixi.toml`.
- Opposite case: to keep several environments on **identical** versions of shared deps (e.g. `default` + `test`), give them the same `solve-group`. Never use `solve-group` for a clashing tool, since it forces a joint solve, which is exactly what fails.

Deeper reference: `docs-corpus/pixi/features/tutorials_multi_environment.md`.

### 5. One-Off Scripts with PEP 723 (pixi >= 0.76)

For a standalone analysis script with pinned dependencies — no project scaffold needed — use a PEP 723 inline-metadata block. Pixi reads it, resolves a cached environment, and runs the file:

```bash
pixi init --script analyze.py          # add a PEP 723 block to an existing .py
pixi add --script analyze.py rich      # conda dep into the block
pixi add --script analyze.py --pypi httpx
pixi run --script analyze.py           # resolve (cached), run
pixi lock --script analyze.py          # pin a lockfile when reproducibility matters
```

The block itself (written by the commands above — do not hand-edit when a command exists):

```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["rich>=13.9.2"]
# [tool.pixi.dependencies]
# seqkit = "*"
# ///
```

Conda deps/channels live in `tool.pixi` tables inside the block. `--script` also works on `remove`, `lock`, `list`, and `tree`.

### 6. Agent-Safe, Non-Interactive Execution

An AI agent driving `pixi` should avoid ANSI progress bars and nested subshells polluting captured output:

- **Suppress progress bars**: progress bars are already off automatically when stderr isn't a terminal (captured shells). To force it, pass `--no-progress` or set `PIXI_NO_PROGRESS=true`. **Not `=1`**: pixi (0.81) parses it as a boolean and rejects `1`, and then *every* pixi command fails with `invalid value '1' for '--no-progress'`.

- **Activate without spawning a subshell**: use `pixi shell-hook` to print the activation script and `eval` it in the current shell, rather than `pixi shell` (which opens an interactive nested shell an agent can't cleanly exit).
  
  ```bash
  eval "$(pixi shell-hook)"
  ```

- **Offline verification**: after a successful `pixi install --locked`, prove the cache fully covers the lockfile with `pixi install --locked --offline` (pixi >= 0.74; solves from the local package cache / `file://` channels only — pixi >= 0.75). Useful on air-gapped/HPC nodes and in CI. A failed offline solve means the cache is incomplete — re-run online; never loosen pins to "fix" it.

### 7. Environment Verification & Stability

To ensure an agent is working with a stable environment (especially before a long run):

- **Check Lock Integrity**: Run `pixi install --locked`. This aborts if the `pixi.lock` is not up-to-date with `pixi.toml`.
- **Version Audit**: Run `pixi list` to verify that the installed version of a tool matches the expected scientific version.

### 8. Pinning the Solve with `exclude-newer`

A lockfile pins the *resolved* artifacts. `exclude-newer` pins the *solve itself* — it excludes every
package published after a cutoff from consideration, so a re-solve on a future machine picks the same
versions even when the lockfile is not carried along. It is a workspace-level key and applies to
**every** environment in the manifest:

```toml
[workspace]
exclude-newer = "2026-10-01T00:00:00Z"   # RFC 3339 timestamp
# exclude-newer = "2026-10-01"           # YYYY-MM-DD (interpreted as the START of the next day, UTC)
# exclude-newer = "7d"                   # relative duration
```

- **Use it when the environment must resolve identically on every machine** — a skill that ships a
  `pixi.toml` to other users and agents is exactly that case. It is the reproducibility lever that
  survives the lockfile being gitignored.
- **Use it when `pixi.lock` is not committed.** A regenerable lockfile means a fresh solve on a new
  machine; `exclude-newer` bounds that solve to a known-good window.
- **It is a cutoff, not a pin.** It excludes newer packages, it does not require specific ones. Combine
  it with explicit version constraints in `[dependencies]` for full control.
- The **global** manifest supports `exclude-newer` too (pixi >= 0.82.0), so a machine-wide
  `pixi global` install can be bounded the same way.
- Refresh it deliberately: a cutoff that is too old eventually makes a needed package unresolvable.

Deeper reference: `docs-corpus/pixi/features/reference_pixi_manifest.md` (the `exclude-newer` entry).

## Pitfalls

- **Channel Conflict**: Adding channels in the wrong order or missing `conda-forge` can lead to solve failures in bioconda. Always prioritize `conda-forge` and `bioconda`.
- **Global vs Local**: Do not use `pixi global install` for project-specific tools. This breaks portability and reproducibility. (`pixi global` is a separate, machine-wide manifest for exposing standalone CLI tools — e.g. a linter you want on PATH everywhere — not for pipeline dependencies.) Its manifest lives in `~/.pixi/manifest.toml`, *outside* the project, so nothing about it travels with a repo. Concretely:
  - Use `pixi global` for **machine-wide developer tooling that is not part of the project's deliverable** — a formatter, a linter, `nextflow` for a runner you invoke by hand.
  - Use a **project manifest** for everything the project actually runs, so the tool set travels with the repo and is reviewable in a PR.
  - **conda-forge is the only default channel for `pixi global`** (pixi 0.83.0 changelog #7285). A bioconda tool needs an explicit `--channel bioconda`; the channel list in `pixi.toml` does not apply.
  - `pixi global` isolates each package in its own environment and exposes only the needed entry points (pipx-like), so it will not clobber a project env — but it also will not satisfy one.
  - `pixi global install` (packages as arguments) and `pixi global add --environment <env>` (declared in the global manifest, then `pixi global sync`) are the two entry points; the second is the reproducible one because the manifest is a file you can review.
- **No `pixi.lock` in the repo**: if the lockfile is not committed, `pixi install --locked` fails on a fresh clone with `Error: lock file not up-to-date with the workspace`, and a re-solve picks whatever is newest at that moment. Either commit `pixi.lock`, or bound the solve with `exclude-newer` (§8) — or both.
- **PyPI vs Conda**: Prefer the Conda version of a tool if available; only use `--pypi` if the tool is exclusively on PyPI.
- **Unmanaged Pip Installs**: CRITICAL: Never run `pip install` directly inside a `pixi shell` or `pixi run` command. This creates "ghost dependencies" that are not recorded in `pixi.toml` and will disappear on the next environment sync, breaking reproducibility. Always use `pixi add --pypi`.
- **Two projects / one `pixi.toml` per tool to dodge a clash**: duplicates the base env, splits the lockfile, and makes every caller track which manifest to use. Use a feature + environment (§4) inside the one manifest instead.
- **Implicit Python Versions**: If a tool requires a specific Python version, specify it explicitly during `pixi add` (e.g., `pixi add python=3.10`).
- **Deprecated manifest forms (pixi >= 0.71)**: do not emit `[system-requirements]` — use rich platform entries on `workspace.platforms` (e.g. `platforms = [{platform = "linux-64", cuda = "12.0"}]`); do not emit `conda-pypi-map = "file.json"` (since 0.71 a bare location is an **overlay** by default — use the explicit `{location = "...", mapping-mode = "replace"}` form); for git source deps use `--subdirectory` (not the old `--subdir`); `pixi build` no longer exists (merged into `pixi publish`).
- **`[project]` is the deprecated alias for `[workspace]`** — not the reverse (pixi 0.83.0 changelog #7086). A `[project]`-headed manifest still parses but emits `WARN The 'project' field is deprecated. Use 'workspace' instead.` on every command that reads it. Emit `[workspace]`. (`pixi init` writes `[workspace]`.)

## Verification

- [ ] `pixi.toml` exists in the project root.
- [ ] `pixi.lock` is present and consistent (`pixi install --locked` passes) — or, if the lockfile is deliberately not committed, `exclude-newer` bounds the solve (§8).
- [ ] All required tools are executable via `pixi run <tool> --version`.
- [ ] Required channels (`conda-forge`, `bioconda`) are listed under the `channels` section of `pixi.toml`.
- [ ] If `[environments]` exists: every isolated env runs its tool (`pixi run -e <env> <tool> --version`).
- [ ] The manifest header is `[workspace]`, not the deprecated `[project]`.

## Docs-Corpus

`docs-corpus/pixi/` holds an offline CLI reference (`cli-reference.md`, captured from the installed `pixi --version` — regenerate with `./capture.sh` after any `pixi self-update`) plus feature deep-dives (multi-environment/features incl. inline `[environments.*.dependencies]`, task DAGs, manifest schema incl. rich platforms, `pyproject.toml` workspaces, `PIXI_*` env vars, PEP 723 script environments, offline solves, and the `pixi global` model). Check there before guessing a flag.

The `features/*.md` files are the **upstream Markdown source at the release tag matching the installed binary** (`raw.githubusercontent.com/prefix-dev/pixi/<tag>/docs/...`), with the rendered pages kept in `_raw/*.html`. Refresh both the tag and `cli-reference.md` together after a `pixi self-update` — the subcommand list in `capture.sh` is derived from `pixi --help` at capture time, so it picks up new subcommands automatically.
