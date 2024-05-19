//
//  File.swift
//  
//
//  Created by Tony on 09/02/2024.
//

import Foundation


class MoveGenerator {
    private let position: Position
    private var result: [Move]
    private let player: Player
    private let opponent: Player
    
    static func run(position: Position, player: Player) -> [Move] {
        MoveGenerator(position: position, player: player).result
    }
    
    private init(position: Position, player: Player) {
        self.position = position
        self.player = player
        opponent = player.other
        result = []
        
        for from in 0..<64 {
            if (position.board[from].owner == player) {
                addMoves(from: from)
            }
        }
        
        if position.castlingRights != 0 {
            addCastlingMoves()
        }
    }
    
    private func addMoves(from: Int) {
        switch (position.board[from].type) {
        case .king:
            addKingMoves(from: from)
        case .queen:
            addQueenMoves(from: from)
        case .rook:
            addRookMoves(from: from)
        case .bishop:
            addBishopMoves(from: from)
        case .knight:
            addKnightMoves(from: from)
        case .pawn:
            addPawnMoves(from: from)
            addPawnCaptures(from: from)
        case .none:
            break
        }
    }
    
    private func addKingMoves(from: Int) {
        SquareInfo[from].kingMoves.foreach() {
            addIfPossible(from: from, to: $0)
            return true
        }
    }
    
    private func addKnightMoves(from: Int) {
        SquareInfo[from].knightMoves.foreach() {
            addIfPossible(from: from, to: $0)
            return true
        }
    }
    
    private func addBishopMoves(from: Int) {
        let squareInfo = SquareInfo[from]

        squareInfo.ne.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        squareInfo.nw.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.se.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.sw.foreach() {
            return addIfPossible(from: from, to: $0)
        }
    }
    
    private func addRookMoves(from: Int) {
        let squareInfo = SquareInfo[from]

        squareInfo.north.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.south.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.east.foreach() {
            return addIfPossible(from: from, to: $0)
        }
        
        squareInfo.west.foreach() {
            return addIfPossible(from: from, to: $0)
        }
    }
    
    private func addQueenMoves(from: Int) {
        addRookMoves(from: from)
        addBishopMoves(from: from)
    }
    
    private func addPawnMoves(from: Int) {
        let squareInfo = SquareInfo[from]
        squareInfo.pawnMoves[player.index].foreach() {
            if position.board[$0].owner != nil {
                return false
            }
            
            addPawnMove(from: from, to: $0)
            return true
        }
    }
    
    private func addMove(_ move: Move) {
        let newPosition = position.makeMove(move)
        if newPosition.isInCheck(player: position.playerToMove) {
            return
        }
        
        result.append(move)
    }
    
    private func addPawnCaptures(from: Int) {
        SquareInfo[from].pawnCaptures[player.index].foreach() {
            if position.board[$0].owner == opponent {
                addPawnMove(from: from, to: $0)
            } else if $0 == position.epSquare {
                let move = Move.normal(from: from, to: $0, promoteTo: nil)
                addMove(move)
            }
            
            return true
        }
    }
    
    private func addPawnMove(from: Int, to: Int) {
        let isPromotion = (to >= a8 && player == .white) || (to <= h1 && player == .black)
        if isPromotion {
            let options = [Piece(player, .queen), Piece(player, .rook), Piece(player, .bishop), Piece(player, .knight)]
            for p in options {
                let move = Move.normal(from: from, to: to, promoteTo: p)
                addMove(move)
            }
        } else {
            let move = Move.normal(from: from, to: to, promoteTo: nil)
            addMove(move)
        }
    }
    
    private func addCastlingMoves() {
        switch player {
        case .white:
            if (position.castlingRights & whiteKingside) != 0 {
                tryAdd(castlingMove: .whiteCastlesShort, intermediateSquares: [f1, g1])
            }
            
            if (position.castlingRights & whiteQueenside) != 0 {
                tryAdd(castlingMove: .whiteCastlesLong, intermediateSquares: [d1, c1, b1])
            }
        case .black:
            if (position.castlingRights & blackKingside) != 0 {
                tryAdd(castlingMove: .blackCastlesShort, intermediateSquares: [f8, g8])
            }
            
            if (position.castlingRights & blackQueenside) != 0 {
                tryAdd(castlingMove: .blackCastlesLong, intermediateSquares: [d8, c8, b8])
            }
        }
        
        func tryAdd(castlingMove: Move, intermediateSquares: [Int]) {
            for i in intermediateSquares {
                if position.board[i] != Piece.none {
                    return
                }
            }
            
            if position.isAttacked(square: intermediateSquares[0], by: opponent) {
                return
            }
            
            addMove(castlingMove)
        }
    }
    
    @discardableResult private func addIfPossible(from: Int, to: Int) -> Bool {
        let piece = position.board[to]
        if piece.owner == player {
            return false
        } else if piece.owner == opponent {
            addMove(.normal(from: from, to: to, promoteTo: nil))
            return false
        } else {
            addMove(.normal(from: from, to: to, promoteTo: nil))
            return true
        }
    }
}
