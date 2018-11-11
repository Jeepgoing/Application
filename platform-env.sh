#
# Copyright (c) 2018 amine
#
# SPDX-License-Identifier: Apache-2.0
#

# identify OS source tree root directory
export PLATFORM_BASE=$( builtin cd "$( dirname "$DIR" )" && pwd ${PWD_OPT})
unset PWD_OPT

