//
//  InMemoryReviewScheduleRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

actor InMemoryReviewScheduleRepository: ReviewScheduleRepository {
    private var schedules: [ReviewSchedule] = []
    
    func fetchAllSchedules() async throws -> [ReviewSchedule] {
        return schedules
    }
    
    func fetchSchedule(for problemId: UUID) async throws -> ReviewSchedule? {
        return schedules.first { $0.problemId == problemId }
    }
    
    func fetchDueReviews() async throws -> [ReviewSchedule] {
        return schedules.filter { $0.isDue }
    }
    
    func saveSchedule(_ schedule: ReviewSchedule) async throws {
        if let index = schedules.firstIndex(where: { $0.problemId == schedule.problemId }) {
            schedules[index] = schedule
        } else {
            schedules.append(schedule)
        }
    }
    
    func createSchedule(for problemId: UUID) async throws -> ReviewSchedule {
        let schedule = ReviewSchedule(
            problemId: problemId,
            nextReviewDate: Date()
        )
        return schedule
    }
    
    func updateScheduleAfterAttempt(problemId: UUID, rating: AttemptRating) async throws {
        guard let index = schedules.firstIndex(where: { $0.problemId == problemId }) else {
            // Create new schedule if it doesn't exist
            var newSchedule = try await createSchedule(for: problemId)
            newSchedule.updateAfterAttempt(rating: rating)
            try await saveSchedule(newSchedule)
            return
        }
        
        var schedule = schedules[index]
        schedule.updateAfterAttempt(rating: rating)
        schedules[index] = schedule
    }
}
