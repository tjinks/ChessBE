//
//  File.swift
//
//
//  Created by Tony on 14/01/2024.
//

import Foundation

public class Notation {
    public static let initialPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    private static let fileChars:[Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
    private static let rankChars:[Character] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    public static func getSquareName(_ square: Int) -> String {
        let fileChar = fileChars[square.file]
        let rankChar = rankChars[square.rank]
        return String(fileChar) + String(rankChar)
    }
    
    public static func parseSquareName(name: String) throws -> Int {
        if name.count != 2 {
            throw ChessError.invalidSquare
        }
        
        let fileChar = name[name.startIndex]
        let rankChar = name[name.index(after: name.startIndex)]
        if let file = fileChars.firstIndex(of: fileChar) {
            if let rank = rankChars.firstIndex(of: rankChar) {
                return squareNum(file: file, rank: rank)
            }
        }
        
        throw ChessError.invalidSquare
    }
    
    public static func parseFen(fen: String) throws -> GameStateDto {
        let boardIndex = 0
        let playerIndex = 1
        let castlingRightsIndex = 2
        let epSquareIndex = 3
        let halfMoveClockIndex = 4
        let fullMoveIndex = 5
        
        var rank: Int = 7
        var file: Int = 0
        var pieces:Dictionary<Int, Piece> = [:]
        var playerToMove = Player.white
        var whiteCanCastleShort = false
        var whiteCanCastleLong = false
        var blackCanCastleShort = false
        var blackCanCastleLong = false
        var epSquare: Int? = nil
        var halfMoveClock = 100
        var fullMove = 0
        
        let parts = split()
        if parts.count < playerIndex + 1 {
            throw ChessError.invalidFen
        }
        
        try parseBoard(parts[boardIndex])
        try parsePlayer(parts[playerIndex])
        if parts.count >= castlingRightsIndex + 1 {
            try parseCastlingRights(parts[2])
        }
        
        if parts.count >= epSquareIndex + 1 {
            try parseEpSquare(parts[epSquareIndex])
        }
        
        if parts.count >= halfMoveClockIndex + 1 {
            try parseHalfMoveClock(parts[halfMoveClockIndex])
        }
        
        if parts.count >= fullMoveIndex + 1 {
            try parseFullMove(parts[fullMoveIndex])
        }
        
        var board = [Piece](repeating: Piece.none, count: 64)
        try! forAllSquares() {
            if let piece = pieces[$0] {
                board[$0] = piece
            }
            return true
        }
        
        return GameStateDto(board: board,
                            playerToMove: playerToMove,
                            whiteCanCastleShort: whiteCanCastleShort,
                            whiteCanCastleLong: whiteCanCastleLong,
                            blackCanCastleShort: blackCanCastleShort,
                            blackCanCastleLong: blackCanCastleLong,
                            epSquare: epSquare,
                            halfMoveClock: halfMoveClock,
                            fullMove: fullMove)
        
        func split() -> [String] {
            var result: [String] = []
            for part in fen.components(separatedBy: .whitespaces) {
                if part.count > 0 {
                    result.append(part)
                }
            }
            
            return result
        }
        
        func parseBoard(_ s: String) throws {
            for c in s {
                if try addPiece(c) {
                    continue;
                }
                
                if updateCurrentSquare(c) {
                    continue;
                }
                
                throw ChessError.invalidFen
            }
        }
        
        func parsePlayer(_ s: String) throws {
            switch (s) {
            case "w":
                playerToMove = .white
                return
            case "b":
                playerToMove = .black
                return
            default:
                throw ChessError.invalidFen
            }
        }
        
        func parseCastlingRights(_ s: String) throws {
            if s == "-" {
                return
            }
            
            for c in s {
                switch (c) {
                case "K": whiteCanCastleShort = true
                case "k": blackCanCastleShort = true
                case "Q": whiteCanCastleLong = true
                case "q": blackCanCastleLong = true
                default: throw ChessError.invalidFen
                }
            }
        }
        
        func parseEpSquare(_ s: String) throws {
            if s == "-" {
                return
            }
            
            do {
                epSquare = try squareNum(name: s)
            } catch ChessError.invalidSquare {
                throw ChessError.invalidFen
            }
        }
        
        func parseHalfMoveClock(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            halfMoveClock = result
        }
        
        func parseFullMove(_ s: String) throws {
            guard let result = Int(s) else {
                throw ChessError.invalidFen
            }
            
            fullMove = result
        }
        
        func addPiece(_ c: Character) throws -> Bool {
            guard let piece = charToPiece(c) else {
                return false
            }
            
            let square = squareNum(file: file, rank: rank)
            if square.isValidSquareNum {
                pieces[square] = piece
                file += 1
                return true
            } else {
                throw ChessError.invalidFen
            }
        }
        
        func updateCurrentSquare(_ c: Character) -> Bool {
            if !c.isASCII {
                return false
            }
            
            if c == "/" {
                file = 0
                rank -= 1
                return rank >= 0
            }
            
            let fileIncr = (Int)(c.asciiValue!) - (Int)(Character("0").asciiValue!)
            if (fileIncr < 1) {
                return false
            }
            
            file += fileIncr
            return file <= 8
        }
    }
    
    private static func charToPiece(_ c: Character) -> Piece? {
        switch (c) {
        case "K": return .whiteKing
        case "k": return .blackKing
        case "Q": return .whiteQueen
        case "q": return .blackQueen
        case "R": return .whiteRook
        case "r": return .blackRook
        case "B": return .whiteBishop
        case "b": return .blackBishop
        case "N": return .whiteKnight
        case "n": return .blackKnight
        case "P": return .whitePawn
        case "p": return .blackPawn
        default: return nil
        }
    }
}

