//
//  EngPiece.h
//  ChessBE
//
//  Created by Tony on 17/05/2024.
//

#ifndef EngPiece_h
#define EngPiece_h

typedef enum {
    Pawn = 0
    ,Knight
    ,Bishop
    ,Rook
    ,Queen
    ,King
    ,NoPieceType
} EngPieceType;

typedef enum {
    White = 0,
    Black,
    NoPlayer
} EngPlayer;

typedef enum {
    WhitePawn = Pawn
    ,WhiteKnight
    ,WhiteBishop
    ,WhiteRook
    ,WhiteQueen
    ,WhiteKing
    ,BlackPawn = WhitePawn + 16
    ,BlackKnight
    ,BlackBishop
    ,BlackRook
    ,BlackQueen
    ,BlackKing
    ,NoPiece = NoPlayer * 16 + NoPieceType
} EngPiece;

inline EngPiece engPiece(EngPlayer owner, EngPieceType type) {
    return owner * 16 + type;
}

inline EngPieceType engGetPieceType(EngPiece piece) {
    return piece % 16;
}

inline EngPlayer engGetOwner(EngPiece piece) {
    return piece / 16;
}

inline EngPlayer engGetOpponent(EngPlayer player) {
    switch (player) {
    case White:
        return Black;
    case Black:
        return White;
    default:
        return NoPlayer;
    }
}

#endif /* EngPiece_h */
