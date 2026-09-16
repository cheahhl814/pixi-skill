
# Environment variables {#__skip}

## Configurable Environment Variables[\#](#configurable-environment-variables "Permanent link"){.headerlink}

Pixi can also be configured via environment variables.

+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Name                     | Description                                                                                                                                                                                                                                                                                                                                                        | Default                                                                                                                                                      |
+==========================+====================================================================================================================================================================================================================================================================================================================================================================+==============================================================================================================================================================+
| `PIXI_HOME`              | Defines the directory where pixi puts its global data.                                                                                                                                                                                                                                                                                                             | [HOME](https://docs.rs/dirs/latest/dirs/fn.home_dir.html)/.pixi                                                                                              |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `PIXI_CACHE_DIR`         | Defines the directory where pixi puts its cache.                                                                                                                                                                                                                                                                                                                   | - If `PIXI_CACHE_DIR` is not set, the `RATTLER_CACHE_DIR` environment variable is used.                                                                      |
|                          |                                                                                                                                                                                                                                                                                                                                                                    | - If that is not set, `XDG_CACHE_HOME/pixi` is used when the directory exists.                                                                               |
|                          |                                                                                                                                                                                                                                                                                                                                                                    | - If that is not set, the default cache directory of [rattler::default_cache_dir](https://docs.rs/rattler/latest/rattler/fn.default_cache_dir.html) is used. |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `PIXI_NO_CONFIG`         | When set to a truthy value (e.g. `1`), pixi skips loading system and user-level configuration files (such as `/etc/pixi/config.toml` and `~/.pixi/config.toml`). Project-local `<project>/.pixi/config.toml` is still loaded. Equivalent to passing `--no-config`. Useful in CI, scripts, and tests that need to be insulated from a developer\'s global settings. | Not set.                                                                                                                                                     |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `PIXI_CONFIG_FILE`       | Path to a configuration file to load *instead of* the system and user-level config files. Project-local `<project>/.pixi/config.toml` is still merged on top. Equivalent to passing `--config-file <PATH>`.                                                                                                                                                        | Not set.                                                                                                                                                     |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `PIXI_OVERRIDE_PLATFORM` | Overrides the detected host platform used to select and install environments. Accepts any valid platform string (e.g. `linux-aarch64`, `osx-arm64`, `win-64`).                                                                                                                                                                                                     | Not set, pixi detects the current platform automatically.                                                                                                    |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `PIXI_GIT_LFS`           | Deprecated: set `lfs = true` on the git dependency in the manifest instead. When set to a truthy value (e.g. `1`), pixi fetches Git LFS objects for git dependencies.                                                                                                                                                                                              | Not set.                                                                                                                                                     |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+
| `RATTLER_AUTH_FILE`      | Overrides the default location of the credentials file. When set, this is the only source of authentication data used by pixi. See [authentication docs](../../../deployment/authentication/#override-the-authentication-storage) for the file format.                                                                                                             | - If `RATTLER_AUTH_FILE` is not set, the system keyring is used.                                                                                             |
|                          |                                                                                                                                                                                                                                                                                                                                                                    | - If no keyring is available, file storage from `~/.rattler/credentials.json` is used.                                                                       |
|                          |                                                                                                                                                                                                                                                                                                                                                                    | - Additionally, `.netrc` file authentication is checked.                                                                                                     |
+--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------+

## Environment Variables Set By Pixi[\#](#environment-variables-set-by-pixi "Permanent link"){.headerlink}

The following environment variables are set by Pixi, when using the `pixi run`, `pixi shell`, or `pixi shell-hook` command:

- `PIXI_PROJECT_ROOT`: The root directory of the project.
- `PIXI_PROJECT_NAME`: The name of the project.
- `PIXI_PROJECT_MANIFEST`: The path to the manifest file (`pixi.toml`).
- `PIXI_PROJECT_VERSION`: The version of the project.
- `PIXI_PROMPT`: The prompt to use in the shell, also used by `pixi shell` itself.
- `PIXI_ENVIRONMENT_NAME`: The name of the environment, defaults to `default`.
- `PIXI_ENVIRONMENT_PLATFORMS`: Comma separated list of platforms supported by the project.
- `CONDA_PREFIX`: The path to the environment. (Used by multiple tools that already understand conda environments)
- `CONDA_DEFAULT_ENV`: The name of the environment. (Used by multiple tools that already understand conda environments)
- `PATH`: We prepend the `bin` directory of the environment to the `PATH` variable, so you can use the tools installed in the environment directly.
- `INIT_CWD`: ONLY IN `pixi run`: The directory where the command was run from.

::: {.admonition .note}
Note

Even though the variables are environment variables these cannot be overridden. E.g. you can not change the root of the project by setting `PIXI_PROJECT_ROOT` in the environment.
:::

## Environment Variable Priority[\#](#environment-variable-priority "Permanent link"){.headerlink}

The following priority rule applies for environment variables: `task.env` \> `activation.env` \> `activation.scripts` \> activation scripts of dependencies \> outside environment variables. Variables defined at a higher priority will override those defined at a lower priority.

::: {.admonition .warning}
Warning

In older versions of Pixi, this priority was not well-defined, and there are a number of known deviations from the current priority which exist in some older versions. Please see the warning in [the advanced tasks documentation](../../workspace/advanced_tasks/#environment-variables) for further details and migration guidance.
:::

##### Example 1: `task.env` \> `activation.env`[\#](#example-1-taskenv-activationenv "Permanent link"){.headerlink} {#example-1-taskenv-activationenv}

In `pixi.toml`, we defined an environment variable `HELLO_WORLD` in both `tasks.hello` and `activation.env`.

When we run `echo $HELLO_WORLD`, it will output:

::: {.language-text .highlight}
    Hello world!
:::

::: {.language-toml .highlight}
[pixi.toml]{.filename}

    [tasks.hello]
    cmd = "echo $HELLO_WORLD"
    env = { HELLO_WORLD = "Hello world!" }
    [activation.env]
    HELLO_WORLD = "Activate!"
:::

##### Example 2: `activation.env` \> `activation.scripts`[\#](#example-2-activationenv-activationscripts "Permanent link"){.headerlink} {#example-2-activationenv-activationscripts}

In `pixi.toml`, we defined the same environment variable `DEBUG_MODE` in both `activation.env` and in the activation script file `setup.sh`. When we run `echo Debug mode: $DEBUG_MODE`, it will output:

::: {.language-bash .highlight}
    Debug mode: enabled
:::

::: {.language-toml .highlight}
[pixi.toml]{.filename}

    [activation.env]
    DEBUG_MODE = "enabled"

    [activation]
    scripts = ["setup.sh"]
:::

::: {.language-bash .highlight}
[setup.sh]{.filename}

    export DEBUG_MODE="disabled"
:::

##### Example 3: `activation.scripts` \> activation scripts of dependencies[\#](#example-3-activationscripts-activation-scripts-of-dependencies "Permanent link"){.headerlink} {#example-3-activationscripts-activation-scripts-of-dependencies}

In `pixi.toml`, we have our local activation script and a dependency `my-package` that also sets environment variables through its activation scripts. When we run `echo Library path: $LIB_PATH`, it will output:

::: {.language-text .highlight}
    Library path: /my/lib
:::

::: {.language-toml .highlight}
[pixi.toml]{.filename}

    [activation]
    scripts = ["local_setup.sh"]

    [dependencies]
    my-package = "*"  # This package has its own activation scripts that set LIB_PATH="/dep/lib"
:::

::: {.language-bash .highlight}
[local_setup.sh]{.filename}

    export LIB_PATH="/my/lib"
:::

##### Example 4: activation scripts of dependencies \> outside environment variable[\#](#example-4-activation-scripts-of-dependencies-outside-environment-variable "Permanent link"){.headerlink}

If we have a dependency that sets `PYTHON_PATH` and the same variable is already set in the outside environment. When we run `echo Python path: $PYTHON_PATH`, it will output:

::: {.language-bash .highlight}
    Python path: /pixi/python
:::

::: {.language-text .highlight}
    # Outside environment
    export PYTHON_PATH="/system/python"
:::

::: {.language-toml .highlight}
[pixi.toml]{.filename}

    [dependencies]
    python-utils = "*"  # This package sets PYTHON_PATH="/pixi/python" in its activation scripts
:::

##### Example 5: Complex Example - All priorities combined[\#](#example-5-complex-example-all-priorities-combined "Permanent link"){.headerlink} {#example-5-complex-example-all-priorities-combined}

In `pixi.toml`, we define the same variable `APP_CONFIG` across multiple levels:

::: {.language-toml .highlight}
[pixi.toml]{.filename}

    [tasks.start]
    cmd = "echo Config: $APP_CONFIG"
    env = { APP_CONFIG = "task-specific" }

    [activation.env]
    APP_CONFIG = "activation-env"

    [activation]
    scripts = ["app_setup.sh"]

    [dependencies]
    config-loader = "*"  # Sets APP_CONFIG="dependency-config"
:::

::: {.language-bash .highlight}
[app_setup.sh]{.filename}

    export APP_CONFIG="activation-script"
:::

::: {.language-bash .highlight}
    # Outside environment
    export APP_CONFIG="system-config"
:::

Since `task.env` has the highest priority, when we run `pixi run start` it will output:

::: {.language-text .highlight}
    Config: task-specific
:::
