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
    
    private var gameState: GameState?
    private var potentialMoves: [Move]?
    
    private var state = State.inactive
    private var initialSquare: Int = -1
    
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
                processPromotion(to: pieceType)
            default:
                break
            }
        } else if let event = event as? InternalEvent {
            if state == .inactive {
                switch event {
                case .startHumanMoveSelection(let gameState):
                    self.gameState = gameState
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
            let potentialMoves = getMovesStartingFrom(square)
            if potentialMoves.count > 0 {
                var highlights = potentialMoves.map { return $0.to }
                highlights.append(square)
                self.potentialMoves = potentialMoves
                state = .afterInitialSquareSelected
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: highlights))
            } else {
                dispatcher.dispatch(GlobalEvent.showHighlights(highlights: []))
            }

        case .afterInitialSquareSelected:
            let moves = getMovesEndingAt(square)
            if moves.count > 0 {
                let move = moves[0]
                switch move {
                case .normal(_, _, let promoteTo):
                    if promoteTo != nil {
                        potentialMoves = moves
                        state = .waitingForPromotionDialog
                        dispatcher.dispatch(GlobalEvent.showPromotionDialog)
                        return
                    }
                default:
                    break
                }

                dispatchMove(move)
            } else {
                state = .beforeInitialSquareSelected
                processClick(square: square)
            }

        default:
            break
        }
    }
    
    private func processPromotion(to: PieceType) {
        switch state {
        case .waitingForPromotionDialog:
            let promotionMove = getPromotionMove(matching: to)
            dispatchMove(promotionMove)
        default:
            break
        }
    }
    
    private func dispatchMove(_ move: Move) {
        state = .inactive
        dispatcher.dispatch(InternalEvent.moveSelected(move: move))
    }
    
    private func getPromotionMove(matching: PieceType) -> Move {
        let playerToMove = gameState!.currentPosition.playerToMove
        let piece = Piece(playerToMove, matching)
        let matching = potentialMoves!.filter {
            switch $0 {
            case .normal(_, _, let promoteTo):
                return piece == promoteTo
            default:
                return false
            }
        }

        return matching[0]
    }
    
    private func getMovesStartingFrom(_ square: Int) -> [Move] {
        let position = gameState!.currentPosition
        let moves = MoveGenerator.run(position: position, player: position.playerToMove)
        return moves.filter {
            return $0.from == square
        }
    }
    
    private func getMovesEndingAt(_ square: Int) -> [Move] {
        return potentialMoves!.filter {
            return $0.to == square
        }
    }
}
