//
//  GameStateTests.swift
//  
//
//  Created by Tony on 06/02/2024.
//

import XCTest
@testable import ChessBE

final class GameStateTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeMove() throws {
        var position = Position()
        let gameState = GameState(initialPosition: position, initialHalfMoveClock: 0, initialFullMove: 1)
        position = gameState.makeMove(.normal(from: g1, to: f3, promoteTo: nil))
        XCTAssertEqual(Player.black, position.playerToMove)
        XCTAssert(position == gameState.currentPosition)
    }
    
    func testRetractLastMove() throws {
        var position = Position()
        let gameState = GameState(initialPosition: position, initialHalfMoveClock: 0, initialFullMove: 1)
        gameState.makeMove(.normal(from: g1, to: f3, promoteTo: nil))
        position = gameState.retractLastMove()!
        XCTAssert(position == Position())
        XCTAssertNil(gameState.retractLastMove())
    }
    
    func testGetRepetitionCount() throws {
        let initialPosition = Position()
        let gameState = GameState(initialPosition: initialPosition, initialHalfMoveClock: 0, initialFullMove: 1)
        gameState.makeMove(.normal(from: g1, to: f3, promoteTo: nil))
        gameState.makeMove(.normal(from: g8, to: f6, promoteTo: nil))
        gameState.makeMove(.normal(from: f3, to: g1, promoteTo: nil))
        gameState.makeMove(.normal(from: f6, to: g8, promoteTo: nil))
        let repetitionCount = gameState.getRepetitionCount()
        XCTAssertEqual(2, repetitionCount)
    }
}
