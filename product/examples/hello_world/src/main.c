/*
 * Copyright (c) 2018 amine
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#ifdef CONFIG_COMM
#include "components/comm.h"
#endif
#ifdef CONFIG_PROTOCOL
#include "components/protocol.h"
#endif
#ifdef CONFIG_CJSON
#include "subsys/cJSON.h"
#endif

int main(int argc, char *argv[])
{
    printf("Hello World!\n");
#ifdef CONFIG_COMM
    comm_echo();
#endif

#ifdef CONFIG_PROTOCOL
    protocol_echo();
#endif

    return 0;
}

