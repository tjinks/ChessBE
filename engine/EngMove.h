//
//  EngMove.h
//  ChessBE
//
//  Created by Tony on 17/05/2024.
//

#ifndef EngMove_h
#define EngMove_h

#include "EngPiece.h"

typedef struct {
    int square;
    EngPiece newContents;
} EngMoveAtom;

typedef struct {
    int atomCount;
    EngMoveAtom atoms[4];
    int epSquare;
    double score;
} EngMove;

#endif /* EngMove_h */
