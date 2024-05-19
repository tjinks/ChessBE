//
//  File.swift
//  
//
//  Created by Tony on 14/01/2024.
//

import Foundation

enum ChessError : Error {
    case internalError(message: String)
    case invalidSquare
    case invalidFen
    case missingKing
    case duplicateKing
}
