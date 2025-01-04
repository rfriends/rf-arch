#!/bin/sh
# -----------------------------------------
# Rfriends (radiko radiru録音ツール)
# 1.0 2024/12/16 new github
# 1.1 2025/01/05 fix
ver=1.1
echo start $ver
echo
# -----------------------------------------
optlighttpd="off"
optsamba="on"
export optlighttpd
export optsamba
#
sh arch_install.sh 2>&1 | tee arch_install.log
# -----------------------------------------
# finish
echo
echo finished
# -----------------------------------------
