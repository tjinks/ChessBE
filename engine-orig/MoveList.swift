//
//  File.swift
//  
//
//  Created by Tony Jinks on 11/02/2024.
//

import Foundation

struct MoveListItem {
    let move: Move
    var score: Double
}

struct MoveList {
    private var items: [MoveListItem]
    
    init() {
        items = []
    }
    
    mutating func add(move: Move, score: Double) {
        items.append(MoveListItem(move: move, score: score))
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(index: Int) -> Move {
        get {
            return items[index].move
        }
    }
    
    mutating func sort() {
        items.sort() {
            return $0.score > $1.score
        }
    }
}


