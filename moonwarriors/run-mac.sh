#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BIN="$DIR/proj.mac/bin/moonwarriors.app/Contents/MacOS/moonwarriors"
if [ ! -f $BIN ]; then
    echo "PLEASE BUILD proj.mac/moonwarriors.xcodeproj FIRST"
    exit
fi

ARG="-relaunch-off -quick $QUICK_COCOS2DX_ROOT -workdir $DIR"
SIZE="-portrait"
CMD="$BIN $ARG $SIZE"

until $CMD; do
    echo ""
    echo "------------------------------------------------------"
    echo ""
    echo ""
    echo ""
done
