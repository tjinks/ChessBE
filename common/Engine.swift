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

public class Position {
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
    
    public subscript(index: Int) -> EngPiece {
        get {
            let ptr = engPosition.pointee.board! + index
            return ptr.pointee
        }
        
        set(value) {
            let ptr = engPosition.pointee.board! + index
            ptr.pointee = value
        }
    }
    
    public var playerToMove: EngPlayer {
        get { return engPosition.pointee.playerToMove }
        set(value) { engPosition.pointee.playerToMove = value }
    }
    
    public var whiteCanCastleShort: Bool {
        get { return engPosition.pointee.whiteCanCastleShort }
        set(value) { engPosition.pointee.whiteCanCastleShort = value }
    }
    
    public var whiteCanCastleLong: Bool {
        get { return engPosition.pointee.whiteCanCastleLong }
        set(value) { engPosition.pointee.whiteCanCastleLong = value }
    }
    
    public var blackCanCastleShort: Bool {
        get { return engPosition.pointee.blackCanCastleShort }
        set(value) { engPosition.pointee.blackCanCastleShort = value }
    }
    
    public var blackCanCastleLong: Bool {
        get { return engPosition.pointee.blackCanCastleLong }
        set(value) { engPosition.pointee.blackCanCastleLong = value }
    }
    
    public var epSquare: Int {
        get { return Int(engPosition.pointee.epSquare) }
        set(value) {engPosition.pointee.epSquare = EngSquare(value) }
    }

    public var halfMoveClock: Int {
        get { return Int(engPosition.pointee.halfMoveClock) }
        set(value) { engPosition.pointee.halfMoveClock = EngMoveCounter(value) }
    }
    
    public var moveNumber: Int {
        get { return Int(engPosition.pointee.moveNumber) }
        set(value) { engPosition.pointee.moveNumber = EngMoveCounter(value) }
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
    
    func getTargets(from: Int) -> [Int] {
        let resultMask = engGetTargets(game, EngSquare(from))
        var bitMask = EngSquareMask(1)
        var result = [Int]()
        for i in 0..<64 {
            if ((bitMask << i) & resultMask) != 0 {
                result.append(i)
            }
        }
        
        return result
    }
    
    func getMoves(from: Int, to: Int) -> MoveList {
        let moveList = engGetMovesByFromAndTo(game, EngSquare(from), EngSquare(to))
        return MoveList(moveList: moveList!)
    }
    
    deinit {
        engFreeGame(game)
    }
}

public class Move {
    fileprivate let move: EngMovePtr
    
    init(move: EngMovePtr) {
        self.move = move
    }
    
    public func makeMove() {
        engMakeMove(move)
    }
}

public class MoveList {
    private var moves: [Move]
    private let moveList: EngMoveListPtr
    
    fileprivate init(moveList: EngMoveListPtr) {
        moves = []
        self.moveList = moveList
        var current = moveList.pointee.firstMove
        while current != nil {
            moves.append(Move(move: current!))
            current = current!.pointee.nextMove
        }
    }
    
    public subscript(index: Int) -> Move {
        get {
            return moves[index]
        }
    }
    
    public var size: Int {
        return moves.count
    }
    
    deinit {
        engFreeMoveList(moveList)
    }
}
