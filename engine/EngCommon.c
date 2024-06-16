//
//  EngCommon.c
//  ChessBE
//
//  Created by Tony on 18/05/2024.
//

#include <stdlib.h>
#include <stdio.h>
#include "EngCommon.h"

void *engGetMem(size_t required) {
    void *result = malloc(required);
    if (result) {
        return result;
    }
    
    fprintf(stderr, "Out of memory!\n");
    exit(1);
}

void engFreeMem(void *p) {
    free(p);
}

