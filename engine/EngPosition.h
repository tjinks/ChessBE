//
//  EngPosition.h
//  ChessBE
//
//  Created by Tony on 18/05/2024.
//

#ifndef EngPosition_h
#define EngPosition_h

enum {
    a1, b1, c1, d1, e1, f1, g1, h1,
    a2, b2, c2, d2, e2, f2, g2, h2,
    a3, b3, c3, d3, e3, f3, g3, h3,
    a4, b4, c4, d4, e4, f4, g4, h4,
    a5, b5, c5, d5, e5, f5, g5, h5,
    a6, b6, c6, d6, e6, f6, g6, h6,
    a7, b7, c7, d7, e7, f7, g7, h7,
    a8, b8, c8, d8, e8, f8, g8, h8
};

typedef enum {
    WhiteLong = 1
    ,WhiteShort = 2
    ,BlackLong = 4
    ,BlackShort = 8
} EngCastlingFlags

typedef struct {
    Piece board[64];
    int castlingFlags;
    int epSquare;
    int hash;
    Player playerToMove;
} EngPosition;

typedef struct EngGameState {
    struct EngGameState *prev;
    Position position;
    int halfMoveClock;
    int moveNumber;
} EngGameState;

EngGameState *engMakeMove(const EngGameState *initialState, EngMove move);

#endif /* EngPosition_h */
