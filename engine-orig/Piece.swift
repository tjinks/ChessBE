//
//  File.swift
//  
//
//  Created by Tony on 01/02/2024.
//

import Foundation

extension Player {
    var other: Player {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
    
    var index: Int {
        return Int(self.rawValue)
    }
}

public enum PieceType: Int8 {
    case none = 0
    case king = 1
    case queen = 2
    case rook = 3
    case bishop = 4
    case knight = 5
    case pawn = 6
}

public enum Piece: Int8 {
    case none = 0
    case whiteKing = 1, blackKing = -1
    case whiteQueen = 2, blackQueen = -2
    case whiteRook = 3, blackRook = -3
    case whiteBishop = 4, blackBishop = -4
    case whiteKnight = 5, blackKnight = -5
    case whitePawn = 6, blackPawn = -6
}

public extension Piece {
    init(_ player: Player, _ type: PieceType) {
        self.init(rawValue: type.rawValue * (player == .black ? -1 : 1))!
    }
    
    var owner: Player? {
        get {
            switch self.rawValue.signum() {
            case -1: return .black
            case 1: return .white
            default: return nil
            }
        }
    }
    
    var type: PieceType {
        get {
            return PieceType(rawValue: abs(self.rawValue))!
        }
    }
}

extension PieceType {
    func movesOrthogonally() -> Bool {
        return self == .rook || self == .queen
    }
    
    func movesDiagonally() -> Bool {
        return self == .bishop || self == .queen
    }
}


