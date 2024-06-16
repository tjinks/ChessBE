//
//  EngMoveGenerator.c
//  ChessBE
//
//  Created by Tony on 19/05/2024.
//

#include <stdlib.h>
#include <string.h>
#include "EngMoveGenerator.h"
#include "EngCommon.h"
#include "EngPosition.h"
#include "EngPiece.h"

static const size_t MovesOffset =  offsetof(EngMoveList, moves);
static const size_t MoveSize = sizeof(EngMove);
static const size_t InitialMoveListSize = 16;

static const int North = 8;
static const int South = -8;
static const int East = 1;
static const int West = -1;
static const int Ne = 9;
static const int Nw = 7;
static const int Se = -7;
static const int Sw = -9;

typedef struct {
    const EngPosition *position;
    EngMoveList *moveList;
    EngPlayer player;
} MoveGenerator;

static EngMoveList *mlFreeList = NULL;

static inline int rank(int square) {
    return square / 8;
}

static inline int file(int square) {
    return square % 8;;
}

static EngMoveList *createMoveList(void) {
    size_t required = MovesOffset + InitialMoveListSize * MoveSize;
    EngMoveList *result = engGetMem(required);
    result->capacity = InitialMoveListSize;
    result->size = 0;
    result->next = NULL;
    return result;
}

static EngMoveList *getMoveList(void) {
    if (mlFreeList) {
        EngMoveList *result = mlFreeList;
        mlFreeList = mlFreeList->next;
        return result;
    } else {
        return createMoveList();
    }
}

static EngMoveList *expand(const EngMoveList *moveList) {
    int newCapacity = 2 * moveList->capacity;
    EngMoveList *result = engGetMem(MovesOffset + newCapacity * MoveSize);
    memcpy(result, moveList, MovesOffset + moveList->size * MoveSize);
    result->capacity = newCapacity;
    return result;
}

inline static EngMoveList *addMove(EngMoveList *moveList, EngMove move) {
    EngMoveList *result;
    if (moveList->capacity == moveList->size) {
        result = expand(moveList);
    } else {
        result = moveList;
    }
    
    moveList->moves[moveList->size] = move;
    moveList->size++;
    return moveList;
}

static void freeMoveList(EngMoveList *moveList) {
    moveList->next = mlFreeList;
    mlFreeList = moveList;
}

static EngMove createSimpleMove(const EngPosition *position, int from, int to) {
    EngMove result;
    result.atomCount = 2;
    result.atoms[1].square = to;
    result.atoms[1].newContents = position->board[from];
    result.atoms[0].square = from;
    result.atoms[0].newContents = NoPiece;
}

static void addSimpleMove(MoveGenerator *generator, int from, int to) {
    EngMove move;
    move.atomCount = 2;
    move.atoms[1].square = to;
    move.atoms[1].newContents = generator->position->board[from];
    move.atoms[0].square = from;
    move.atoms[0].newContents = NoPiece;
    generator->moveList = addMove(generator->moveList, move);
}

static void tryAddSimpleMove(MoveGenerator *generator, int from, int to) {
    int targetPiece = generator->position->board[to];
    if (engGetOwner(targetPiece) != generator->player) {
        addSimpleMove(generator, from, to);
    }
}

static void addSlidingMoves(MoveGenerator *generator, int from, int direction) {
    int current = from;
    for (;;) {
        switch (direction) {
            case North:
                if (rank(current) == 7) return;
            case South:
                if (rank(current) == 0) return;
            case East:
                if (file(current) == 7) return;
            case West:
                if (file(current) == 0) return;
            case Ne:
                if (rank(current) == 7 || file(current) == 7) return;
            case Nw:
                if (rank(current) == 7 || file(current) == 0) return;
            case Se:
                if (rank(current) == 0 || file(current) == 7) return;
            case Sw:
                if (rank(current) == 0 || file(current) == 0) return;
        }
        
        current += direction;
        EngPiece piece = generator->position->board[current];
        EngPlayer owner = engGetOwner(piece);
        if (owner == generator->player) {
            return;
        }
        
        addSimpleMove(generator, from, current);
        if (owner != NoPlayer) {
            return;
        }
    }
}

static void addRookMoves(MoveGenerator *generator, int from) {
    addSlidingMoves(generator, from, North);
    addSlidingMoves(generator, from, South);
    addSlidingMoves(generator, from, East);
    addSlidingMoves(generator, from, West);
}

static void addBishopMoves(MoveGenerator *generator, int from) {
    addSlidingMoves(generator, from, Ne);
    addSlidingMoves(generator, from, Nw);
    addSlidingMoves(generator, from, Se);
    addSlidingMoves(generator, from, Sw);
}

static void addQueenMoves(MoveGenerator *generator, int from) {
    addBishopMoves(generator, from);
    addRookMoves(generator, from);
}

static void addKingMoves(MoveGenerator *generator, int from) {
    static int directions[] = {North, South, East, West, Ne, Nw, Se, Sw};
    int r = rank(from);
    int f = file(from);
    for (int i = 0; i < 8; i++) {
        int direction = directions[i];
        switch (direction) {
            case North:
                if (r == 7) continue;
            case South:
                if (r == 0) continue;
            case East:
                if (f == 7) continue;
            case West:
                if (f == 0) continue;
            case Ne:
                if (r == 7 || f == 7) continue;
            case Nw:
                if (r == 7 || f == 0) continue;
            case Se:
                if (r == 0 || f == 7) continue;
            case Sw:
                if (r == 0 || f == 0) continue;
        }
        
        tryAddSimpleMove(generator, from, from + direction);
    }
}

static void addKnightMoves(MoveGenerator *generator, int from) {
    int r = rank(from);
    int f = file(from);
    if (r < 6 && f < 7) tryAddSimpleMove(generator, from, from + North + Ne);
    if (r < 7 && f < 6) tryAddSimpleMove(generator, from, from + East + Ne);
    if (r > 0 && f < 6) tryAddSimpleMove(generator, from, from + East + Se);
    if (r > 1 && f < 7) tryAddSimpleMove(generator, from, from + South + Se);
    if (r > 1 && f > 0) tryAddSimpleMove(generator, from, from + South + Sw);
    if (r > 0 && f > 1) tryAddSimpleMove(generator, from, from + West + Sw);
    if (r < 7 && f > 1) tryAddSimpleMove(generator, from, from + West + Nw);
    if (r < 6 && f > 0) tryAddSimpleMove(generator, from, from + North + Nw);
}

static void add

EngMoveList *engGenerateMoves(const EngPosition *position) {
    
}
