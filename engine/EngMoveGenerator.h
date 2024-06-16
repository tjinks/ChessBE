//
//  EngMoveGenerator.h
//  ChessBE
//
//  Created by Tony on 19/05/2024.
//

#ifndef EngMoveGenerator_h
#define EngMoveGenerator_h

#include "EngMove.h"

typedef struct EngMoveList {
    struct EngMoveList *next;
    int size, capacity;
    EngMove moves[1];
} EngMoveList;

#endif /* EngMoveGenerator_h */
