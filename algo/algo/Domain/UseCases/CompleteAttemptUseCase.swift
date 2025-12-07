//
//  CompleteAttemptUseCase.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Use case for completing an attempt and updating review schedule
class CompleteAttemptUseCase {
    private let attemptRepository: AttemptRepository
    private let reviewScheduleRepository: ReviewScheduleRepository
    
    init(
        attemptRepository: AttemptRepository,
        reviewScheduleRepository: ReviewScheduleRepository
    ) {
        self.attemptRepository = attemptRepository
        self.reviewScheduleRepository = reviewScheduleRepository
    }
    
    /// Save attempt and update review schedule
    func completeAttempt(
        problemId: UUID,
        userCode: String,
        rating: AttemptRating,
        durationSeconds: Int
    ) async throws {
        // Create and save attempt
        let attempt = Attempt(
            problemId: problemId,
            userCode: userCode,
            selfRating: rating,
            durationSeconds: durationSeconds
        )
        try await attemptRepository.saveAttempt(attempt)
        
        // Update or create review schedule
        if let existingSchedule = try await reviewScheduleRepository.fetchSchedule(for: problemId) {
            // Update existing schedule
            try await reviewScheduleRepository.updateScheduleAfterAttempt(
                problemId: problemId,
                rating: rating
            )
        } else {
            // Create new schedule
            var newSchedule = try await reviewScheduleRepository.createSchedule(for: problemId)
            newSchedule.updateAfterAttempt(rating: rating)
            try await reviewScheduleRepository.saveSchedule(newSchedule)
        }
    }
}
