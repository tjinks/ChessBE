//
//  EngPosition.c
//  ChessBE
//
//  Created by Tony on 18/05/2024.
//

#include <stdio.h>
#include "EngPosition.h"
#include "EngPiece.h"
#include "EngMove.h"
#include "EngCommon.h"

static EngGameState *gsFreeList = NULL;

static EngGameState *getGameState(void) {
    if (gsFreeList) {
        EngGameState *result = gsFreeList;
        gsFreeList = gsFreeList->prev;
        return result;
    } else {
        return getMem(sizeof(EngGameState));
    }
}

static void releaseGameState(EngGameState *gs) {
    gs->prev = gsFreeList;
    gsFreeList = gs;
}

static void updatePosition(EngPosition *position, EngMove move) {
    int hash = position->hash;
    for (int i = 0; i < move.atomCount; i++) {
        int square = move.atoms[i].square;
        EngPiece newContents = move.atoms[i].newContents;
        EngPiece originalContents = position->board[square];
        position->board[square] = newContents;
        hash += 255 * (square + 1) * (newContents - originalContents);
        if (position->castlingFlags) {
            switch (square) {
                case a1:
                    position->castlingFlags &= ~WhiteLong;
                    break;
                case e1:
                    position->castlingFlags &= ~(WhiteLong | WhiteShort);
                    break;
                case h1:
                    position->castlingFlags &= ~WhiteShort;
                    break;
                case a8:
                    position->castlingFlags &= ~BlackLong;
                    break;
                case e8:
                    position->castlingFlags &= ~(BlackLong | BlackShort);
                    break;
                case h8:
                    position->castlingFlags &= ~BlackShort;
                    break;
            }
        }
    }
    
    position->hash = hash;
    position->epSquare = move.epSquare;
}

EngGameState *engMakeMove(const EngGameState *initialState, EngMove move) {
    EngGameState *result = getGameState();
    *result = *initialState;
    updatePosition(result->position, move);
}
