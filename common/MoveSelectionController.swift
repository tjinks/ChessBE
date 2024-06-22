//
//  File.swift
//
//
//  Created by Tony on 04/04/2024.
//

import Foundation

class MoveSelectionController {
    private enum State {
        case inactive
        case beforeInitialSquareSelected, afterInitialSquareSelected
        case waitingForPromotionDialog
    }
    
    private var game: Game? = nil
    
    private var state = State.inactive
    private var initialSquare: Int? = nil
    private var promotionSquare: Int? = nil
    
    private let dispatcher: EventDispatcher
    
    init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        dispatcher.register(processEvent)
    }
    
    private func processEvent(_ event: Any) {
        if let event = event as? GlobalEvent {
            switch event {
            case .squareClicked(let square):
                processClick(square: square)
            case .promoteTo(let pieceType):
                processPromotion(promoteTo: pieceType)
            default:
                break
            }
        } else if let event = event as? InternalEvent {
            if state == .inactive {
                switch event {
                case .startHumanMoveSelection(let game):
                    self.game = game
                    state = .beforeInitialSquareSelected
                default:
                    break
                }
            }
        }
    }
    
    private func processClick(square: Int) {
        switch state {
        case .beforeInitialSquareSelected:
            let highlights = game!.getTargets(from: square)
            if highlights.count > 0 {
                initialSquare = square
                state = .afterInitialSquareSelected
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: highlights))
            } else {
                initialSquare = nil
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: []))
            }
            
        case .afterInitialSquareSelected:
            let moves = getMovesEndingAt(square)
            if moves.size > 0 {
                let move = moves[0]
                initialSquare = move.primaryPieceMove.from
                if let promoteTo = move.promoteTo {
                    promotionSquare = square
                    state = .waitingForPromotionDialog
                    dispatcher.dispatch(GlobalEvent.showPromotionDialog)
                    return
                } else {
                    dispatchMove(move)
                }
            } else {
                state = .beforeInitialSquareSelected
                processClick(square: square)
            }
            
        default:
            break
        }
    }
    
    private func processPromotion(promoteTo: EngPieceType) {
        switch state {
        case .waitingForPromotionDialog:
            let promotionMove = getPromotionMove(matching: promoteTo)
            dispatchMove(promotionMove)
        default:
            break
        }
    }
    
    private func dispatchMove(_ move: Move) {
        state = .inactive
        dispatcher.dispatch(InternalEvent.moveSelected(move: move))
    }
    
    private func getPromotionMove(matching: EngPieceType) -> Move {
        let playerToMove = game!.position.playerToMove
        let piece = engMakePiece(playerToMove, matching)
        let promotionMoves = game!.getMoves(from: initialSquare!, to: promotionSquare!)
        for i in 0..<promotionMoves.size {
            let promotionPieceType = promotionMoves[i].promoteTo!.type
            if promotionPieceType == matching {
                return promotionMoves[i]
            }
        }
        
        return promotionMoves[0]
    }
    
    private func getMovesEndingAt(_ square: Int) -> MoveList {
        return game!.getMoves(from: initialSquare!, to: square)
    }
}
