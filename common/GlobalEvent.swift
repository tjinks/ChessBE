//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation


public enum GlobalEvent {
    case shutdownRequested
    case shutdownInProgress
    case setGameState(fen: String)
    case startGame
    case setRunMode(runMode: RunMode)
    case showGameState(state: GameStateDto)
    case showHighlights(highlights: [Int])
    case gameOver(result: Result)
    case showError(message: String)
    case confirm(message: String, callback: (Bool) -> ())
    case showPromotionDialog
    case promoteTo(piece: PieceType)
    case squareClicked(square: Int)
}

public func isShutdownInProgress(_ event: Any) -> Bool {
    if let event = event as? GlobalEvent {
        switch event {
        case .shutdownInProgress:
            return true
        default:
            break
        }
    }
    
    return false
}
