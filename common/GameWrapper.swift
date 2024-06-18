//
//  PositionWrapper.swift
//  ChessBE
//
//  Created by Tony on 18/06/2024.
//

import Foundation

class GameWrapper {
    let game: UnsafeMutablePointer<EngGame>
    
    init(position: UnsafeMutablePointer<EngPosition>) {
        game = engStartGame(position)
    }
    
    
    
    deinit {
        engFreeGame(game)
    }
}
