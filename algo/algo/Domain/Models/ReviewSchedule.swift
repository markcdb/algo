//
//  ReviewSchedule.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

struct ReviewSchedule: Identifiable, Codable {
    let id: UUID
    let problemId: UUID
    var nextReviewDate: Date
    var easeFactor: Double
    var lastResult: AttemptRating?
    
    init(
        problemId: UUID,
        nextReviewDate: Date,
        easeFactor: Double = 1.0,
        lastResult: AttemptRating? = nil
    ) {
        self.id = UUID()
        self.problemId = problemId
        self.nextReviewDate = nextReviewDate
        self.easeFactor = easeFactor
        self.lastResult = lastResult
    }
    
    /// Check if this problem is due for review
    var isDue: Bool {
        nextReviewDate <= Date()
    }
    
    /// Update schedule based on attempt rating
    mutating func updateAfterAttempt(rating: AttemptRating) {
        lastResult = rating
        let daysToAdd = rating.nextReviewDays
        nextReviewDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date()) ?? Date()
        
        // Adjust ease factor based on performance
        switch rating {
        case .easy:
            easeFactor = min(easeFactor + 0.15, 2.5)
        case .medium:
            easeFactor = max(easeFactor - 0.05, 1.0)
        case .hard, .gaveUp:
            easeFactor = max(easeFactor - 0.2, 1.0)
        }
    }
}
