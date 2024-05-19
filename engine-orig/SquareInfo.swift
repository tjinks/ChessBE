//
//  File.swift
//
//
//  Created by Tony on 24/01/2024.
//

import Foundation

let sentinel: Int64 = 0xFF

struct SquareInfo {
    let north: Int64
    let south: Int64
    let east: Int64
    let west: Int64
    let nw: Int64
    let ne: Int64
    let sw: Int64
    let se: Int64
    let knightMoves: Int64
    let kingMoves: Int64
    let pawnMoves: [Int64]
    let pawnCaptures: [Int64]
    private static let instanceData = InstanceData()
    
    private struct InstanceData {
        let squareInfo: [SquareInfo]
        
        init() {
            var squareInfo: [SquareInfo] = []
            for i in 0...63 {
                squareInfo.append(SquareInfo(square: i))
            }
            
            self.squareInfo = squareInfo
        }
    }
    
    static subscript(index: Int) -> SquareInfo {
        get { 
            return instanceData.squareInfo[index]
        }
    }
    
    private init(square: Int) {
        let x = square % 8
        let y = square / 8
        north = SquareInfo.getSlidingMoves(x: x, y: y, dx: 0, dy: 1)
        south = SquareInfo.getSlidingMoves(x: x, y: y, dx: 0, dy: -1)
        east = SquareInfo.getSlidingMoves(x: x, y: y, dx: 1, dy: 0)
        west = SquareInfo.getSlidingMoves(x: x, y: y, dx: -1, dy: 0)
        nw = SquareInfo.getSlidingMoves(x: x, y: y, dx: -1, dy: 1)
        ne = SquareInfo.getSlidingMoves(x: x, y: y, dx: 1, dy: 1)
        sw = SquareInfo.getSlidingMoves(x: x, y: y, dx: -1, dy: -1)
        se = SquareInfo.getSlidingMoves(x: x, y: y, dx: 1, dy: -1)
        knightMoves = SquareInfo.getKnightMoves(x: x, y: y)
        kingMoves = SquareInfo.getKingMoves(x: x, y: y)
        pawnMoves = [SquareInfo.getPawnMoves(x: x, y: y, dy: 1), SquareInfo.getPawnMoves(x: x, y: y, dy: -1)]
        pawnCaptures = [SquareInfo.getPawnCaptures(x: x, y: y, dy: 1), SquareInfo.getPawnCaptures(x: x, y: y, dy: -1)]
    }
    
    private static func getSlidingMoves(x: Int, y: Int, dx: Int, dy: Int) -> Int64 {
        var result = sentinel
        var x = x + dx
        var y = y + dy
        while addIfValid(&result, x, y) {
            x += dx
            y += dy
        }
        
        return reverse(result)
    }
    
    private static func getPawnMoves(x: Int, y: Int, dy: Int) -> Int64 {
        var result = sentinel
        if (dy == 1 && y == 1) || (dy == -1 && y == 6) {
            addIfValid(&result, x, y + 2 * dy)
        }
        
        addIfValid(&result, x, y + dy)

        return result
    }
    
    private static func getPawnCaptures(x: Int, y: Int, dy: Int) -> Int64 {
        var result = sentinel
        addIfValid(&result, x - 1, y + dy)
        addIfValid(&result, x + 1, y + dy)
        return result
    }
    
    private static func getKnightMoves(x: Int, y: Int) -> Int64 {
        var result = sentinel
        addIfValid(&result, x + 1, y + 2)
        addIfValid(&result, x + 1, y - 2)
        addIfValid(&result, x - 1, y + 2)
        addIfValid(&result, x - 1, y - 2)
        addIfValid(&result, x + 2, y + 1)
        addIfValid(&result, x + 2, y - 1)
        addIfValid(&result, x - 2, y + 1)
        addIfValid(&result, x - 2, y - 1)
        
        return result
    }
    
    
    private static func getKingMoves(x: Int, y: Int) -> Int64 {
        var result: Int64 = sentinel
        addIfValid(&result, x + 1, y + 1)
        addIfValid(&result, x + 1, y - 1)
        addIfValid(&result, x - 1, y + 1)
        addIfValid(&result, x - 1, y - 1)
        addIfValid(&result, x + 1, y)
        addIfValid(&result, x - 1, y)
        addIfValid(&result, x, y + 1)
        addIfValid(&result, x, y - 1)
        
        return result
    }
    
    @discardableResult private static func addIfValid(_ squareSet: inout Int64, _ file: Int, _ rank: Int) -> Bool {
        if file >= 0 && rank >= 0 && file < 8 && rank < 8 {
            squareSet <<= 8
            squareSet += Int64(file + 8 * rank)
            return true
        }
        
        return false
        
    }
    
    private static func reverse(_ squareSet: Int64) -> Int64 {
        var result = sentinel
        squareSet.foreach() {
            result <<= 8
            result += Int64($0)
            return true
        }
        
        return result
    }
}

extension Int64 {
    func foreach(callback: (Int) -> Bool) {
        var squareSet = self
        for _ in 0...7 {
            let square = squareSet & 0xFF
            if square == sentinel {
                return
            }
            
            if !callback(Int(square)) {
                return
            }
            
            squareSet >>= 8
        }
    }
}
