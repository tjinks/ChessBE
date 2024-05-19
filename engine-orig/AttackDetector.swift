//
//  File.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import Foundation

extension Position {
    func isInCheck(player: Player) -> Bool {
        return isAttacked(square: kingSquare[player.index], by: player.other)
    }
    
    func isAttacked(square: Int, by player: Player) -> Bool {
        let squareInfo = SquareInfo[square]
        
        if checkForNonSlidingAttack(from: squareInfo.pawnCaptures[player.other.index], by: Piece(player, .pawn)) {
            return true
        }
        
        if checkForNonSlidingAttack(from: squareInfo.knightMoves, by: Piece(player, .knight)) {
            return true
        }

        if checkForNonSlidingAttack(from: squareInfo.kingMoves, by: Piece(player, .king)) {
            return true
        }

        if checkForSlidingAttack(from: squareInfo.nw, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.ne, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.sw, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.se, by: bishopOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.north, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.south, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.east, by: rookOrQueen) {
            return true
        }
        
        if checkForSlidingAttack(from: squareInfo.west, by: rookOrQueen) {
            return true
        }
        
        return false

        func rookOrQueen(p: PieceType) -> Bool {
            return p.movesOrthogonally()
        }

        func bishopOrQueen(p: PieceType) -> Bool {
            return p.movesDiagonally()
        }
        
        func checkForSlidingAttack(from: Int64, by: (PieceType) -> Bool) -> Bool {
            var result = false
            from.foreach() {
                let piece = self.board[$0]
                if piece.owner == player {
                    result = by(piece.type)
                    return false
                } else if piece.owner == player.other {
                    result = false
                    return false
                }
                
                return true
            }
            
            return result
        }
        
        func checkForNonSlidingAttack(from: Int64, by: Piece) -> Bool {
            var result = false
            from.foreach() {
                let piece = self.board[$0]
                if piece == by {
                    result = true
                    return false
                }
                
                return true
            }
            
            return result
        }
    }
}
