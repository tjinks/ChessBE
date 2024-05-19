//
//  NotationTests.swift
//  
//
//  Created by Tony on 18/01/2024.
//

import XCTest
@testable import ChessBE

final class NotationTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParseFenInitialPosition() throws {
        let result =
        try Notation.parseFen(fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1")
        for sqnum in 0...63 {
            let piece = result.board[sqnum]
            switch (sqnum) {
            case 0, 7:
                XCTAssertEqual(.whiteRook, piece)
            case 1, 6:
                XCTAssertEqual(.whiteKnight, piece)
            case 2, 5:
                XCTAssertEqual(.whiteBishop, piece)
            case 3:
                XCTAssertEqual(.whiteQueen, piece)
            case 4:
                XCTAssertEqual(.whiteKing, piece)
            case 8...15:
                XCTAssertEqual(.whitePawn, piece)
            case 16...47:
                XCTAssertEqual(.none, piece)
            case 48...55:
                XCTAssertEqual(.blackPawn, piece)
            case 56, 63:
                XCTAssertEqual(.blackRook, piece)
            case 57, 62:
                XCTAssertEqual(.blackKnight, piece)
            case 58, 61:
                XCTAssertEqual(.blackBishop, piece)
            case 59:
                XCTAssertEqual(.blackQueen, piece)
            case 60:
                XCTAssertEqual(.blackKing, piece)
            default:
                break
            }
        }
        
        XCTAssertEqual(.white, result.playerToMove)
        XCTAssertTrue(result.blackCanCastleShort)
        XCTAssertTrue(result.blackCanCastleLong)
        XCTAssertTrue(result.whiteCanCastleShort)
        XCTAssertTrue(result.whiteCanCastleLong)
        XCTAssertNil(result.epSquare)
        XCTAssertEqual(0, result.halfMoveClock)
        XCTAssertEqual(1, result.fullMove)
    }
    
    func testParseFenWithEp() throws {
        let result = try Notation.parseFen(fen: "7k/8/8/8/4P3/K7/8/8 b - e3 0 53")
        for sqnum in 0...63 {
            let piece = result.board[sqnum]
            switch (sqnum) {
            case 16:
                XCTAssertEqual(.whiteKing, piece)
            case 28:
                XCTAssertEqual(.whitePawn, piece)
            case 63:
                XCTAssertEqual(.blackKing, piece)
            default:
                XCTAssertEqual(Piece.none, piece)
            }
            XCTAssertEqual(.black, result.playerToMove)
            XCTAssertFalse(result.whiteCanCastleLong)
            XCTAssertFalse(result.whiteCanCastleShort)
            XCTAssertFalse(result.blackCanCastleLong)
            XCTAssertFalse(result.blackCanCastleShort)
            XCTAssertEqual(e3, result.epSquare)
            XCTAssertEqual(0, result.halfMoveClock)
            XCTAssertEqual(53, result.fullMove)
        }
    }
}
