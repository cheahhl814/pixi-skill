# Offline solves (pixi >= 0.74.0, refined 0.75.0)

`--offline` makes pixi resolve using only packages already available locally: the package cache or a local `file://` channel. No network requests.

```bash
pixi install --offline
pixi update --offline
pixi add --offline <pkg>        # solve offline; fails if the pkg is not cached
```

- Override a config-level `offline = true` with `--offline=false`.
- Environment variable equivalent: `PIXI_OFFLINE=1` (see `reference_environment_variables.md`).
- Since 0.75.0, offline solves are restricted to **locally available** conda packages — the package cache or a local `file://` channel. If a needed package/version was never downloaded, the solve fails (loudly, not silently degraded).

## Why agents care

- HPC/air-gapped nodes: prep on the login node (`pixi install`), then re-verify offline on compute nodes with `pixi install --locked --offline`.
- Deterministic CI: an offline pass proves the cache fully covers the lockfile.
- Never use offline mode to "work around" a solver failure — a failed offline solve means the lock/cache is incomplete, not that you should loosen pins.