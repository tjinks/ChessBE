//
//  File.swift
//
//
//  Created by Tony on 25/04/2024.
//

import Foundation

let winEvaluation = 1e6
let lossEvaluation = -winEvaluation
let drawEvaluation = 0.0

let queenValue = 9.0
let rookValue = 5.0
let bishopValue = 3.125
let knightValue = 3.0
let pawnValue = 1.0

let wonEndgameOffset = 1000.0

typealias EvaluationFunc = (AnalysisInfo) -> Double
typealias PieceCounts = [Piece : Int]

protocol Evaluator {
    func isApplicable(_ analysisInfo: AnalysisInfo) -> Bool
    func evaluate(_ analysisInfo: AnalysisInfo) -> Double
}

func distanceBetween(from: Int, to: Int) -> Double {
    let dx = abs(from.file - to.file)
    let dy = abs(from.rank - to.rank)
    return Double(dx + dy)
}

func edgeDistance(_ square: Int) -> Double {
    var result = 7 - square.rank
    result = min(result, square.rank)
    result = min(result, 7 - square.file)
    result = min(result, square.file)
    return Double(result)
}

func evaluateMaterial(_ analysisInfo: AnalysisInfo) -> Double {
    var result = 0.0
    let pieceCounts = analysisInfo.pieceCounts
    for piece in pieceCounts.keys {
        let count = Double(pieceCounts[piece]!)
        let inc = pieceValue(pieceType: piece.type) * count
        
        if analysisInfo.position.playerToMove == piece.owner {
            result += inc
        } else {
            result -= inc
        }
    }
    
    return result
}

func pieceValue(pieceType: PieceType) -> Double {
    switch pieceType {
    case .queen:
        return queenValue
    case.rook:
        return rookValue
    case .bishop:
        return bishopValue
    case .knight:
        return knightValue
    case .pawn:
        return pawnValue
    default:
        return 0.0
    }
}


/// Calculates net piece mobility from the POV of the player to move.
/// - Parameter analysisInfo: Analysis info
/// - Returns: (Piece mobility of player to move) - (Piece mobility of opponent)
func calculateNetPieceMobility(analysisInfo: AnalysisInfo) ->  Int {
    let position = analysisInfo.position
    let pieceMoveCounter = {(moves: [Move]) -> Int in
        var count = 0
        for move in moves {
            switch move {
            case .normal(let from, _, _):
                let piece = position[from]
                    switch piece.type {
                    case .bishop, .king, .knight, .queen, .rook:
                        count += 1
                    default:
                        break
                    }
                
            default:
                count += 1
            }
        }
        
        return count
    }
    
    return pieceMoveCounter(analysisInfo.activePlayerMoves) - pieceMoveCounter(analysisInfo.passivePlayerMoves)
}
