//
//  AttemptRating.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

enum AttemptRating: String, Codable, CaseIterable {
    case easy
    case medium
    case hard
    case gaveUp
    
    var displayName: String {
        switch self {
        case .gaveUp:
            return "Gave Up"
        default:
            return rawValue.capitalized
        }
    }
    
    /// Days until next review based on rating
    var nextReviewDays: Int {
        switch self {
        case .easy: return 7
        case .medium: return 3
        case .hard, .gaveUp: return 1
        }
    }
}
