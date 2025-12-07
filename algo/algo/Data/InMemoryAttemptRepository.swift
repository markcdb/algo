//
//  InMemoryAttemptRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

actor InMemoryAttemptRepository: AttemptRepository {
    private var attempts: [Attempt] = []
    
    func fetchAttempts(for problemId: UUID) async throws -> [Attempt] {
        return attempts.filter { $0.problemId == problemId }
    }
    
    func fetchAllAttempts() async throws -> [Attempt] {
        return attempts
    }
    
    func saveAttempt(_ attempt: Attempt) async throws {
        attempts.append(attempt)
    }
    
    func getLatestAttempt(for problemId: UUID) async throws -> Attempt? {
        return attempts
            .filter { $0.problemId == problemId }
            .sorted { $0.createdAt > $1.createdAt }
            .first
    }
    
    func getAttemptCount() async throws -> Int {
        return attempts.count
    }
}
