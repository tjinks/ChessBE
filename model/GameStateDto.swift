//
//  File.swift
//
//
//  Created by Tony on 19/03/2024.
//

import Foundation

public struct GameStateDto {
    public init() {
        self = try! Notation.parseFen(fen: Notation.initialPosition)
    }
    
    public init(
        board: [Piece],
        playerToMove: Player,
        whiteCanCastleShort: Bool,
        whiteCanCastleLong: Bool,
        blackCanCastleShort: Bool,
        blackCanCastleLong: Bool,
        epSquare: Int?,
        halfMoveClock: Int,
        fullMove: Int
    ) {
        self.board = board
        self.playerToMove = playerToMove
        self.whiteCanCastleLong = whiteCanCastleLong
        self.whiteCanCastleShort = whiteCanCastleShort
        self.blackCanCastleLong = blackCanCastleLong
        self.blackCanCastleShort = blackCanCastleShort
        self.epSquare = epSquare
        self.halfMoveClock = halfMoveClock
        self.fullMove = fullMove
    }
    
    
    
    public var board: [Piece]
    
    public var playerToMove: Player
    
    public var whiteCanCastleShort: Bool
    
    public var whiteCanCastleLong: Bool
    
    public var blackCanCastleShort: Bool
    
    public var blackCanCastleLong: Bool
    
    public var epSquare: Int?
    
    public var halfMoveClock: Int
    
    public var fullMove: Int
}
