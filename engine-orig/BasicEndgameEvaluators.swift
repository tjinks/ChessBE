//
//  File.swift
//  
//
//  Created by Tony on 26/04/2024.
//

import Foundation

struct MajorPieceAndKingVsKingEvaluator : Evaluator {
    func isApplicable(_ analysisInfo: AnalysisInfo) -> Bool {
        var activePlayerHasMajorPiece = false
        var passivePlayerHasMajorPiece = false
        var activePlayerHasNoPieces = true
        var passivePlayerHasNoPieces = true
        for piece in analysisInfo.pieceCounts.keys {
            if piece.owner == analysisInfo.playerToMove {
                switch piece.type {
                case .rook, .queen:
                    activePlayerHasMajorPiece = true
                    activePlayerHasNoPieces = false
                case .bishop, .knight, .pawn:
                    activePlayerHasNoPieces = false
                default:
                    break
                }
            } else {
                switch piece.type {
                case .rook, .queen:
                    passivePlayerHasMajorPiece = true
                    passivePlayerHasNoPieces = false
                case .bishop, .knight, .pawn:
                    passivePlayerHasNoPieces = false
                default:
                    break
                }
            }
        }

        if activePlayerHasMajorPiece && passivePlayerHasNoPieces {
            return true
        }
        
        if passivePlayerHasMajorPiece && activePlayerHasNoPieces {
            return true
        }
        
        return false
    }
    
    func evaluate(_ analysisInfo: AnalysisInfo) -> Double {
        let position = analysisInfo.position
        let playerToMove = position.playerToMove
        let attacker = {
            if evaluateMaterial(analysisInfo) > drawEvaluation {
                return playerToMove
            } else {
                return playerToMove.other
            }
        }()
        
        let attackingKingSquare = position.kingSquare[attacker.index]
        let defendingKingSquare = position.kingSquare[attacker.other.index]
        var cornerScore = distanceBetween(from: defendingKingSquare, to: a1)
        cornerScore = min(cornerScore, distanceBetween(from: defendingKingSquare, to: a8))
        cornerScore = min(cornerScore, distanceBetween(from: defendingKingSquare, to: h1))
        cornerScore = min(cornerScore, distanceBetween(from: defendingKingSquare, to: h8))
        
        cornerScore = 8.0 - cornerScore
        
        let edgeScore = 8.0 - edgeDistance(defendingKingSquare)
        
        let kdScore = 8.0 - distanceBetween(from: attackingKingSquare, to: defendingKingSquare)
        var result = 10.0 * cornerScore + 50.0 * edgeScore + kdScore
        if attackingKingSquare.file == 0 || attackingKingSquare.file == 7 || attackingKingSquare.rank == 0 || attackingKingSquare.rank == 7 {
            result -= 10.0
        }
        
        result += wonEndgameOffset
        return playerToMove == attacker ? result : -result
    }
}
