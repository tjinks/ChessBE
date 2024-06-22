//
//  File.swift
//  
//
//  Created by Tony on 29/03/2024.
//

import Foundation

public struct SetGameState {
    public let fen: String
    
    public init(fen: String) {
        self.fen = fen
    }
}

public struct SetRunMode {
    public let runMode: RunMode
    
    public init(_ runMode: RunMode) {
        self.runMode = runMode
    }
}

struct MoveSelected {
    let move: Move
}

public class GameController {
    private let dispatcher: EventDispatcher
    private var mode = RunMode.humanVsHuman
    private var game: Game? = nil
    private var state = noopEventHandler
    // private let aba = Aba()
    
    private struct ComputerObserver: MoveSelectionObserver {
        let dispatcher: EventDispatcher
        
        func reportProgress(_ progress: Progress) {
            
        }
        
        func moveSelected(move: Move, score: Double) {
            dispatcher.dispatch(InternalEvent.moveSelected(move: move))
        }
        
        func selectionAborted() {
            
        }
    }
    
    private let observer: ComputerObserver
    
    public init(dispatcher: EventDispatcher) {
        self.dispatcher = dispatcher
        observer = ComputerObserver(dispatcher: dispatcher)
        dispatcher.register(processEvent)
        _ = MoveSelectionController(dispatcher: dispatcher)
        state = notPlaying
        processEvent(GlobalEvent.setInitialGameState)
    }
    
    private func processEvent(_ event: Any) {
        state(event)
    }
    
    private func notPlaying(event: Any) {
        if let event = event as? GlobalEvent {
            switch event {
            case .setGameState(let fen):
                processSetGameState(fen)
            case .setInitialGameState:
                let position = engCreatePosition()
                game = Game(engPosition: position!)
            case .setRunMode(let runMode):
                mode = runMode
            case .startGame:
                switch mode {
                case .humanVsHuman:
                    state = playingHumanVsHuman
                    dispatcher.dispatch(InternalEvent.startHumanMoveSelection(game: game!))
                case .humanVsComputer:
                    state = playingComputerVsHumanHumanMove
                    dispatcher.dispatch(InternalEvent.startHumanMoveSelection(game: game!))
                default:
                    break
                }
                
            default:
                break
            }
        }
    }
    
    private func playingComputerVsHumanHumanMove(event: Any) {
        let game = game!
        if let event = event as? InternalEvent {
            switch event {
            case .moveSelected(let move):
                let result = onMoveSelected(move)
                if result == .none {
                    state = playingComputerVsHumanComputerMove(event:)
                    // TODO aba.startMoveSelection(gameState: gameState, observer: observer)
                } else {
                    state = notPlaying
                }
            default:
                break
            }
        }
    }

    private func playingComputerVsHumanComputerMove(event: Any) {
        let game = game!
        if let event = event as? InternalEvent {
            switch event {
            case .moveSelected(let move):
                let result = onMoveSelected(move)
                if result == .none {
                    state = playingComputerVsHumanHumanMove
                    dispatcher.dispatch(InternalEvent.startHumanMoveSelection(game: game))
                } else {
                    state = notPlaying
                }
            default:
                break
            }
        }
    }
    

    private func playingHumanVsHuman(event: Any) {
        let game = game!
        if let event = event as? InternalEvent {
            switch event {
            case .moveSelected(let move):
                let result = onMoveSelected(move)
                if result == .none {
                    dispatcher.dispatch(InternalEvent.startHumanMoveSelection(game: game))
                } else {
                    state = notPlaying
                }
            default:
                break
            }
        }
    }
    
    private func startComputerMoveSelection() {
        
    }
    
    private func onMoveSelected(_ move: Move) -> EngGameResult {
        let game = game!
        move.makeMove()
        dispatcher.dispatch(GlobalEvent.showGameState(position: game.position))
        let result = game.getResult()
        if result != NoResult {
            dispatcher.dispatch(GlobalEvent.gameOver(result: result))
            state = notPlaying
        }
        
        return result
    }
    
    private func processSetGameState(_ fen: String) {
        do {
            let parseFenResult = try Position.parseFen(fen: fen)
            game = Game(position: parseFenResult)
        } catch ChessError.invalidFen(let message) {
            dispatcher.dispatch(GlobalEvent.showError(message: message))
        } catch {
            dispatcher.dispatch(GlobalEvent.showError(message: "An unexpected error has occurred"))
        }
    }
}
