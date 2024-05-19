//
//  MateDetectorTests.swift
//
//
//  Created by Tony on 22/02/2024.
//

import XCTest
@testable import ChessBE


final class MateDetectorTests: XCTestCase {
    func testCheckmate() throws {
        let position = try Position(dto: try Notation.parseFen(fen: "5R1k/8/6K1/8/8/8/8/8 b"))
        XCTAssertEqual(MateCheckResult.checkmate, position.mateCheck())
    }
    
    func testStalemate() throws {
        let position = try Position(dto: try Notation.parseFen(fen: "6k1/6P1/6K1/8/8/8/8/8 b"))
        XCTAssertEqual(MateCheckResult.stalemate, position.mateCheck())
    }
    
    func testNone() throws {
        let position = try Position(dto: try Notation.parseFen(fen: "5k2/6P1/6K1/8/8/8/8/8 b"))
        XCTAssertEqual(MateCheckResult.none, position.mateCheck())
    }
}
