# wakatime.kak version 3.1.2
# By Nodyn

decl str     wakatime_cli      "~/.wakatime/wakatime-cli"
decl bool    wakatime_debug    true

decl -hidden str  wakatime_version  "3.1.2"

decl -hidden str  wakatime_beat_rate  120
decl -hidden str  wakatime_last_file
decl -hidden int  wakatime_last_beat


def -hidden  wakatime-heartbeat -params 0..1 %{
  evaluate-commands %sh{
    # If we're not in a real file, abort.
    if [ "$kak_buffile" = "$kak_bufname" ]; then
      exit
    fi

    # Get the current time.
    now=$(date "+%s")

    # Can we send a heartbeat?
    if [ "$kak_buffile" = "$kak_opt_wakatime_last_file" ]; then
      if [ "$1" != "write" ]; then
        if [ $(($now - ${kak_opt_wakatime_last_beat:-0})) -lt $kak_opt_wakatime_beat_rate ]; then
          exit
        fi
      fi
    fi

    if [ "$kak_opt_wakatime_debug" = "true" ]; then
      echo "echo -debug '[WakaTime Debug] Sending a heartbeat $now'"
    fi

    echo "set global wakatime_last_file '$kak_buffile'"
    echo "set global wakatime_last_beat $now"

    command="$kak_opt_wakatime_cli"
    command="$command --entity \"$kak_buffile\""
    command="$command --time $now"
    command="$command --plugin \"kakoune/$kak_version kakoune-wakatime/$kak_opt_wakatime_version\""
    if [ "$1" = "write" ]; then
      command="$command --write"
    fi
    if [ -n "$kak_cursor_byte_offset" ]; then
      command="$command --cursorpos $kak_cursor_byte_offset"
    fi
    if [ -n "$kak_filetype" ]; then
      command="$command --alternate-language $kak_filetype"
    fi

    (eval "$command") < /dev/null > /dev/null 2> /dev/null &
  }
}

def -hidden  wakatime-init %{
  evaluate-commands %sh{
    echo "echo -debug '[WakaTime] Ready.'"
    echo "hook -group WakaTime global InsertKey .* %{ wakatime-heartbeat }"
    echo "hook -group WakaTime global ModeChange push:.*:insert %{ wakatime-heartbeat }"
    echo "hook -group WakaTime global BufWritePost .* %{ wakatime-heartbeat write }"
    echo "hook -group WakaTime global BufCreate .* %{ wakatime-heartbeat }"
  }
}

hook -group WakaTime global KakBegin .* %{ wakatime-init }
