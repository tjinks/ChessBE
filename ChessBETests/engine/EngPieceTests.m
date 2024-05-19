//
//  EngPieceTests.m
//  ChessBETests
//
//  Created by Tony on 17/05/2024.
//

#import <XCTest/XCTest.h>

#include "../../../ChessBE/engine/EngPiece.h"

@interface EngPieceTests : XCTestCase

@end

@implementation EngPieceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testEngGetPiece {
    EngPiece piece1 = engPiece(White, Rook);
    EngPiece piece2 = engPiece(Black, King);
    EngPiece piece3 = engPiece(NoPlayer, NoPieceType);
    XCTAssertEqual(WhiteRook, piece1);
    XCTAssertEqual(BlackKing, piece2);
    XCTAssertEqual(NoPiece, piece3);
    
    EngPieceType pieceType1 = engGetPieceType(piece1);
    EngPlayer player1 = engGetOwner(piece1);
    XCTAssertEqual(Rook, pieceType1);
    XCTAssertEqual(White, player1);

    EngPieceType pieceType2 = engGetPieceType(piece2);
    EngPlayer player2 = engGetOwner(piece2);
    XCTAssertEqual(King, pieceType2);
    XCTAssertEqual(Black, player2);

    EngPieceType pieceType3 = engGetPieceType(piece3);
    EngPlayer player3 = engGetOwner(piece3);
    XCTAssertEqual(NoPieceType, pieceType3);
    XCTAssertEqual(NoPlayer, player3);
}

@end
