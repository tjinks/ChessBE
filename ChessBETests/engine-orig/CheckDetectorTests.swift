//
//  CheckDetectorTests.swift
//  
//
//  Created by Tony on 08/02/2024.
//

import XCTest
@testable import ChessBE

final class CheckDetectorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoCheck() throws {
        let position = try Position(fen: "8/8/3P1P2/4k3/3RB1Q1/4N3/8/4K3 w")
        XCTAssertFalse(position.isInCheck(player: Player.black))
    }
    
    func testCheckBlocked() throws {
        let position = try Position(fen: "8/2Q5/3P1P2/4k3/4B3/4R3/8/4K3 w")
        XCTAssertFalse(position.isInCheck(player: Player.black))
    }
    
    func testPawnCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/5P2/8/8/4K3 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
    
    func testKnightCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/2N5/8/8/4K3 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
    
    func testKingCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/4K3/8/8/8 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
    
    func testBishopCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/8/8/8/B3K3 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
    
    func testRookCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/8/8/4R3/4K3 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
    
    func testQueenCheck() throws {
        let position = try Position(fen: "8/8/8/4k3/8/8/4Q3/4K3 w")
        XCTAssertTrue(position.isInCheck(player: Player.black))
    }
}
