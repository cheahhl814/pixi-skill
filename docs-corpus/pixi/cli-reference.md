# pixi CLI Reference

Captured verbatim from `pixi --help` and subcommand --help output. pixi version: pixi 0.83.0.
Captured: 2026-10-28

## pixi --help
```
Pixi [version 0.83.0] - Developer Workflow and Environment Management for Multi-Platform,
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
  add          Add dependencies to the workspace [alias: a]
  auth         Login to prefix.dev or anaconda.org servers to access private channels
  clean        Clean up workspaces/environments/caches
  completion   Generate a shell completion script
  config       Manage configuration
  exec         Run a command in a temporary environment [alias: x]
  global       Manage globally-installed packages [alias: g]
  info         Get information about the pixi installation and current workspace
  init         Create a new workspace or script
  import       Import a file into an environment in an existing workspace
  install      Install an environment [alias: i]
  list         List the packages of an environment [alias: ls]
  lock         Solve environments and update the lock file without installing the environments
  reinstall    Re-install an environment
  publish      Build the conda packages of a workspace and publish them
  remove       Remove dependencies from a workspace [alias: rm]
  run          Run a task in an environment [alias: r]
  search       Search for conda packages
  self-update  Update pixi to the latest version or a specific version
  shell        Start a shell in a pixi environment [alias: s]
  shell-hook   Print a pixi environment activation script
  task         Interact with tasks in a workspace
  tree         Show a tree of workspace dependencies [alias: t]
  update       Update dependencies to newer compatible versions
  upgrade      Check if there are newer versions of the dependencies and upgrade them in the lock
               file and manifest file
  upload       Upload conda packages to various channels
  workspace    Modify the workspace configuration file
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
Add dependencies to the workspace

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

## pixi auth --help
```
Login to prefix.dev or anaconda.org servers to access private channels

Usage: pixi auth [OPTIONS] <COMMAND>

Commands:
  login   Store authentication information for a given host
  logout  Remove authentication information for a given host
  token   Print the stored authentication token for a given host
  status  Show stored authentication entries and non-secret token metadata
  help    Print this message or the help of the given subcommand(s)

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

## pixi clean --help
```
Clean up workspaces/environments/caches.

This command removes the information in the .pixi folder, i.e. the installed environments and
caches. Use options to only remove selected parts.

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

## pixi completion --help
```
Generate a shell completion script

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

## pixi config --help
```
Manage configuration

Usage: pixi config [OPTIONS] <COMMAND>

Commands:
  edit     Edit the configuration file
  list     List configuration values [alias: ls]
  prepend  Prepend a value to a list configuration key
  append   Append a value to a list configuration key
  set      Set a configuration value
  unset    Unset a configuration value
  help     Print this message or the help of the given subcommand(s)

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

## pixi exec --help
```
Run a command in a temporary environment.

Remove the temporary environments with `pixi clean cache --exec`.

Usage: pixi exec [OPTIONS] [COMMAND]...

Arguments:
  [COMMAND]...
          The executable to run, followed by any arguments

Options:
  -s, --spec <SPEC>
          Matchspecs of package to install. If this is not provided, the package is guessed from the
          command

  -w, --with <WITH>
          Matchspecs of package to install, while also guessing a package from the command

  -c, --channel <CHANNEL>
          The channels to consider as a name or a url. Multiple channels can be specified by using
          this field multiple times.
          
          When specifying a channel, it is common that the selected channel also depends on the
          `conda-forge` channel.
          
          By default, if no channel is provided, `conda-forge` is used.

  -p, --platform <SUBDIR>
          The platform to create the environment for. Defaults to the current machine's subdir.
          Accepts a workspace platform name or a bare conda subdir (e.g. `linux-64`); `pixi exec`
          runs outside any workspace so the value resolves to a conda subdir either way

      --force-reinstall
          If specified a new environment is always created even if one already exists

      --list[=<LIST>]
          Before executing the command, list packages in the environment Specify `--list=some_regex`
          to filter the shown packages

      --no-modify-ps1
          Disable modification of the PS1 prompt to indicate the temporary environment

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

## pixi global --help
```
Manage globally-installed packages.

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

## pixi info --help
```
Get information about the pixi installation and current workspace

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

## pixi init --help
```
Create a new workspace or script

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

## pixi import --help
```
Import a file into an environment in an existing workspace

If `--format` isn't provided, `import` will try each format in turn

Usage: pixi import [OPTIONS] <FILE>

Arguments:
  <FILE>
          File to import into the workspace

Options:
      --format <FORMAT>
          Which format to interpret the file as
          
          [possible values: conda-env, pypi-txt]

  -p, --platform <PLATFORM>
          The platforms for the imported environment. Accepts a workspace platform name; a bare
          conda subdir (e.g. `linux-64`) is also accepted. Names that aren't yet declared get
          auto-added as subdir platforms

  -e, --environment <NEW_ENVIRONMENT>
          A name for the created environment. Without `--feature` the imported content is written
          inline on the environment

  -f, --feature <NEW_FEATURE>
          A name for the created feature. The feature is added to the environment of the same name
          unless `--environment` is given

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

## pixi install --help
```
Install an environment.

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

## pixi list --help
```
List the packages of an environment

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

## pixi lock --help
```
Solve environments and update the lock file without installing the environments

Usage: pixi lock [OPTIONS]

Options:
      --json
          Output the changes in JSON format

      --check
          Check if any changes have been made to the lock file. If yes, exit with a non-zero code.
          Implies `--dry-run`

      --dry-run
          Compute the lock file without writing to disk. Implies `--no-install`

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

## pixi reinstall --help
```
Re-install an environment.

This command reinstalls an environment, if the lock file is not up-to-date it will be updated. If
packages are specified, only those packages will be reinstalled. Otherwise the whole environment
will be reinstalled.

`pixi reinstall` only re-installs one environment at a time, if you have multiple environments you
can select the right one with the `--environment` flag. If you don't provide an environment, the
`default` environment will be re-installed.

If you want to re-install all environments, you can use the `--all` flag.

Usage: pixi reinstall [OPTIONS] [PACKAGE]...

Arguments:
  [PACKAGE]...
          Specifies the package that should be reinstalled. If no package is given, the whole
          environment will be reinstalled

Options:
  -e, --environment <ENVIRONMENT>
          The environment to install

  -a, --all
          Install all environments

  -p, --platform <PLATFORM>
          Re-install for the given platform; a warning is printed when it doesn't run on this
          machine

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

## pixi publish --help
```
Build the conda packages of a workspace and publish them

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
  - prefix.dev: `https://prefix.dev/<channel-name>` or
    `https://prefix.dev/<namespace>/<channel-name>`
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

## pixi remove --help
```
Remove dependencies from a workspace.

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

## pixi run --help
```
Run a task in an environment.

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

## pixi search --help
```
Search for conda packages

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

## pixi shell --help
```
Start a shell in a pixi environment.

Run `exit` to leave the shell.

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
Print a pixi environment activation script.

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

## pixi task --help
```
Interact with tasks in a workspace

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

## pixi update --help
```
Update dependencies to newer compatible versions.

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

## pixi upgrade --help
```
Check if there are newer versions of the dependencies and upgrade them in the lock file and manifest
file.

`pixi upgrade` loosens the requirements for the given packages, updates the lock file, and adapts
the manifest accordingly. By default, all features are upgraded.

Usage: pixi upgrade [OPTIONS] [PACKAGES]...

Arguments:
  [PACKAGES]...
          The packages to upgrade

Options:
  -f, --feature <FEATURE>
          The feature to update

  -e, --environment <ENVIRONMENT>
          The environment whose inline dependencies should be updated

      --exclude <EXCLUDE>
          The packages which should be excluded

      --json
          Output the changes in JSON format

  -n, --dry-run
          Only show the changes that would be made, without actually updating the manifest, lock
          file, or environment

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

## pixi workspace --help
```
Modify the workspace configuration file

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

## pixi global add --help
```
Adds dependencies to an environment

Example:

- `pixi global add --environment python numpy`
- `pixi global add --environment my_env pytest pytest-cov --expose pytest=pytest`

Usage: pixi global add [OPTIONS] --environment <ENVIRONMENT> [PACKAGE]...

Arguments:
  [PACKAGE]...
          The dependency as names, conda MatchSpecs

Options:
      --path <PATH>
          The path to the local package

      --build-backend <BUILD_BACKEND>
          The build backend to build the source with, when the source does not provide its own
          package manifest (or to override the one it has). Accepts a name with an optional version
          constraint, e.g. `pixi-build-rust` or `"pixi-build-rust>=0.3,<0.4"`

      --package <KEY=VALUE>
          Additional fields of the inline package definition, as `DOTTED_KEY=TOML_VALUE` pairs that
          are recorded under the `package` key of the dependency, e.g.
          `host-dependencies.hatchling="*"` or `build.config.extra-args=["--all-features"]`

  -e, --environment <ENVIRONMENT>
          Specifies the environment that the dependencies need to be added to

      --expose <EXPOSE>
          Add one or more mapping which describe which executables are exposed. The syntax is
          `exposed_name=executable_name`, so for example `python3.10=python`. Alternatively, you can
          input only an executable_name and `executable_name=executable_name` is assumed

Git Options:
      --git <GIT>
          The git url, e.g. `https://github.com/user/repo.git`

      --branch <BRANCH>
          The git branch

      --tag <TAG>
          The git tag

      --rev <REV>
          The git revision

      --subdirectory <SUBDIRECTORY>
          The subdirectory within the git repository

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

## pixi global edit --help
```
Edit the global manifest file

Opens your editor to edit the global manifest file.

Usage: pixi global edit [OPTIONS] [EDITOR]

Arguments:
  [EDITOR]
          The editor to use, defaults to `EDITOR` environment variable or `nano` on Unix and
          `notepad` on Windows
          
          [env: EDITOR=]

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

## pixi global install --help
```
Installs the defined packages in a globally accessible location and exposes their command line
applications.

Example:

- `pixi global install starship nushell ripgrep bat`
- `pixi global install jupyter --with polars`
- `pixi global install --expose python3.8=python python=3.8`
- `pixi global install --environment science --expose jupyter --expose ipython jupyter ipython
polars`

Usage: pixi global install [OPTIONS] [PACKAGE]...

Arguments:
  [PACKAGE]...
          The dependency as names, conda MatchSpecs

Options:
      --path <PATH>
          The path to the local package

      --build-backend <BUILD_BACKEND>
          The build backend to build the source with, when the source does not provide its own
          package manifest (or to override the one it has). Accepts a name with an optional version
          constraint, e.g. `pixi-build-rust` or `"pixi-build-rust>=0.3,<0.4"`

      --package <KEY=VALUE>
          Additional fields of the inline package definition, as `DOTTED_KEY=TOML_VALUE` pairs that
          are recorded under the `package` key of the dependency, e.g.
          `host-dependencies.hatchling="*"` or `build.config.extra-args=["--all-features"]`

  -c, --channel <CHANNEL>
          The channels to consider as a name or a url. Multiple channels can be specified by using
          this field multiple times.
          
          When specifying a channel, it is common that the selected channel also depends on the
          `conda-forge` channel.
          
          By default, if no channel is provided, `conda-forge` is used.

  -p, --platform <PLATFORM>
          The platform to install the packages for.
          
          This is useful when you want to install packages for a different platform than the one you
          are currently on. This is very often used when you want to install `osx-64` packages on
          `osx-arm64`.

  -e, --environment <ENVIRONMENT>
          Ensures that all packages will be installed in the same environment

      --expose <EXPOSE>
          Add one or more mapping which describe which executables are exposed. The syntax is
          `exposed_name=executable_name`, so for example `python3.10=python`. Alternatively, you can
          input only an executable_name and `executable_name=executable_name` is assumed

      --with <WITH>
          Add additional dependencies to the environment. Their executables will not be exposed

      --force-reinstall
          Specifies that the environment should be reinstalled

      --no-shortcuts
          Specifies that no shortcuts should be created for the installed packages

Git Options:
      --git <GIT>
          The git url, e.g. `https://github.com/user/repo.git`

      --branch <BRANCH>
          The git branch

      --tag <TAG>
          The git tag

      --rev <REV>
          The git revision

      --subdirectory <SUBDIRECTORY>
          The subdirectory within the git repository

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

## pixi global uninstall --help
```
Uninstalls environments from the global environment.

Example: `pixi global uninstall pixi-pack rattler-build`

Usage: pixi global uninstall [OPTIONS] <ENVIRONMENT>...

Arguments:
  <ENVIRONMENT>...
          Specifies the environments that are to be removed

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

## pixi global remove --help
```
Removes dependencies from an environment

Use `pixi global uninstall` to remove the whole environment

Example: `pixi global remove --environment python numpy`

Usage: pixi global remove [OPTIONS] <PACKAGE>...

Arguments:
  <PACKAGE>...
          Specifies the package that should be removed

Options:
  -e, --environment <ENVIRONMENT>
          Specifies the environment that the dependencies need to be removed from

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

## pixi global list --help
```
Lists global environments with their dependencies and exposed commands. Can also display all
packages within a specific global environment when using the --environment flag.

All environments:

- Magenta: the name of the environment.
- Green: the packages that are explicit dependencies of the environment.
- Yellow: the binaries that are exposed.
- Dim: the version of the installed package.

Per environment:

- Green: packages that are explicitly installed.

Usage: pixi global list [OPTIONS] [REGEX]

Arguments:
  [REGEX]
          List only packages matching a regular expression. Without regex syntax it acts like a
          `contains` filter

Options:
  -e, --environment <ENVIRONMENT>
          Allows listing all the packages installed in a specific environment, with an output
          similar to `pixi list`

      --sort-by <SORT_BY>
          Sorting strategy for the package table of an environment
          
          [default: name]
          [possible values: size, name]

      --json
          Whether to output in JSON format

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

## pixi global sync --help
```
Sync global manifest with installed environments

Usage: pixi global sync [OPTIONS]

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

## pixi global expose --help
```
Interact with the exposure of binaries in the global environment

`pixi global expose add python310=python3.10 --environment myenv` will expose the `python3.10`
executable as `python310` from the environment `myenv`

`pixi global expose remove python310` will remove the exposed name `python310` from the environment
it belongs to

Usage: pixi global expose [OPTIONS] <COMMAND>

Commands:
  add     Add exposed binaries from an environment to your global environment
  remove  Remove exposed binaries from the global environment
  help    Print this message or the help of the given subcommand(s)

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

## pixi global shortcut --help
```
Interact with the shortcuts on your machine

Usage: pixi global shortcut [OPTIONS] <COMMAND>

Commands:
  add     Add a shortcut from an environment to your machine.
  remove  Remove shortcuts from your machine
  help    Print this message or the help of the given subcommand(s)

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

## pixi global update --help
```
Updates environments in the global environment

Usage: pixi global update [OPTIONS] [ENVIRONMENTS]...

Arguments:
  [ENVIRONMENTS]...
          Specifies the environments that are to be updated

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

## pixi global tree --help
```
Show a tree of a global environment dependencies

Dependency names highlighted in green are directly specified in the manifest.

Usage: pixi global tree [OPTIONS] --environment <ENVIRONMENT> [REGEX]

Arguments:
  [REGEX]
          List only packages matching a regular expression

Options:
  -e, --environment <ENVIRONMENT>
          The environment to list packages for

  -i, --invert
          Invert tree and show what depends on a given package in the regex argument

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

