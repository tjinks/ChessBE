//
//  Engine.swift
//  ChessBE
//
//  Created by Tony on 18/06/2024.
//

import Foundation

typealias EngPositionPtr = UnsafeMutablePointer<EngPosition>
typealias EngMovePtr = UnsafeMutablePointer<EngMove>
typealias EngMoveListPtr = UnsafeMutablePointer<EngMoveList>
typealias EngGamePtr = UnsafeMutablePointer<EngGame>

class Position {
    fileprivate let engPosition: EngPositionPtr

    init() {
        engPosition = engCreatePosition()
    }
    
    fileprivate init(engPosition: EngPositionPtr) {
        self.engPosition = engPosition
    }
    
    static func parseFen(fen: String, errorMessage: inout String) -> Position? {
        errorMessage = ""
        let result = engParseFen(fen)
        if result.success {
            return Position(engPosition: result.position)
        } else {
            errorMessage = String(cString: result.errorMessage)
            engFreeString(result.errorMessage)
            return nil
        }
    }
    
    deinit {
        engFreePosition(engPosition)
    }
}

class Game {
    private let game: EngGamePtr
    
    init(position: Position) {
        game = engStartGame(position.engPosition)
    }
    
    var position: Position {
        get {
            let engPosition = engGetCurrentPosition(game)
            return Position(engPosition: engPosition!)
        }
    }
    
    deinit {
        engFreeGame(game)
    }
    
}
