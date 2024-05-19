//
//  File.swift
//
//
//  Created by Tony on 19/03/2024.
//

import Foundation

public extension Int {
    var file: Int {
        get {
            return self % 8
        }
    }
    
    var rank: Int {
        get {
            return self / 8
        }
    }
    
    var isValidSquareNum: Bool {
        return self >= 0 && self < 64
    }
}

public func squareNum(file: Int, rank: Int) -> Int {
    return file + 8 * rank
}

public func squareNum(name: String) throws -> Int {
    return try Notation.parseSquareName(name: name)
}

public func forAllSquares(callback: (Int) throws -> Bool) throws {
    for i in 0...63 {
        if !(try callback(i)) {
            return
        }
    }
}



