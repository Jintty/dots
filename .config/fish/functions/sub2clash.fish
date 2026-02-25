function sub2clash --description "Generate a local subconverter URL (encoded) for Clash Party"
    # Usage:
    #   sub2clash 'https://example.com/sub?token=...&x=...'
    #   sub2clash -t clashmeta 'https://example.com/sub?token=...'
    #   sub2clash -p 25500 -h 127.0.0.1 'https://...'

    set -l target clash
    set -l host 127.0.0.1
    set -l port 25500

    argparse 't/target=' 'h/host=' 'p/port=' -- $argv
    or return 2

    if set -q _flag_target
        set target $_flag_target
    end
    if set -q _flag_host
        set host $_flag_host
    end
    if set -q _flag_port
        set port $_flag_port
    end

    if test (count $argv) -lt 1
        echo "Usage: sub2clash [-t clash|clashmeta|...] [-h 127.0.0.1] [-p 25500] '<SUB_URL>'" 1>&2
        return 2
    end

    # Join remaining args into a single URL (in case user didn't quote)
    set -l suburl (string join " " -- $argv)

    # URL-encode via python
    set -lx SUBURL "$suburl"
    set -l encoded (python -c 'import os, urllib.parse; print(urllib.parse.quote(os.environ["SUBURL"], safe=""))')

    echo "http://$host:$port/sub?target=$target&url=$encoded"
end
