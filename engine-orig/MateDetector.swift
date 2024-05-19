//
//  File.swift
//  
//
//  Created by Tony on 22/02/2024.
//

import Foundation

enum MateCheckResult {
    case none, checkmate, stalemate
}

extension Position {
    func mateCheck() -> MateCheckResult {
        let legalMoves = MoveGenerator.run(position: self, player: playerToMove)
        if legalMoves.isEmpty {
            if self.isInCheck(player: playerToMove) {
                return .checkmate
            } else {
                return .stalemate
            }
        } else {
            return .none
        }
    }
}
