//
//  PatternDifficulty.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

enum PatternDifficulty: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
    
    var displayName: String {
        rawValue.capitalized
    }
}
