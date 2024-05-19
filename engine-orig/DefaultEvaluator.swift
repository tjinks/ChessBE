//
//  File.swift
//  
//
//  Created by Tony on 01/05/2024.
//

import Foundation

struct DefaultEvaluator : Evaluator {
    let materialScale = 1.0
    let mobilityScale = 0.1
    
    func isApplicable(_ analysisInfo: AnalysisInfo) -> Bool {
        return true
    }
    
    func evaluate(_ analysisInfo: AnalysisInfo) -> Double {
        let materialScore = evaluateMaterial(analysisInfo)
        let mobilityScore = DefaultEvaluator.evaluateMobility(analysisInfo)
        return materialScale * materialScore + mobilityScale * mobilityScore
    }
    
    private static func evaluateMobility(_ analysisInfo: AnalysisInfo) -> Double {
        let activePlayer = analysisInfo.position.playerToMove
        var result = evaluateMobility(analysisInfo: analysisInfo, for: activePlayer)
        result -= evaluateMobility(analysisInfo: analysisInfo, for: activePlayer.other)
        return result
    }
    
    private static func evaluateMobility(analysisInfo: AnalysisInfo, for player: Player) -> Double {
        let position = analysisInfo.position
        let moves = player == position.playerToMove ? analysisInfo.activePlayerMoves : analysisInfo.passivePlayerMoves
        var rookMobility = 0.0
        var queenMobility = 0.0
        var bishopMobility = 0.0
        var knightMobility = 0.0
        let targetKingSquare = player == .white ? position.kingSquare[Player.black.index] : position.kingSquare[Player.white.index]
        for m in moves {
            let distanceToTargetKing = distanceBetween(from: m.from, to: targetKingSquare)
            let inc = 8.0 / (8.0 + distanceToTargetKing)
            switch position.board[m.from].type {
            case .bishop: bishopMobility += inc
            case .knight: knightMobility += inc
            case .queen: queenMobility += inc
            case .rook: rookMobility += inc
            default: break
            }
        }
        
        var result = queenMobility / 40.0
        result += rookMobility / 20.0
        result += bishopMobility / 12.0
        result += knightMobility / 8.0
        return result
    }
}
