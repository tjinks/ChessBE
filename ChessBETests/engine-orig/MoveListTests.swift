//
//  MoveListTests.swift
//  
//
//  Created by Tony Jinks on 12/02/2024.
//

import XCTest
@testable import ChessBE

final class MoveListTests: XCTestCase {
    func testGetMoves() throws {
        var moveList = MoveList()
        moveList.add(move: .normal(from: a3, to: e3, promoteTo: nil), score: 1.0)
        moveList.add(move: .normal(from: a3, to: b2, promoteTo: nil), score: 2.0)
        XCTAssertEqual(2, moveList.count)
        switch moveList[0] {
        case .normal(_, let to, _):
            XCTAssertEqual(e3, to)
        default:
            XCTFail()
        }

        switch moveList[1] {
        case .normal(_, let to, _):
            XCTAssertEqual(b2, to)
        default:
            XCTFail()
        }
    }
}
