//
//  File.swift
//
//
//  Created by Tony on 24/01/2024.
//

import Foundation

let whiteKingside: Int8 = 1
let whiteQueenside: Int8 = 2
let blackKingside: Int8 = 4
let blackQueenside: Int8 = 8

let a1 = 0
let b1 = 1
let c1 = 2
let d1 = 3
let e1 = 4
let f1 = 5
let g1 = 6
let h1 = 7

let a2 = 8
let b2 = 9
let c2 = 10
let d2 = 11
let e2 = 12
let f2 = 13
let g2 = 14
let h2 = 15

let a3 = 16
let b3 = 17
let c3 = 18
let d3 = 19
let e3 = 20
let f3 = 21
let g3 = 22
let h3 = 23

let a4 = 24
let b4 = 25
let c4 = 26
let d4 = 27
let e4 = 28
let f4 = 29
let g4 = 30
let h4 = 31

let a5 = 32
let b5 = 33
let c5 = 34
let d5 = 35
let e5 = 36
let f5 = 37
let g5 = 38
let h5 = 39

let a6 = 40
let b6 = 41
let c6 = 42
let d6 = 43
let e6 = 44
let f6 = 45
let g6 = 46
let h6 = 47

let a7 = 48
let b7 = 49
let c7 = 50
let d7 = 51
let e7 = 52
let f7 = 53
let g7 = 54
let h7 = 55

let a8 = 56
let b8 = 57
let c8 = 58
let d8 = 59
let e8 = 60
let f8 = 61
let g8 = 62
let h8 = 63

struct Position: Equatable, Hashable {
    
    let board: [Piece]
    let playerToMove: Player
    let castlingRights: Int8
    let epSquare: Int?
    let kingSquare: [Int]
    
    private init(board: [Piece], playerToMove: Player, castlingRights: Int8, epSquare: Int?, kingSquare: [Int]) {
        self.board = board
        self.playerToMove = playerToMove
        self.castlingRights = castlingRights
        self.epSquare = epSquare
        self.kingSquare = kingSquare
    }
    
    init() {
        let dto = try! Notation.parseFen(fen: Notation.initialPosition)
        try! self.init(dto: dto)
    }
    
    init(fen: String) throws {
        let dto = try! Notation.parseFen(fen: fen)
        try! self.init(dto: dto)
    }
    
    init(dto: GameStateDto) throws {
        self.board = dto.board
        
        var kingSquare: [Int?] = [nil, nil]
        try forAllSquares {
            let piece = dto.board[$0]
            if piece.type == .king {
                let index = piece.owner!.index
                if kingSquare[index] != nil {
                    throw ChessError.duplicateKing
                }
                
                kingSquare[index] = $0
            }
            
            return true
        }
        
        if (kingSquare[0] == nil || kingSquare[1] == nil) {
            throw ChessError.missingKing
        }
        
        self.kingSquare = [kingSquare[0]!, kingSquare[1]!]
        
        playerToMove = dto.playerToMove
        
        var castlingRights: Int8 = 0
        if dto.whiteCanCastleShort {
            castlingRights |= whiteKingside
        }
        
        if dto.whiteCanCastleLong {
            castlingRights |= whiteQueenside
        }
        
        if dto.blackCanCastleShort {
            castlingRights |= blackKingside
        }
        
        if dto.blackCanCastleLong {
            castlingRights |= blackQueenside
        }
        
        self.castlingRights = castlingRights
        
        if let eps = dto.epSquare {
            epSquare = eps
        } else {
            epSquare = nil
        }
    }
    
    subscript(square: Int) -> Piece {
        return board[square]
    }
    
    func makeMove(_ move: Move) -> Position {
        var board = self.board
        var kingSquare = self.kingSquare
        var epSquare: Int? = nil
        
        switch move {
        case .whiteCastlesLong:
                board[a1] = .none
                board[c1] = .whiteKing
                board[d1] = .whiteRook
                board[e1] = .none
                kingSquare[playerToMove.index] = c1
        case .blackCastlesLong:
                board[a8] = .none
                board[c8] = .blackKing
                board[d8] = .blackRook
                board[e8] = .none
                kingSquare[playerToMove.index] = c8
        case .whiteCastlesShort:
                board[h1] = .none
                board[g1] = .whiteKing
                board[f1] = .whiteRook
                board[e1] = .none
                kingSquare[playerToMove.index] = g1
        case .blackCastlesShort:
                board[h8] = .none
                board[g8] = .blackKing
                board[f8] = .blackRook
                board[e8] = .none
                kingSquare[playerToMove.index] = g8
        case .normal(let from, let to, let promoteTo):
            if let promoteTo = promoteTo {
                board[to] = promoteTo
            } else {
                board[to] = board[from]
            }
            
            board[from] = .none
            if move.isEpCapture(self) {
                let inc = playerToMove == .white ? -8 : 8
                board[self.epSquare! + inc] = .none
            }
            
            switch board[to] {
            case .whiteKing, .blackKing:
                kingSquare[playerToMove.index] = to
            case .whitePawn:
                if to - from == 16 {
                    epSquare = to - 8
                }
            case .blackPawn:
                if from - to == 16 {
                    epSquare = to + 8
                }
            default:
                break;
            }
        }
        
        var castlingRights = self.castlingRights
        if castlingRights != 0 {
            var rightsToRemove: Int8 = 0
            switch move {
            case .whiteCastlesLong, .whiteCastlesShort:
                    rightsToRemove = whiteKingside | whiteQueenside
            case .blackCastlesLong, .blackCastlesShort:
                    rightsToRemove = blackKingside | blackQueenside
            case .normal(let from, let to, _):
                if from == e1 {
                    rightsToRemove = whiteKingside | whiteQueenside
                } else if from == e8 {
                    rightsToRemove = blackKingside | blackQueenside
                }
                if from == a1 || to == a1 {
                    rightsToRemove |= whiteQueenside
                }
                if from == h1 || to == h1 {
                    rightsToRemove |= whiteKingside
                }
                if from == a8 || to == a8 {
                    rightsToRemove |= blackQueenside
                }
                if from == h8 || to == h8 {
                    rightsToRemove |= blackKingside
                }
            }
            
            castlingRights &= ~rightsToRemove
        }
        
        return Position(
            board: board,
            playerToMove: playerToMove.other,
            castlingRights: castlingRights,
            epSquare: epSquare,
            kingSquare: kingSquare)
    }
}
