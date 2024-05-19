//
//  File.swift
//  
//
//  Created by Tony on 16/04/2024.
//

import Foundation

enum InternalEvent {
    case moveSelected(move: Move)
    case startHumanMoveSelection(gameState: GameState)
}
