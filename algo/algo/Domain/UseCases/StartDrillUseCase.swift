//
//  StartDrillUseCase.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Use case for starting a new drill session
class StartDrillUseCase {
    private let problemRepository: ProblemRepository
    private let reviewScheduleRepository: ReviewScheduleRepository
    
    init(
        problemRepository: ProblemRepository,
        reviewScheduleRepository: ReviewScheduleRepository
    ) {
        self.problemRepository = problemRepository
        self.reviewScheduleRepository = reviewScheduleRepository
    }
    
    /// Get next problem for drill - prioritizes due reviews, then random new problem
    func getNextProblem() async throws -> Problem? {
        // First check for due reviews
        let dueReviews = try await reviewScheduleRepository.fetchDueReviews()
        
        if let firstDue = dueReviews.first {
            return try await problemRepository.fetchProblem(by: firstDue.problemId)
        }
        
        // Otherwise get a random problem
        return try await problemRepository.getRandomProblem(pattern: nil)
    }
    
    /// Get a problem for a specific pattern
    func getProblem(for pattern: PatternType) async throws -> Problem? {
        return try await problemRepository.getRandomProblem(pattern: pattern)
    }
    
    /// Get a specific problem by ID (for review queue)
    func getProblem(by id: UUID) async throws -> Problem? {
        return try await problemRepository.fetchProblem(by: id)
    }
}
