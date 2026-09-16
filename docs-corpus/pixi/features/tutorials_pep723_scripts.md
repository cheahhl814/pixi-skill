# PEP 723 script environments (pixi >= 0.76.0)

A single Python file can carry its own environment via [PEP 723](https://packaging.python.org/en/latest/specifications/inline-script-metadata/) inline metadata. No `pixi.toml`, no `.pixi/` folder, no lock file — unless you ask for one with `pixi lock --script`.

## The block

```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["rich>=13.9.2"]
# ///
import rich
```

Conda dependencies and channels go in `tool.pixi` tables inside the same block:

```python
# /// script
# dependencies = ["httpx"]
# [tool.pixi.workspace]
# channels = ["conda-forge"]
# [tool.pixi.dependencies]
# gdal = "*"
# ///
import httpx
from osgeo import gdal
```

The CLI writes/edits the block for you — never hand-edit it when a command exists:

```bash
pixi init --script hello.py            # add a PEP 723 block to an existing file
pixi add --script hello.py gdal        # add a conda dep into the block
pixi add --script hello.py --pypi httpx
```

## Running

```bash
pixi run --script hello.py             # resolve, cache, run
pixi lock --script hello.py            # pin a lock file (reproducibility)
pixi list --script hello.py            # inspect the resolved env
```

`--script` also works on `remove`, `tree`, and `workspace export`.

## Platforms

A script that declares no `platforms` gets a warning at lock time — the lockfile records only this machine's virtual packages. Fix with:

```bash
pixi workspace platform add --script hello.py --auto-detect
# or add platforms to the script metadata block
```

## Offline

Script environments work offline too, once cached:

```bash
pixi install --offline --script hello.py
# ✔ The script environment has been installed at ~/.cache/rattler/cache/cached-envs-v0/<hash>/envs/default
```

## Remote scripts (0.76.0 for Python, 0.81.0 for conda-script)

`pixi run --script` accepts a URL, a GitHub Gist page, or `-` for stdin. As of 0.81.0, `conda-script` files can also be run directly from HTTP(S) URLs/Gists — pixi downloads the script, reuses its cached environment, and runs it.

## Why agents care

- One-off analysis scripts with pinned deps need zero project scaffolding.
- Environments are cached and reused across runs of the same script.
- Dependencies stay declared in-file — no ghost `pip install`s.