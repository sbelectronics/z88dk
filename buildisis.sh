#!/bin/bash
rm -f ./lib/clibs/isis_clib.lib ./libsrc/isis_clib.lib
cd libsrc
export ZCCCFG=/home/smbaker/projects/pi/z88dk/lib/config
make isis_clib.lib install

