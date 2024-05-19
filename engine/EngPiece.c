//
//  EngPiece.c
//  ChessBE
//
//  Created by Tony on 17/05/2024.
//

#include "EngPiece.h"

extern EngPiece engPiece(EngPlayer owner, EngPieceType type);

extern EngPieceType engGetPieceType(EngPiece piece);

extern EngPlayer engGetOwner(EngPiece piece);

inline EngPlayer engGetOpponent(EngPlayer player);
