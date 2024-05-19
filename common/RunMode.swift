//
//  File.swift
//  
//
//  Created by Tony on 28/03/2024.
//

import Foundation

public enum RunMode {
    case humanVsHuman
    case humanVsComputer
    case computerVsHuman
    case computerVsComputer
}

extension RunMode {
    func switchSides() -> RunMode {
        switch self {
        case .humanVsComputer: return .computerVsHuman
        case .computerVsHuman: return .humanVsComputer
        default: return self
        }
    }
}
