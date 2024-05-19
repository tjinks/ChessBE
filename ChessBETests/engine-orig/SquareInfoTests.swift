//
//  SquareInfoTest.swift
//  
//
//  Created by Tony on 28/01/2024.
//

import XCTest
@testable import ChessBE

typealias SquareInfo = ChessBE.SquareInfo

final class SquareInfoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNorth() throws {
        let moves = getSquares(SquareInfo[0].north)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(8 * (i + 1), moves[i])
        }
    }
    
    func testSouth() throws {
        let moves = getSquares(SquareInfo[56].south)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(8 * (6 - i), moves[i])
        }
    }
    
    func testEast() throws {
        let moves = getSquares(SquareInfo[0].east)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(i + 1, moves[i])
        }
    }
    
    func testWest() throws {
        let moves = getSquares(SquareInfo[7].west)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(6 - i, moves[i])
        }
    }
    
    func testNw() throws {
        let moves = getSquares(SquareInfo[7].nw)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(56 - 7 * (6 - i), moves[i])
        }
    }
    
    func testNe() throws {
        let moves = getSquares(SquareInfo[0].ne)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(9 * (i + 1), moves[i])
        }
    }
    
    func testSw() throws {
        let moves = getSquares(SquareInfo[63].sw)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(54 - 9 * i, moves[i])
        }
    }
    
    func testSe() throws {
        let moves = getSquares(SquareInfo[56].se)
        XCTAssertEqual(7, moves.count)
        for i in 0...6 {
            XCTAssertEqual(49 - 7 * i, moves[i])
        }
    }
    
    func testSecondRankPawnMoves() throws {
        let whitePawnMoves = getSquares(SquareInfo[12].pawnMoves[Int(Player.white.rawValue)])
        XCTAssertEqual(2, whitePawnMoves.count)
        XCTAssertEqual(20, whitePawnMoves[0])
        XCTAssertEqual(28, whitePawnMoves[1])

        let blackPawnMoves = getSquares(SquareInfo[52].pawnMoves[Int(Player.black.rawValue)])
        XCTAssertEqual(2, blackPawnMoves.count)
        XCTAssertEqual(44, blackPawnMoves[0])
        XCTAssertEqual(36, blackPawnMoves[1])
    }
    
    func testOtherPawnMoves() throws {
        let whitePawnMoves = getSquares(SquareInfo[20].pawnMoves[Int(Player.white.rawValue)])
        XCTAssertEqual(1, whitePawnMoves.count)
        XCTAssertEqual(28, whitePawnMoves[0])

        let blackPawnMoves = getSquares(SquareInfo[44].pawnMoves[Int(Player.black.rawValue)])
        XCTAssertEqual(1, blackPawnMoves.count)
        XCTAssertEqual(36, blackPawnMoves[0])
    }
    
    func testPawnCaptures() throws {
        let whitePawnCaptures = getSquares(SquareInfo[17].pawnCaptures[Int(Player.white.rawValue)])
        XCTAssertEqual(2, whitePawnCaptures.count)
        XCTAssertTrue(whitePawnCaptures.contains(24))
        XCTAssertTrue(whitePawnCaptures.contains(26))

        let blackPawnCaptures = getSquares(SquareInfo[17].pawnCaptures[Int(Player.black.rawValue)])
        XCTAssertEqual(2, blackPawnCaptures.count)
        XCTAssertTrue(blackPawnCaptures.contains(8))
        XCTAssertTrue(blackPawnCaptures.contains(10))
    }

    func testPawnCapturesAtLeftBoardEdge() throws {
        let whitePawnCaptures = getSquares(SquareInfo[16].pawnCaptures[Int(Player.white.rawValue)])
        XCTAssertEqual(1, whitePawnCaptures.count)
        XCTAssertTrue(whitePawnCaptures.contains(25))

        let blackPawnCaptures = getSquares(SquareInfo[16].pawnCaptures[Int(Player.black.rawValue)])
        XCTAssertEqual(1, blackPawnCaptures.count)
        XCTAssertTrue(blackPawnCaptures.contains(9))
    }

    func testPawnCapturesAtRightBoardEdge() throws {
        let whitePawnCaptures = getSquares(SquareInfo[23].pawnCaptures[Int(Player.white.rawValue)])
        XCTAssertEqual(1, whitePawnCaptures.count)
        XCTAssertTrue(whitePawnCaptures.contains(30))

        let blackPawnCaptures = getSquares(SquareInfo[23].pawnCaptures[Int(Player.black.rawValue)])
        XCTAssertEqual(1, blackPawnCaptures.count)
        XCTAssertTrue(blackPawnCaptures.contains(14))
    }

    func testKingMoves() throws {
        var result = getSquares(SquareInfo[0].kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(1))
        XCTAssertTrue(result.contains(8))
        XCTAssertTrue(result.contains(9))

        result = getSquares(SquareInfo[7].kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(6))
        XCTAssertTrue(result.contains(14))
        XCTAssertTrue(result.contains(15))
        
        result = getSquares(SquareInfo[56].kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(57))
        XCTAssertTrue(result.contains(48))
        XCTAssertTrue(result.contains(49))
        
        result = getSquares(SquareInfo[63].kingMoves)
        XCTAssertEqual(3, result.count)
        XCTAssertTrue(result.contains(62))
        XCTAssertTrue(result.contains(54))
        XCTAssertTrue(result.contains(55))
    }

    func testCornerKnightMoves() throws {
        var result = getSquares(SquareInfo[0].knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(17))
        XCTAssertTrue(result.contains(10))

        result = getSquares(SquareInfo[7].knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(13))
        XCTAssertTrue(result.contains(22))
        
        result = getSquares(SquareInfo[56].knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(50))
        XCTAssertTrue(result.contains(41))
        
        result = getSquares(SquareInfo[63].knightMoves)
        XCTAssertEqual(2, result.count)
        XCTAssertTrue(result.contains(53))
        XCTAssertTrue(result.contains(46))
    }
    
    func testCentreKnightMoves() throws {
        let result = getSquares(SquareInfo[e4].knightMoves)
        XCTAssertEqual(8, result.count)
        XCTAssertTrue(result.contains(d2))
        XCTAssertTrue(result.contains(c3))
        XCTAssertTrue(result.contains(c5))
        XCTAssertTrue(result.contains(d6))
        XCTAssertTrue(result.contains(f6))
        XCTAssertTrue(result.contains(g5))
        XCTAssertTrue(result.contains(g3))
        XCTAssertTrue(result.contains(f2))
    }

    private func getSquares(_ squareSet: Int64) -> [Int] {
        var result: [Int] = []
        squareSet.foreach() {
            result.append($0)
            return true
        }
        
        return result
    }
}
