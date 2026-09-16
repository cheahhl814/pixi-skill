# pixi CLI Reference

Captured verbatim from `pixi --help` and subcommand --help output. pixi version: pixi 0.81.0.
Captured: 2026-09-16

## pixi --help
```
Pixi [version 0.81.0] - Developer Workflow and Environment Management for Multi-Platform,
Language-Agnostic Workspaces.

Pixi is a versatile developer workflow tool designed to streamline the management of your
workspace's dependencies, tasks, and environments.
Built on top of the Conda ecosystem, Pixi offers seamless integration with the PyPI ecosystem.

Basic Usage:
    Initialize pixi for a workspace:
    $ pixi init
    $ pixi add python numpy pytest

    Run a task:
    $ pixi task add test 'pytest -s'
    $ pixi run test

Found a Bug or Have a Feature Request?
Open an issue at: https://github.com/prefix-dev/pixi/issues

Need Help?
Ask a question on the Prefix Discord server: https://discord.gg/kKV8ZxyzY4

For more information, see the documentation at: https://pixi.sh

Usage: pixi [OPTIONS] [COMMAND]

Commands:
  add          Adds dependencies to the workspace [alias: a]
  auth         Login to prefix.dev or anaconda.org servers to access private channels
  clean        Cleanup the environments
  completion   Generates a completion script for a shell
  config       Configuration management
  exec         Run a command and install it in a temporary environment [alias: x]
  global       Subcommand for global package management actions [alias: g]
  info         Information about the system, workspace and environments for the current machine
  init         Creates a new workspace or script
  import       Imports a file into an environment in an existing workspace.
  install      Install an environment, both updating the lock file and installing the environment
               [alias: i]
  list         List the packages of the current workspace [alias: ls]
  lock         Solve environment and update the lock file without installing the environments
  reinstall    Re-install an environment, both updating the lock file and re-installing the
               environment
  publish      Build the conda packages of a workspace and publish them to a channel.
  remove       Removes dependencies from the workspace [alias: rm]
  run          Runs task in the pixi environment [alias: r]
  search       Search a conda package
  self-update  Update pixi to the latest version or a specific version
  shell        Start a shell in a pixi environment, run `exit` to leave the shell [alias: s]
  shell-hook   Print the pixi environment activation script
  task         Interact with tasks in the workspace
  tree         Show a tree of workspace dependencies [alias: t]
  update       Updates dependencies to newer compatible versions
  upgrade      Checks if there are newer versions of the dependencies and upgrades them in the lock
               file and manifest file
  upload       Upload conda packages to various channels
  workspace    Modify the workspace configuration file through the command line
  help         Print this message or the help of the given subcommand(s)

Options:
  -V, --version  Print version

Global Options:
  -h, --help           Display help information
  -v, --verbose...     Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug,
                       -vvvv for trace)
  -q, --quiet...       Decrease logging verbosity (quiet mode)
      --color <COLOR>  Whether the log needs to be colored [env: PIXI_COLOR=] [default: auto]
                       [possible values: always, never, auto]
      --no-progress    Hide all progress bars, always turned on if stderr is not a terminal [env:
                       PIXI_NO_PROGRESS=]
      --list           List all installed commands (built-in and extensions)
```

## pixi add --help
```
Adds dependencies to the workspace

The dependencies should be defined as MatchSpec for conda package, a PyPI
requirement for the `--pypi` dependencies, or an absolute path to a local
`.conda` or `.tar.bz2` package file. If no specific version is provided,
the latest version compatible with your workspace will be chosen
automatically or a * will be used.

Example usage:

- `pixi add python=3.9`: This will select the latest minor version that
  complies with 3.9.*, i.e., python version 3.9.0, 3.9.1, 3.9.2, etc.
- `pixi add python`: In absence of a specified version, the latest version
  will be chosen. For instance, this could resolve to python version
  3.11.3.* at the time of writing.

Adding multiple dependencies at once is also supported:

- `pixi add python pytest`: This will add both `python` and `pytest` to the
  workspace's dependencies.

The `--platform` and `--build/--host` flags make the dependency target
specific.

- `pixi add python --platform linux-64 --platform osx-arm64`: Will add the
  latest version of python for linux-64 and osx-arm64 platforms.
- `pixi add python --build`: Will add the latest version of python for as a
  build dependency.

Mixing `--platform` and `--build`/`--host` flags is supported

The `--pypi` option will add the package as a pypi dependency. This cannot
be mixed with the conda dependencies

- `pixi add --pypi boto3`
- `pixi add --pypi "boto3==version"`

Local path dependencies can be added with `--path`. Paths are resolved from
the current directory and stored relative to the workspace manifest, so an
absolute input path does not become machine-specific manifest data.

- `pixi add mylib --path ../mylib`
- `pixi add mylib --path /absolute/path/to/mylib`
- `pixi add recipe-package --path ../recipe/recipe.yaml`
- `pixi add --pypi mylib --path ../mylib`
- `pixi add --pypi mylib --path ../mylib --editable`

If the workspace manifest is a `pyproject.toml`, adding a pypi dependency will
add it to the native pyproject `project.dependencies` array or to the native
`dependency-groups` table if a feature is specified:

- `pixi add --pypi boto3` will add `boto3` to the `project.dependencies`
  array
- `pixi add --pypi boto3 --feature aws` will add `boto3` to the
  `dependency-groups.aws` array
- `pixi add --pypi --editable 'boto3 @ file://absolute/path/to/boto3'` will add
  the local editable `boto3` to the `pypi-dependencies` array

Note that if `--platform` or `--editable` are specified, the pypi dependency
will be added to the `tool.pixi.pypi-dependencies` table instead as native
arrays have no support for platform-specific or editable dependencies.

These dependencies will then be read by pixi as if they had been added to
the pixi `pypi-dependencies` tables of the default or of a named feature.

The versions will be automatically added with a pinning strategy based on
semver or the pinning strategy set in the config. There is a list of
packages that are not following the semver versioning scheme but will use
the minor version by default:
Python, Rust, Julia, GCC, GXX, GFortran, NodeJS, Deno, R, R-Base, Perl

Usage: pixi add [OPTIONS] <SPEC>...

Arguments:
  <SPEC>...
          The dependency as names, conda MatchSpecs or PyPi requirements

Options:
      --pypi
          The specified dependencies are pypi dependencies. Conflicts with `host` and `build`

  -p, --platform <PLATFORM>
          The platform for which the dependency should be modified. Must be the name of a platform
          already defined in the workspace

  -f, --feature <FEATURE>
          The feature for which the dependency should be modified
          
          [default: default]

  -e, --environment <ENVIRONMENT>
          The environment for which the dependency should be modified. The dependency is written to
          the content defined inline on the environment, creating the environment if it does not
          exist

      --path <PATH>
          The local path to use when adding a path dependency

      --editable
          Whether the pypi requirement should be editable

      --index <INDEX>
          The PyPI index URL to use for this dependency. Only applicable when adding pypi
          dependencies

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Git Options:
  -g, --git <GIT>
          The git url to use when adding a git dependency

      --branch <BRANCH>
          The git branch

      --tag <TAG>
          The git tag

      --rev <REV>
          The git revision

      --subdirectory <SUBDIRECTORY>
          The subdirectory of the git repository to use

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]

      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

Config Options:
      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]
```

## pixi remove --help
```
Removes dependencies from the workspace.

If the workspace manifest is a `pyproject.toml`, removing a pypi dependency with the `--pypi` flag
will remove it from either

- the native pyproject `project.dependencies` array or, if a feature is specified, the native
`project.optional-dependencies` table

- pixi `pypi-dependencies` tables of the default feature or, if a feature is specified, a named
feature

Usage: pixi remove [OPTIONS] <SPEC>...

Arguments:
  <SPEC>...
          The dependency as names, conda MatchSpecs or PyPi requirements

Options:
      --pypi
          The specified dependencies are pypi dependencies. Conflicts with `host` and `build`

  -p, --platform <PLATFORM>
          The platform for which the dependency should be modified. Must be the name of a platform
          already defined in the workspace

  -f, --feature <FEATURE>
          The feature for which the dependency should be modified
          
          [default: default]

  -e, --environment <ENVIRONMENT>
          The environment for which the dependency should be modified. The dependency is written to
          the content defined inline on the environment, creating the environment if it does not
          exist

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Git Options:
  -g, --git <GIT>
          The git url to use when adding a git dependency

      --branch <BRANCH>
          The git branch

      --tag <TAG>
          The git tag

      --rev <REV>
          The git revision

      --subdirectory <SUBDIRECTORY>
          The subdirectory of the git repository to use

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]

      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]
```

## pixi init --help
```
Creates a new workspace or script

The positional path starts a workspace, while `--script` writes a metadata block into a single file:
a PEP 723 block for a Python file, a `conda-script` block for every other known extension.
`--format` overrides that default.

As pixi can both work with `pixi.toml` and `pyproject.toml` files, the user can choose which one to
use with `--format`.

You can import an existing conda environment file with the `--import` flag.

Usage: pixi init [OPTIONS] [PATH]

Arguments:
  [PATH]
          Where to place the workspace (defaults to the current path)

Options:
  -s, --script <PATH>
          Create a metadata block in a script instead of a workspace

  -c, --channel <CHANNEL>
          Channel to use in the workspace

  -p, --platform <NEW_PLATFORM>
          Platforms that the workspace supports

  -i, --import <ENVIRONMENT_FILE>
          Environment.yml file to bootstrap the workspace

      --format <FORMAT>
          The manifest format to create
          
          [possible values: pixi, pyproject, mojoproject, pep723, conda-script]

      --scm <SCM>
          Source Control Management used for this workspace
          
          [possible values: github, gitlab, codeberg]

      --conda-pypi-map <CONDA_PYPI_MAP>
          Set conda↔PyPI mapping configuration.
          
          Use `false` to disable mapping, or `CHANNEL=LOCATION[,CHANNEL=LOCATION]` for per-channel
          mapping locations.

Global Options:
  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi task --help
```
Interact with tasks in the workspace

Usage: pixi task [OPTIONS] <COMMAND>

Commands:
  add     Add a command to the workspace [alias: a]
  remove  Remove a command from the workspace [alias: rm]
  alias   Alias another specific command
  list    List all tasks in the workspace [alias: ls]
  help    Print this message or the help of the given subcommand(s)

Config Options:
      --no-config           Don't read system or user-level configuration files. Project-local
                            `<project>/.pixi/config.toml` is still loaded [env: PIXI_NO_CONFIG=]
      --config-file <PATH>  Load configuration from this file instead of searching system and
                            user-level paths. Project-local `<project>/.pixi/config.toml` is still
                            merged on top [env: PIXI_CONFIG_FILE=]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>  The path to `pixi.toml`, `pyproject.toml`, or the workspace
                                       directory
  -w, --workspace <WORKSPACE>          Name of the workspace
  -h, --help                           Display help information
  -v, --verbose...                     Increase logging verbosity (-v for warnings, -vv for info,
                                       -vvv for debug, -vvvv for trace)
  -q, --quiet...                       Decrease logging verbosity (quiet mode)
      --color <COLOR>                  Whether the log needs to be colored [env: PIXI_COLOR=]
                                       [default: auto] [possible values: always, never, auto]
      --no-progress                    Hide all progress bars, always turned on if stderr is not a
                                       terminal [env: PIXI_NO_PROGRESS=]
```

## pixi run --help
```
Runs task in the pixi environment.

This command is used to run tasks in the pixi environment. It will activate the environment and run
the task in the environment. It is using the deno_task_shell to run the task.

`pixi run` will also update the lock file and install the environment if it is required.

Usage: pixi run [OPTIONS] [TASK]...

Arguments:
  [TASK]...
          The pixi task or a task shell command you want to run in the workspace's environment,
          which can be an executable in the environment's PATH

Options:
  -x, --executable
          Execute the command as an executable without resolving Pixi tasks.
          
          Useful when a task name and an executable have the same name.

      --experimental
          Enable experimental `--script` features; currently the `conda-script` block.
          
          The flag has no effect for PEP 723 scripts, so a shebang line can pass it unconditionally.
          Setting `experimental.conda-script` in the configuration opts in without the flag, with a
          warning on every run.

  -e, --environment <ENVIRONMENT>
          The environment to run the task in

  -p, --platform <PLATFORM>
          Install and run in the environment for the given platform; a warning is printed when it
          doesn't run on this machine. Accepts a workspace platform name; a bare conda subdir (e.g.
          `linux-64`) is also accepted

      --clean-env
          Use a clean environment to run the task
          
          Using this flag will ignore your current shell environment and use bare minimum
          environment to activate the pixi environment in.

      --skip-deps
          Don't run the dependencies of the task ('depends-on' field in the task definition)

      --templated
          Enable template rendering for the command arguments.
          
          By default, arguments passed to `pixi run` on the command line are not processed by the
          template engine. Use this flag to enable rendering of template variables like `{{
          pixi.platform }}`.

  -n, --dry-run
          Run the task in dry-run mode (only print the command that would run)

      --help
          

  -h
          

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

      --force-activate
          Do not use the environment activation cache. (default: true except in experimental mode)

      --no-completions
          Do not source the autocompletion scripts from the environment

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]

      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

      --as-is
          Shorthand for the combination of --no-install and --frozen
```

## pixi shell --help
```
Start a shell in a pixi environment, run `exit` to leave the shell

Usage: pixi shell [OPTIONS]

Options:
  -e, --environment <ENVIRONMENT>
          The environment to activate in the shell

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

      --change-ps1 <CHANGE_PS1>
          Do not change the PS1 variable when starting a prompt
          
          [possible values: true, false]

      --force-activate
          Do not use the environment activation cache. (default: true except in experimental mode)

      --no-completions
          Do not source the autocompletion scripts from the environment

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]

      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

      --as-is
          Shorthand for the combination of --no-install and --frozen
```

## pixi shell-hook --help
```
Print the pixi environment activation script.

You can source the script to activate the environment without needing pixi itself.

Usage: pixi shell-hook [OPTIONS]

Options:
  -s, --shell <SHELL>
          Sets the shell, options: [`bash`,  `zsh`,  `xonsh`,  `cmd`, `powershell`,  `fish`,
          `nushell`]

  -e, --environment <ENVIRONMENT>
          The environment to activate in the script

      --json
          Emit the environment variables set by running the activation as JSON

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

      --force-activate
          Do not use the environment activation cache. (default: true except in experimental mode)

      --no-completions
          Do not source the autocompletion scripts from the environment

      --change-ps1 <CHANGE_PS1>
          Do not change the PS1 variable when starting a prompt
          
          [possible values: true, false]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]

      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

      --as-is
          Shorthand for the combination of --no-install and --frozen
```

## pixi install --help
```
Install an environment, both updating the lock file and installing the environment.

This command installs an environment, if the lock file is not up-to-date it will be updated.

`pixi install` only installs one environment at a time, if you have multiple environments you can
select the right one with the `--environment` flag. If you don't provide an environment, the
`default` environment will be installed.

If you want to install all environments, you can use the `--all` flag.

Running `pixi install` is not required before running other commands like `pixi run` or `pixi
shell`. These commands will automatically install the environment if it is not already installed.

You can use `pixi reinstall` to reinstall all environments, one environment or just some packages of
an environment.

`pixi install --script` installs a PEP 723 script's environment without running the script. It uses
the same environment as `pixi run --script`. Pixi updates an adjacent lock file when one exists.
Otherwise, it updates the cached resolution.

Usage: pixi install [OPTIONS]

Options:
  -e, --environment <ENVIRONMENT>
          The environment to install

  -a, --all
          Install all environments

  -p, --platform <PLATFORM>
          Install for the given platform; a warning is printed when it doesn't run on this machine

      --skip <SKIP>
          Skip installation of specific packages present in the lock file. This uses a soft
          exclusion: the package will be skipped but its dependencies are installed

      --skip-with-deps <SKIP_WITH_DEPS>
          Skip a package and its entire dependency subtree. This performs a hard exclusion: the
          package and its dependencies are not installed unless reachable from another non-skipped
          root

      --only <ONLY>
          Install and build only these package(s) and their dependencies. Can be passed multiple
          times

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]
```

## pixi lock --help
```
Solve environment and update the lock file without installing the environments

Usage: pixi lock [OPTIONS]

Options:
      --json
          Output the changes in JSON format

      --check
          Check if any changes have been made to the lock file. If yes, exit with a non-zero code

      --dry-run
          Compute the lock file without writing to disk. Implies --no-install

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]
```

## pixi update --help
```
Updates dependencies to newer compatible versions.

Projects and scripts with an adjacent lock file write that lock file. A script without one writes
its cached resolution.

Usage: pixi update [OPTIONS] [PACKAGES]...

Arguments:
  [PACKAGES]...
          The packages to update, space separated. If no packages are provided, all packages will be
          updated

Options:
      --no-install
          Don't install the (solve) environments needed for pypi-dependencies solving
          
          [env: PIXI_NO_INSTALL=]

  -n, --dry-run
          Don't write the updated resolution or update any environment

  -e, --environment <ENVIRONMENT>
          The environments to update. If none is specified, all environments are updated

  -p, --platform <PLATFORM>
          The platforms to update. If none is specified, all platforms are updated. Accepts a
          workspace platform name; a bare conda subdir (e.g. `linux-64`) is also accepted so users
          don't have to declare a platform before targeting it

      --json
          Output the changes in JSON format

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi list --help
```
List the packages of the current workspace

Highlighted packages are explicit dependencies.

Usage: pixi list [OPTIONS] [REGEX]

Arguments:
  [REGEX]
          List only packages matching a regular expression

Options:
      --platform <PLATFORM>
          The platform to list packages for. Defaults to the platform best matching this machine.
          Accepts a workspace platform name; a bare conda subdir (e.g. `linux-64`) is also accepted

      --json
          Whether to output in json format

      --sort-by <SORT_BY>
          Sorting strategy
          
          [default: name]
          [possible values: size, name, kind]

      --fields <FIELDS>
          Select which fields to display and in what order (comma-separated)
          
          [default: name version build size kind source]
          [possible values: arch, build, build-number, constrains, depends, file-name, is-editable,
          kind, license, license-family, md5, name, noarch, platform, requested-spec, sha256, size,
          source, subdir, timestamp, track-features, url, version]

  -e, --environment <ENVIRONMENT>
          The environment to list packages for. Defaults to the default environment

  -x, --explicit
          Only list packages that are explicitly defined in the workspace

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]
```

## pixi search --help
```
Search a conda package

Its output will list the latest version of package.

Usage: pixi search [OPTIONS] <PACKAGE>

Arguments:
  <PACKAGE>
          MatchSpec of a package to search

Options:
  -c, --channel <CHANNEL>
          The channels to consider as a name or a url. Multiple channels can be specified by using
          this field multiple times.
          
          When specifying a channel, it is common that the selected channel also depends on the
          `conda-forge` channel.
          
          By default, if no channel is provided, `conda-forge` is used.

  -p, --platform <PLATFORM>
          The platform to search packages for. By default, searches all platforms from the manifest
          (or all known platforms if no manifest is found). Accepts a workspace platform name; a
          bare conda subdir (e.g. `linux-64`) is also accepted

  -l, --limit <LIMIT>
          Limit the number of versions shown per package, -1 for no limit
          
          [default: 5]

  -n, --limit-packages <LIMIT_PACKAGES>
          Limit the number of packages shown, -1 for no limit
          
          [default: 5]

      --json
          Output in JSON format

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi tree --help
```
Show a tree of workspace dependencies

Dependency names highlighted in green are directly specified in the manifest. Yellow version numbers
are conda packages, PyPI version numbers are blue.

Usage: pixi tree [OPTIONS] [REGEX]

Arguments:
  [REGEX]
          List only packages matching a regular expression

Options:
  -p, --platform <PLATFORM>
          The platform to list packages for. Defaults to the platform best matching this machine.
          Accepts a workspace platform name; a bare conda subdir (e.g. `linux-64`) is also accepted

  -e, --environment <ENVIRONMENT>
          The environment to list packages for. Defaults to the default environment

  -i, --invert
          Invert tree and show what depends on given package in the regex argument

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -s, --script <SCRIPT>
          The path to a script with an embedded manifest: a Python script containing PEP 723
          metadata, or a file of any language containing a `/// conda-script` block.
          
          `pixi run` also accepts an HTTP(S) URL or `-` to read the script from stdin.

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]

Update Options:
      --frozen
          Install the environment as defined in the lock file, doesn't update lock file if it isn't
          up-to-date with the manifest file
          
          [env: PIXI_FROZEN=]

      --locked
          Check if lock file is up-to-date before installing the environment, aborts when lock file
          isn't up-to-date with the manifest file
          
          [env: PIXI_LOCKED=]

      --no-install
          Don't modify the environment, only modify the lock file
          
          [env: PIXI_NO_INSTALL=]
```

## pixi info --help
```
Information about the system, workspace and environments for the current machine

Usage: pixi info [OPTIONS]

Options:
      --extended  Show cache and environment size
      --json      Whether to show the output as JSON or not

Config Options:
      --no-config           Don't read system or user-level configuration files. Project-local
                            `<project>/.pixi/config.toml` is still loaded [env: PIXI_NO_CONFIG=]
      --config-file <PATH>  Load configuration from this file instead of searching system and
                            user-level paths. Project-local `<project>/.pixi/config.toml` is still
                            merged on top [env: PIXI_CONFIG_FILE=]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>  The path to `pixi.toml`, `pyproject.toml`, or the workspace
                                       directory
  -w, --workspace <WORKSPACE>          Name of the workspace
  -h, --help                           Display help information
  -v, --verbose...                     Increase logging verbosity (-v for warnings, -vv for info,
                                       -vvv for debug, -vvvv for trace)
  -q, --quiet...                       Decrease logging verbosity (quiet mode)
      --color <COLOR>                  Whether the log needs to be colored [env: PIXI_COLOR=]
                                       [default: auto] [possible values: always, never, auto]
      --no-progress                    Hide all progress bars, always turned on if stderr is not a
                                       terminal [env: PIXI_NO_PROGRESS=]
```

## pixi workspace --help
```
Modify the workspace configuration file through the command line

Usage: pixi workspace [OPTIONS] <COMMAND>

Commands:
  activation     Commands to manage the activation of environments: the scripts that run and the
                 environment variables that are set when an environment is activated
  channel        Commands to manage workspace channels
  dependencies   Commands to manage the `[workspace.dependencies]` table [aliases: dependency, dep]
  description    Commands to manage workspace description
  platform       Commands to manage workspace platforms
  version        Commands to manage workspace version
  environment    Commands to manage workspace environments
  feature        Commands to manage workspace features
  export         Commands to export workspaces to other formats
  name           Commands to manage workspace name
  preview        Commands to manage workspace preview flags
  register       Commands to manage the registry of workspaces. Default command will add a new
                 workspace
  requires-pixi  Commands to manage the pixi minimum version requirement
  help           Print this message or the help of the given subcommand(s)

Global Options:
  -m, --manifest-path <MANIFEST_PATH>  The path to `pixi.toml`, `pyproject.toml`, or the workspace
                                       directory
  -w, --workspace <WORKSPACE>          Name of the workspace
  -h, --help                           Display help information
  -v, --verbose...                     Increase logging verbosity (-v for warnings, -vv for info,
                                       -vvv for debug, -vvvv for trace)
  -q, --quiet...                       Decrease logging verbosity (quiet mode)
      --color <COLOR>                  Whether the log needs to be colored [env: PIXI_COLOR=]
                                       [default: auto] [possible values: always, never, auto]
      --no-progress                    Hide all progress bars, always turned on if stderr is not a
                                       terminal [env: PIXI_NO_PROGRESS=]
```

## pixi global --help
```
Subcommand for global package management actions.

Install packages on the user level. Into to the `$PIXI_HOME` directory, which defaults to `~/.pixi`.

Usage: pixi global [OPTIONS] <COMMAND>

Commands:
  add        Adds dependencies to an environment [alias: a]
  edit       Edit the global manifest file
  install    Installs the defined packages in a globally accessible location and exposes their
             command line applications. [alias: i]
  uninstall  Uninstalls environments from the global environment.
  remove     Removes dependencies from an environment [alias: rm]
  list       Lists global environments with their dependencies and exposed commands. Can also
             display all packages within a specific global environment when using the --environment
             flag. [alias: ls]
  sync       Sync global manifest with installed environments [alias: s]
  expose     Interact with the exposure of binaries in the global environment [alias: e]
  shortcut   Interact with the shortcuts on your machine
  update     Updates environments in the global environment
  tree       Show a tree of dependencies for a specific global environment [alias: t]
  help       Print this message or the help of the given subcommand(s)

Global Options:
  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi clean --help
```
Cleanup the environments.

This command removes the information in the .pixi folder. You can specify the environment to remove
with the `--environment` flag.

Use the `cache` subcommand to clean the cache.

Usage: pixi clean [OPTIONS] [COMMAND]

Commands:
  cache  Clean the cache of your system which are touched by pixi
  help   Print this message or the help of the given subcommand(s)

Options:
  -e, --environment <ENVIRONMENT>
          The environment directory to remove

      --activation-cache
          Only remove the activation cache

      --build
          Only remove the pixi-build cache

      --workspaces-registry
          Only remove disassociated workspace registries

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

Global Options:
  -m, --manifest-path <MANIFEST_PATH>
          The path to `pixi.toml`, `pyproject.toml`, or the workspace directory

  -w, --workspace <WORKSPACE>
          Name of the workspace

  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi upload --help
```
Upload conda packages to various channels

Supported server types: prefix, anaconda, quetz, artifactory, s3, conda-forge

Use `pixi auth login` to authenticate with the server.

Usage: pixi upload [OPTIONS] [PACKAGE_FILES]... <COMMAND>

Commands:
  quetz        Upload to a Quetz server. Authentication is used from the keychain / auth-file
  artifactory  Options for uploading to an Artifactory channel
  prefix       Options for uploading to a prefix.dev server. Authentication is used from the
               keychain / auth-file
  anaconda     Options for uploading to a Anaconda.org server
  cloudsmith   Options for uploading to a Cloudsmith repository. Authentication is used from the
               keychain / auth-file
  s3           Options for uploading to S3
  help         Print this message or the help of the given subcommand(s)

Arguments:
  [PACKAGE_FILES]...
          The package file to upload

Options:
      --offline[=<OFFLINE>]
          Run without network access. Uploading always requires the network, so this makes `pixi
          upload` fail fast instead of attempting to connect. Defined here rather than through the
          shared config flags because `UploadOpts` already owns `--auth-file`
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --allow-insecure-host <ALLOW_INSECURE_HOST>
          List of hosts for which SSL certificate verification should be skipped

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

Global Options:
  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi publish --help
```
Build the conda packages of a workspace and publish them to a channel.

Builds every package in the workspace that opts into publishing with
`publish = true` in its `[package]` section - in dependency order, so
packages that depend on other workspace packages are built after them -
and either uploads the artifacts to a channel (`--target-channel`) or
copies them into a local directory (`--target-dir`). Every source
dependency of a published package must itself opt into publishing; the
publish fails otherwise. When no package opts in, the package at the
current directory is published instead, as if `--path .` had been
passed. Use `--path` to build and publish a single package.

Supported destinations for `--target-channel` (alias `--to`):
  - prefix.dev: `https://prefix.dev/<channel-name>`
  - anaconda.org: `https://anaconda.org/<owner>/<label>`
  - Cloudsmith: `cloudsmith://<owner>/<repository>`
  - S3: `s3://bucket-name`
  - Quetz: `quetz://server/<channel>`
  - Artifactory: `artifactory://server/<channel>`
  - Local filesystem channel (with indexing):
    `file:///path/to/channel` or a bare path

Use `--target-dir <PATH>` instead to copy the built package(s) into a
directory without creating a channel structure.

Usage: pixi publish [OPTIONS]

Options:
  -t, --target-platform <TARGET_PLATFORM>
          The target platform to build for (defaults to the current platform)
          
          [default: linux-64]

      --build-platform <BUILD_PLATFORM>
          The build platform to use for building (defaults to the current platform)
          
          [default: linux-64]

      --build-string-prefix <BUILD_STRING_PREFIX>
          An optional prefix prepended to the auto-generated build string

      --build-number <BUILD_NUMBER>
          An optional override for the package's build number

  -b, --build-dir <BUILD_DIR>
          The directory to use for incremental builds artifacts

  -c, --clean
          Whether to clean the build directory before building

      --path <PATH>
          The path to a directory containing a package manifest, or to a specific manifest file.
          
          When given, only that package is built and published - whether or not it sets `publish =
          true`. The package must be self-contained: publishing it alone fails if any of its run
          dependencies is a source dependency. Build and host source dependencies are only consumed
          while building and are fine.
          
          Supported manifest files: `package.xml`, `recipe.yaml`, `pixi.toml`, `pyproject.toml`, or
          `mojoproject.toml`.

      --target-channel <TARGET_CHANNEL>
          The target channel to publish packages to. Accepts a URL (prefix.dev, anaconda.org,
          cloudsmith://, s3://, quetz://, artifactory://) or a local filesystem path / `file://` URL
          for an indexed local channel.
          
          Mutually exclusive with `--target-dir`.
          
          [alias: --to]

      --target-dir <TARGET_DIR>
          The local filesystem path to copy the built package(s) into (no channel indexing).
          
          Accepts an absolute or relative directory path. Mutually exclusive with
          `--target-channel`.

      --force
          Force overwrite existing packages

      --no-skip-existing
          Do not skip packages that already exist at the target.
          
          Packages that already exist at the target are skipped by default. With this flag they fail
          the publish instead, unless `--force` is also given to overwrite them. Skipping is
          enforced for prefix.dev and local filesystem targets; S3 fails on existing packages unless
          `--force` is given, and the remaining backends follow their server-side behavior.

      --dry-run
          Resolve and print the publish set without building or uploading.
          
          Discovers the packages, validates that they form a self-contained set, and prints them in
          the order they would be built and uploaded.

      --generate-attestation
          Generate sigstore attestation (prefix.dev only)

      --variant <KEY=VALUES>
          Override a build variant key with one or more values.
          
          Use `--variant KEY=VALUE` to build only that variant, or `--variant KEY=VAL1,VAL2,...` to
          constrain a variant to a subset of values. Repeat the flag for multiple keys. Values
          supplied here replace any matching key from the workspace `build-variants` and any
          `--variant-config` files.
          
          Example: `pixi publish --variant python=3.12 --variant cuda-version=12.8,13.0`.

  -m, --variant-config <FILE>
          Path to an additional variant configuration YAML file.
          
          Mirrors rattler-build's `--variant-config/-m`. Repeat to add multiple files. Paths are
          appended after the workspace-level `build-variants-files`.

      --package-format <PACKAGE_FORMAT>
          Archive format and optional compression level, e.g. `conda`, `tar-bz2`, `conda:max`,
          `conda:15`, `tar-bz2:9`. Numeric ranges match rattler-build: -7..=22 for `.conda`, 1..=9
          for `.tar.bz2`

Config Options:
      --no-config
          Don't read system or user-level configuration files. Project-local
          `<project>/.pixi/config.toml` is still loaded
          
          [env: PIXI_NO_CONFIG=]

      --config-file <PATH>
          Load configuration from this file instead of searching system and user-level paths.
          Project-local `<project>/.pixi/config.toml` is still merged on top
          
          [env: PIXI_CONFIG_FILE=]

      --auth-file <AUTH_FILE>
          Path to the file containing the authentication token

      --concurrent-downloads <CONCURRENT_DOWNLOADS>
          Max concurrent network requests, default is `50`

      --concurrent-solves <CONCURRENT_SOLVES>
          Max concurrent solves, default is the number of CPUs

      --pinning-strategy <PINNING_STRATEGY>
          Set pinning strategy

          Possible values:
          - semver:        Default semver strategy e.g. `1.2.3` becomes `>=1.2.3, <2` but `0.1.0`
            becomes `>=0.1.0, <0.2`
          - minor:         Pin the latest minor e.g. `1.2.3` becomes `>=1.2.3, <1.3`
          - major:         Pin the latest major e.g. `1.2.3` becomes `>=1.2.3, <2`
          - latest-up:     Pin to the latest version or higher. e.g. `1.2.3` becomes `>=1.2.3`
          - exact-version: Pin the version chosen by the solver. e.g. `1.2.3` becomes `==1.2.3`
          - no-pin:        No pinning, keep the requirement empty. e.g. `1.2.3` becomes `*`

      --pypi-keyring-provider <PYPI_KEYRING_PROVIDER>
          Specifies whether to use the keyring to look up credentials for PyPI
          
          [possible values: disabled, subprocess]

      --run-post-link-scripts
          Run post-link scripts (insecure)

      --no-symbolic-links
          Disallow symbolic links during package installation
          
          [env: PIXI_NO_SYMBOLIC_LINKS=]

      --no-hard-links
          Disallow hard links during package installation
          
          [env: PIXI_NO_HARD_LINKS=]

      --no-ref-links
          Disallow ref links (copy-on-write) during package installation
          
          [env: PIXI_NO_REF_LINKS=]

      --tls-no-verify
          Do not verify the TLS certificate of the server

      --offline[=<OFFLINE>]
          Run without network access, using only cached data. Commands fail if data is missing from
          the cache. Pass `--offline=false` to override an `offline` setting from the configuration
          
          [env: PIXI_OFFLINE=]
          [possible values: true, false]

      --tls-root-certs <TLS_ROOT_CERTS>
          Which TLS root certificates to use: 'webpki' (bundled Mozilla roots) or 'system' (system
          store)
          
          [env: PIXI_TLS_ROOT_CERTS=]

      --use-environment-activation-cache
          Use environment activation cache (experimental)

Global Options:
  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

## pixi self-update --help
```
Update pixi to the latest version or a specific version

Usage: pixi self-update [OPTIONS]

Options:
      --offline[=<OFFLINE>]  Run without network access. Updating always requires the network, so
                             this makes `pixi self-update` fail fast instead of attempting to
                             connect [env: PIXI_OFFLINE=] [possible values: true, false]
      --version <VERSION>    The desired version (to downgrade or upgrade to)
      --dry-run              Only show release notes, do not modify the binary
      --force                Force download the desired version when not exactly same with the
                             current. If no desired version, always replace with the latest version
      --no-release-note      Skip printing the release notes
      --from-url <FROM_URL>  The github releases URL, useful when behind a proxy, or using custom
                             Pixi release

Config Options:
      --no-config           Don't read system or user-level configuration files. Project-local
                            `<project>/.pixi/config.toml` is still loaded [env: PIXI_NO_CONFIG=]
      --config-file <PATH>  Load configuration from this file instead of searching system and
                            user-level paths. Project-local `<project>/.pixi/config.toml` is still
                            merged on top [env: PIXI_CONFIG_FILE=]

Global Options:
  -h, --help           Display help information
  -v, --verbose...     Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug,
                       -vvvv for trace)
  -q, --quiet...       Decrease logging verbosity (quiet mode)
      --color <COLOR>  Whether the log needs to be colored [env: PIXI_COLOR=] [default: auto]
                       [possible values: always, never, auto]
      --no-progress    Hide all progress bars, always turned on if stderr is not a terminal [env:
                       PIXI_NO_PROGRESS=]
```

## pixi completion --help
```
Generates a completion script for a shell

Usage: pixi completion [OPTIONS] --shell <SHELL>

Options:
  -s, --shell <SHELL>
          The shell to generate a completion script for

          Possible values:
          - bash:       Bourne Again SHell (bash)
          - elvish:     Elvish shell
          - fish:       Friendly Interactive SHell (fish)
          - nushell:    Nushell
          - powershell: PowerShell
          - zsh:        Z SHell (zsh)

Global Options:
  -h, --help
          Display help information

  -v, --verbose...
          Increase logging verbosity (-v for warnings, -vv for info, -vvv for debug, -vvvv for
          trace)

  -q, --quiet...
          Decrease logging verbosity (quiet mode)

      --color <COLOR>
          Whether the log needs to be colored
          
          [env: PIXI_COLOR=]
          [default: auto]
          [possible values: always, never, auto]

      --no-progress
          Hide all progress bars, always turned on if stderr is not a terminal
          
          [env: PIXI_NO_PROGRESS=]
```

