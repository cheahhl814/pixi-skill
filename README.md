# pixi-skill

[![Version](https://img.shields.io/badge/version-7-blue)](#-installation)
[![Type](https://img.shields.io/badge/type-agent%20skill-blueviolet)](#-installation)
[![Built with](https://img.shields.io/badge/built%20with-skill--forge-orange)](https://github.com/cheahhl814/skill-forge)

Manage project-specific, reproducible bioinformatics environments using pixi. This skill ensures that all tools (from Conda, Bioconda, and PyPI) are locked to specific versions, enabling one-click reproducibility across different machines and AI agents.

**Repository**: https://github.com/cheahhl814/pixi-skill

> [!NOTE]
> Current version: **v7** (updated 2026-10-28). Docs corpus refreshed against **pixi 0.83.0**.

## Contents

- [Installation](#-installation)
- [Usage](#-usage)
- [What the skill covers](#-what-the-skill-covers)
- [Tools](#-tools)
- [Update check](#-update-check)
- [Repository layout](#-repository-layout)
- [Hard guarantees](#-hard-guarantees)
- [Provenance](#-provenance)

## 🚀 Installation

This is an **agent skill**, not a user-facing library. It is a single instruction file (`SKILL.md`) plus an
offline documentation corpus — **it has no environment of its own**, so there is nothing to `pixi install`
here. The one prerequisite is the `pixi` binary, which the skill then drives for *your* project.

**Option A — give your agent this prompt (recommended):**

```text
Install the pixi-skill skill from
https://github.com/cheahhl814/pixi-skill —
clone it into your agent's skills directory (the path your agent watches
for skills), then read the skill's SKILL.md. Confirm that `pixi --version`
works on this machine; if it does not, install it with
`curl -fsSL https://pixi.sh/install.sh | sh`.
```

**Option B — manual install:**

```bash
git clone https://github.com/cheahhl814/pixi-skill.git
cd pixi-skill
pixi --version   # prerequisite: the pixi CLI itself
```

> [!TIP]
> The skill teaches you to build a *project* `pixi.toml` with a committed `pixi.lock`, a pinned
> `exclude-newer` cutoff, and feature-scoped environments for tools that clash. It deliberately does
> **not** use `pixi global` for project dependencies — see the *Global vs Local* pitfall in `SKILL.md`.

## 💡 Usage

The skill is designed to be driven by an AI agent: the agent reads `SKILL.md` and applies the
procedure that matches the task. There are no phase sub-skills and no `pixi run` tasks — the skill's
sections are the procedure.

### Natural-language prompts that trigger the skill

```text
set up environment
pixi install
conda environment
manage dependencies
pixi env
install bioinformatics tools
pixi feature environment
exclude-newer
```

### Applying the procedure yourself

The sections of `SKILL.md`, in order of use:

```bash
# §1 Project initialization — one manifest, one lockfile
pixi init
pixi workspace channel add conda-forge
pixi workspace channel add bioconda

# §2 Dependency addition — conda/bioconda first, --pypi only for PyPI-only tools
pixi add fastp seqkit
pixi add --pypi some-pypi-only-tool

# §3 Task aliases — `pixi run <task>` instead of long shell strings
pixi task add trim "fastp -i in.fq.gz -o out.fq.gz"
pixi task add align "bwa mem ref.fa out.fq.gz > out.sam" --depends-on trim
pixi run align

# §4 Clashing tools — feature + environment in the SAME manifest, not a second project
pixi add --feature checkm checkm-genome "setuptools<81"
pixi workspace environment add checkm --feature checkm --no-default-feature
pixi run -e checkm checkm-qc

# §5 One-off scripts — PEP 723 inline metadata, no project scaffold
pixi run --script analyze.py

# §6 Agent-safe execution — no ANSI progress bars, no nested subshell
eval "$(pixi shell-hook)"

# §7 Verification
pixi install --locked
pixi list

# §8 Bounding the solve — survives a lockfile that is not carried along
#    (add `exclude-newer = "2026-10-01"` to the [workspace] table)
```

> [!IMPORTANT]
> `pixi run` picks the environment for a task when only one environment has it, but opens an
> **interactive picker** when the task is ambiguous — which hangs a captured shell. Always pass
> `-e <env>` explicitly from an agent.

## 🧭 What the skill covers

| Section | Question it answers |
|:--------|:--------------------|
| §1 Project initialization | How do I start a project-scoped pixi workspace with the right channels? |
| §2 Dependency addition | Conda/Bioconda vs `--pypi` vs git-sourced tools? |
| §3 Pipeline orchestration | How do I turn long shell strings into named, runnable tasks? |
| §4 Multiple environments | Two tools won't co-solve — how do I split them without duplicating the env? |
| §5 One-off scripts | A standalone analysis script with pinned deps, without a project scaffold? |
| §6 Agent-safe execution | How do I run pixi from an agent without ANSI bars or a nested interactive shell? |
| §7 Verification | How do I prove the environment matches the lockfile? |
| §8 `exclude-newer` | How do I keep a re-solve reproducible when the lockfile isn't carried along? |
| Pitfalls | The 10 mistakes that actually bite: channel order, `pip install` inside a pixi shell, a `pixi.toml` per tool, implicit Python versions, deprecated manifest forms, and the deprecated `[project]` header. |

## 🧰 Tools

The skill drives the `pixi` CLI and resolves packages from **conda-forge** and **bioconda**.

| Tool | Role |
|:---- |:-----|
| `pixi` (>= 0.71) | The package/environment manager this skill operates. Corpus verified against **0.83.0**. |
| conda-forge | Default channel for general tooling. |
| bioconda | The bioinformatics channel — aligners, assemblers, QC tools. |

Flag and schema usage is grounded in the offline `docs-corpus/` snapshots — the agent reads these
instead of guessing:

- `docs-corpus/pixi/cli-reference.md` — **live capture** of `pixi --help` and every subcommand's
  `--help` against the installed binary (authoritative for CLI flags).
- `docs-corpus/pixi/features/` — upstream documentation source at the release tag matching the
  installed binary: manifest schema, multi-environment tutorial, task DAGs, `pyproject.toml`
  workspaces, `PIXI_*` env vars, and the `pixi global` model.
- `docs-corpus/pixi/_raw/` — the rendered pages, for cases where the Markdown source alone is ambiguous.

## 🔄 Update check

This skill ships a self-update check that compares the deployed git SHA against this upstream repo via
`git fetch` — no GitHub API call, no extra dependencies.

```bash
python3 bin/skill-update-check.py
```

| Verdict       | Exit | Meaning                                                      |
|:------------- |:---- |:------------------------------------------------------------ |
| `UP-TO-DATE`  | 0    | Local HEAD matches origin/HEAD                               |
| `LOCAL-AHEAD` | 0    | Unpushed local commits; no action needed                     |
| `BEHIND-BY-N` | 1    | Upstream is N commits ahead → re-pull/re-sync from this repo |
| `OFFLINE`     | 2    | `git fetch` failed; informational only                       |
| `NO-ORIGIN`   | 2    | No `origin` remote configured; informational only            |

## 📁 Repository layout

```text
pixi-skill/
├── SKILL.md                 # The skill — the procedure, pitfalls, verification checklist
├── README.md                # This file
├── params.json              # skill-forge render input (name, version, triggers, repo)
├── bin/
│   └── skill-update-check.py  # Self-update check (stdlib only)
└── docs-corpus/
    └── pixi/
        ├── README.md            # What each file is, how to refresh it
        ├── capture.sh           # Regenerates cli-reference.md from the installed pixi
        ├── cli-reference.md     # Live --help capture (all subcommands, incl. pixi global)
        ├── features/            # Upstream docs source @ the matching release tag
        └── _raw/                # The same pages as rendered HTML
```

## 🔒 Hard guarantees

- **One manifest, one lockfile** — a clashing tool gets a *feature + environment* inside the same
  `pixi.toml`, never a second project and never a `pixi.toml` per tool.
- **Project scope, not global scope** — `pixi global` is reserved for machine-wide developer tooling
  that is not part of a project's deliverable. A project's tool inventory is never global.
- **Docs-grounded flag usage** — every `pixi` flag and manifest key comes from `docs-corpus/`, never
  from the agent's memory, and the corpus is pinned to the installed binary version.
- **Explicit pitfalls** — the failure modes that actually bite (channel order, `pip install` inside a
  pixi shell, implicit Python versions, the deprecated `[project]` header) are named up front.

## 🚀 Nextflow runner

This skill does not ship a Nextflow runner. For cohort/HPC execution, wrap the `pixi run` tasks of
*your* project in a workflow scheduler of your choice.

## Provenance

Built with the [skill-forge](https://github.com/cheahhl814/skill-forge) meta-skill, following the
AiX-BIO skill convention. Pattern adopted from:

- **BettaMt-agents** — https://github.com/cheahhl814/BettaMt-agents
- **bacterial-genome-analysis** — https://github.com/cheahhl814/bacterial-genome-analysis
- **amr-gene-screening** — https://github.com/cheahhl814/amr-gene-screening

## License

Released under the MIT License — see the license file in this repository for details.
