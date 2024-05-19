//
//  File.swift
//  
//
//  Created by Tony on 24/01/2024.
//

import Foundation

public enum Move : Equatable {
    case whiteCastlesLong
    case whiteCastlesShort
    case blackCastlesLong
    case blackCastlesShort
    case normal(from: Int, to: Int, promoteTo: Piece?)
}

extension Move {
    var isCastles: Bool {
        get {
            switch self {
            case .normal:
                return false
            default:
                return true
            }
        }
    }
    
    var from: Int {
        get {
            switch self {
            case .whiteCastlesLong, .whiteCastlesShort:
                return e1
            case .blackCastlesLong, .blackCastlesShort:
                return e8
            case .normal(let f, _, _):
                return f
            }
        }
    }
    
    var to: Int {
        get {
            switch self {
            case .whiteCastlesLong:
                return c1
            case .whiteCastlesShort:
                return g1
            case .blackCastlesLong:
                return c8
            case .blackCastlesShort:
                return g8
            case .normal(_, let t, _):
                return t
            }
        }
    }
    
    func isCapture(_ position: Position) -> Bool {
        switch self {
        case .normal(_, let to, _):
            return position[to] != .none || isEpCapture(position)
        default:
            return false
        }
    }
    
    func isEpCapture(_ position: Position) -> Bool {
        switch self {
        case .normal(let from, let to, _):
            return to == position.epSquare && position.board[from].type == .pawn
        default:
            return false
        }
    }
    
    func isPawnMove(_ position: Position) -> Bool {
        switch self {
        case .normal(let from, _, _):
            return position[from].type == .pawn
        default:
            return false
        }
    }
    
    func score(position: Position) -> Double {
        switch self {
        case .whiteCastlesLong, .blackCastlesLong:
            return 0.4
        case .whiteCastlesShort, .blackCastlesShort:
            return 0.5
        case .normal(_, _, let promoteTo):
            if promoteTo != nil {
                return 2.0
            } else if isCapture(position) {
                return 1.0
            } else {
                return 0.0
            }
        }
    }
}

/*
struct Move {
    let from: Int
    let to: Int
    let from1: Int?
    let to1: Int?
    let isCapture: Bool
    let isPawnMove: Bool
    let isPromotion: Bool
    let piece: Piece

    var isEpCapture: Bool {
        return isCapture && to1 != nil
    }
    
    var isCastles: Bool {
        return from1 != nil && to1 != nil
    }
    
    init(castles: Int8) {
        switch castles {
        case whiteKingside:
            from = e1
            to = g1
            from1 = h1
            to1 = f1
            piece = Piece(.white, .king)
        case whiteQueenside:
            from = e1
            to = c1
            from1 = a1
            to1 = d1
            piece = Piece(.white, .king)
        case blackKingside:
            from = e8
            to = g8
            from1 = h8
            to1 = f8
            piece = Piece(.black, .king)
        case blackQueenside:
            from = e8
            to = c8
            from1 = a8
            to1 = d8
            piece = Piece(.black, .king)
        default:
            assertionFailure("Invalid castling flag \(castles)")
            from = -1
            to = -1
            from1 = -1
            to1 = -1
            piece = Piece.none
        }
        	
        isCapture = false
        isPawnMove = false
        isPromotion = false
    }
    
    init(from: Int, to: Int, piece: Piece, isCapture: Bool = false, isPromotion: Bool = false) {
        self.from = from
        self.to = to
        from1 = nil
        to1 = nil
        self.isCapture = isCapture
        self.isPromotion = isPromotion
        isPawnMove = piece.type == .pawn || isPromotion
        self.piece = piece
    }
    
    init(from: Int, epSquare: Int) {
        self.from = from
        to = epSquare
        from1 = nil
        let fromFile = from % 8
        let toFile = to % 8
        to1 = from + toFile - fromFile
        isCapture = true
        isPawnMove = true
        isPromotion = false
        self.piece = (epSquare / 8) == 2 ? Piece(.black, .pawn) : Piece(.white, .pawn)
    }
}
*/
