# kakoune-wakatime

This plugin performs time-tracking in Kakoune with [WakaTime](https://wakatime.com).

## Installing

1. Install [wakatime-cli](https://github.com/wakatime/wakatime-cli/releases) by running this shell command:

    ```
    curl -fsSL https://raw.githubusercontent.com/wakatime/vim-wakatime/master/scripts/install_cli.py | python
    ```

2. Create a file at `$HOME/.wakatime.cfg` with contents:

    ```
    [settings]
    api_key = your-real-key
    ```

    Get your WakaTime API Key here: [https://wakatime.com/api-key](https://wakatime.com/api-key)

3. Install the plugin in kakoune:

    You may put `kakoune-wakatime` in your autoload repository, located at
    `$XDG_CONFIG_HOME/kak/autoload/`, `~/.config/kak/autoload/` or in the system autoload directory, at
    `/usr/share/kak/autoload/`, or one of their subdirectories.

    The plugin has also been tested through [plug.kak](https://github.com/andreyorst/plug.kak),
    in which case you just need to add the following to your kakrc:

    ```kak
    plug "wakatime/kakoune-wakatime"
    ```

## Configuration

### `wakatime_cli` (`str`)
The path to your wakatime-cli, defaults to `~/.wakatime/wakatime-cli`.

### `wakatime_debug` (`bool`)
Enable debug messages (showing each executed beat)

## Troubleshooting

For troubleshooting, read [How to debug a WakaTime plugin](https://wakatime.com/faq#debug-plugins).
