//
//  File.swift
//  
//
//  Created by Tony on 02/05/2024.
//

import Foundation

struct AnalysisInfo {
    let gameState: GameState
    let position: Position
    let activePlayerMoves: [Move]
    let passivePlayerMoves: [Move]
    let pieceCounts: PieceCounts
    let playerToMove: Player
    
    /// Total number of pieces on the board
    let totalPieces: Int
    
    init(gameState: GameState) {
        self.gameState = gameState
        position = gameState.currentPosition
        playerToMove = position.playerToMove
        activePlayerMoves = MoveGenerator.run(position: position, player: position.playerToMove)
        passivePlayerMoves = MoveGenerator.run(position: position, player: position.playerToMove.other)
        (pieceCounts, totalPieces) = countPieces(position)
    }
}

fileprivate func countPieces(_ position: Position) -> (PieceCounts, Int) {
    var pieceCounts = PieceCounts()
    
    var totalPieces = 0
    
    try! forAllSquares() {
        let piece = position[$0]
        if piece != .none {
            if let count = pieceCounts[piece] {
                pieceCounts[piece] = count + 1
            } else {
                pieceCounts[piece] = 1
            }
            
            totalPieces += 1
        }
        
        return true
    }
    
    return (pieceCounts, totalPieces)
}




