//
//  File.swift
//
//
//  Created by Tony on 25/04/2024.
//

import Foundation

let majorPieceAndKingVsKingEvaluator = MajorPieceAndKingVsKingEvaluator()
let defaultEvaluator = DefaultEvaluator()

struct Progress {
    var currentMove: Move?
    var numberOfPositionsAnalysed: Int
    var depth: Int
    
    init() {
        currentMove = nil
        numberOfPositionsAnalysed = 0
        depth = 1
    }
}

let progressInterval = 100

protocol MoveSelectionObserver {
    func reportProgress(_ progress: Progress)
    func moveSelected(move: Move, score: Double)
    func selectionAborted()
}

class Aba {
    private let maxPlySupported = 6
    private let lock = NSLock()
    private var stopFlag = false
    
    private var quietPositionMaxPly = 6
    private var ply = 0
    private var bestScore: [Double]! = nil
    private var killer: [Move?]! = nil
    private var progress: Progress = Progress()
    private var bestMove: Move?
    
    struct SelectionAborted : Error { }
    
    init() {
    }
    
    func startMoveSelection(gameState: GameState, observer: MoveSelectionObserver) {
        stopFlag = false
        progress = Progress()
        let queue = DispatchQueue.global()
        
        queue.async {
            self.selectMove(gameState: gameState, observer: observer)
        }
    }
    
    func stopMoveSelection() {
        lock.lock(before: Date.distantFuture)
        stopFlag = true
        lock.unlock()
    }
    
    private func selectMove(gameState: GameState, observer: MoveSelectionObserver) {
        bestScore = [Double](repeating: 0, count: maxPlySupported)
        killer = [Move?](repeating: nil, count: maxPlySupported)
        ply = 0
        do {
            let score = try analyse(gameState: gameState, observer: observer)
            observer.moveSelected(move: bestMove!, score: score)
        } catch {
            observer.selectionAborted()
        }
        
        print("Position count = \(progress.numberOfPositionsAnalysed)")
    }
    
    private func select(gameState: GameState, candidates: MoveList, maxPly: Int, observer: MoveSelectionObserver) {
        
    }
    
    private func analyse(gameState: GameState, observer: MoveSelectionObserver) throws -> Double {
        progress.numberOfPositionsAnalysed += 1
        if progress.numberOfPositionsAnalysed % progressInterval == 0 {
            observer.reportProgress(progress)
            lock.lock(before: Date.distantFuture)
            let stopNow = stopFlag;
            lock.unlock()
            if stopNow {
                throw SelectionAborted()
            }
        }
        
        let analysisInfo = AnalysisInfo(gameState: gameState)
        if let terminalScore = checkTerminal(analysisInfo) {
            return terminalScore
        }
        
        let movesToTry = getMovesToTry(analysisInfo)
        bestScore[ply] = -Double.greatestFiniteMagnitude
        for i in 0..<movesToTry.count {
            let move = movesToTry[i]
            
            gameState.makeMove(move)
            if ply == 0 {
                progress.currentMove = move
            }
            
            ply += 1
            let score = try -analyse(gameState: gameState, observer: observer)
            ply -= 1
            gameState.retractLastMove()
            
            if score > bestScore[ply] {
                bestScore[ply] = score
                if ply == 0 {
                    bestMove = move
                } else {
                    if score > -bestScore[ply - 1] {
                        killer[ply] = move
                        return score
                    }
                }
            }
        }
        
        return bestScore[ply]
    }
    
    private func getMovesToTry(_ analysisInfo: AnalysisInfo) -> MoveList {
        var result = MoveList()
        let position = analysisInfo.position
        for m in analysisInfo.activePlayerMoves {
            var score = 0.0
            if m == killer[ply] {
                score = 1000.0
            } else if m.isCapture(position) {
                switch m {
                case .normal(_, let to, _):
                    let capturedPiece = position.board[to].type
                    score = pieceValue(pieceType: capturedPiece)
                default:
                    break
                }
            } else if m.isCastles {
                score = 0.5
            }
            
            result.add(move: m, score: score)
        }
        
        result.sort()
        return result
    }
    
    private func checkTerminal(_ analysisInfo: AnalysisInfo) -> Double? {
        let gameState = analysisInfo.gameState
        if gameState.getRepetitionCount() == 2 {
            return drawEvaluation
        }
        
        if gameState.halfMoveClock == 100 {
            return drawEvaluation
        }
        
        if analysisInfo.totalPieces == 2 { // Just kings left!
            return drawEvaluation
        }
        
        let position = analysisInfo.position
        if analysisInfo.activePlayerMoves.isEmpty {
            if position.isInCheck(player: position.playerToMove) {
                return lossEvaluation + Double(ply)
            } else {
                return drawEvaluation
            }
        }
        
        if ply == maxPlySupported {
            return evaluate(analysisInfo)
        }
        
        if ply >= quietPositionMaxPly && Aba.isQuietPosition(analysisInfo) {
            return evaluate(analysisInfo)
        }
        
        return nil
    }
    
    private static func isQuietPosition(_ analysisInfo: AnalysisInfo) -> Bool {
        let player = analysisInfo.playerToMove
        let position = analysisInfo.position
        if analysisInfo.position.isInCheck(player: player) {
            return false
        }
        
        for m in analysisInfo.activePlayerMoves {
            if m.isCapture(position) {
                return false
            }
        }
        
        return true
    }
    
    private func evaluate(_ analysisInfo: AnalysisInfo) -> Double {
        let evaluationFunc = selectEvaluationFunc(analysisInfo)
        let result = evaluationFunc(analysisInfo)
        return result
    }
    
    private func selectEvaluationFunc(_ analysisInfo: AnalysisInfo) -> EvaluationFunc {
        if majorPieceAndKingVsKingEvaluator.isApplicable(analysisInfo) {
            return majorPieceAndKingVsKingEvaluator.evaluate
        }
        
        return defaultEvaluator.evaluate
    }
}
