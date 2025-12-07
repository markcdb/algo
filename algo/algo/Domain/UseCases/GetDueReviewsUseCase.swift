//
//  GetDueReviewsUseCase.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Use case for fetching problems due for review
class GetDueReviewsUseCase {
    private let reviewScheduleRepository: ReviewScheduleRepository
    private let problemRepository: ProblemRepository
    
    init(
        reviewScheduleRepository: ReviewScheduleRepository,
        problemRepository: ProblemRepository
    ) {
        self.reviewScheduleRepository = reviewScheduleRepository
        self.problemRepository = problemRepository
    }
    
    /// Get all problems due for review with their schedules
    func getDueReviews() async throws -> [(problem: Problem, schedule: ReviewSchedule)] {
        let dueSchedules = try await reviewScheduleRepository.fetchDueReviews()
        
        var results: [(Problem, ReviewSchedule)] = []
        for schedule in dueSchedules {
            if let problem = try await problemRepository.fetchProblem(by: schedule.problemId) {
                results.append((problem, schedule))
            }
        }
        
        return results
    }
    
    /// Get count of due reviews
    func getDueReviewsCount() async throws -> Int {
        let dueSchedules = try await reviewScheduleRepository.fetchDueReviews()
        return dueSchedules.count
    }
}
