/*
 * Copyright (c) 2018 amine
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdio.h>
#include "comm.h"

void main(void)
{
#ifdef CONFIG_COMM
    comm_echo();
#endif
	printf("Hello World!\n");
}

