#
# Copyright (c) 2018 amine
#
# SPDX-License-Identifier: Apache-2.0
#

if [ -n "$ZSH_VERSION" ]; then
	DIR="${(%):-%N}"
	if [ $options[posixargzero] != "on" ]; then
		setopt posixargzero
		NAME=$(basename -- "$0")
		setopt posixargzero
	else
		NAME=$(basename -- "$0")
	fi
else
	DIR="${BASH_SOURCE[0]}"
	NAME=$(basename -- "$0")
fi

if [ "X$NAME" "==" "Xplatform-env.sh" ]; then
    echo "Source this file (do NOT execute it!) to set the Platform environment."
    exit
fi

if uname | grep -q "MINGW"; then
    win_build=1
    PWD_OPT="-W"
else
    win_build=0
    PWD_OPT=""
fi

# identify OS source tree root directory
export PLATFORM_BASE=$( builtin cd "$( dirname "$DIR"  )" > /dev/null && pwd ${PWD_OPT} )
unset PWD_OPT

export CROSS_COMPILE=${PLATFORM_BASE}/toolchain/aarch64-linux-gnu/bin/aarch64-linux-gnu-

