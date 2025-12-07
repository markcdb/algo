//
//  ReviewScheduleRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

protocol ReviewScheduleRepository {
    /// Fetch all review schedules
    func fetchAllSchedules() async throws -> [ReviewSchedule]
    
    /// Fetch schedule for a specific problem
    func fetchSchedule(for problemId: UUID) async throws -> ReviewSchedule?
    
    /// Fetch all due reviews
    func fetchDueReviews() async throws -> [ReviewSchedule]
    
    /// Save or update a review schedule
    func saveSchedule(_ schedule: ReviewSchedule) async throws
    
    /// Create a new schedule for a problem
    func createSchedule(for problemId: UUID) async throws -> ReviewSchedule
    
    /// Update schedule after an attempt
    func updateScheduleAfterAttempt(problemId: UUID, rating: AttemptRating) async throws
}
