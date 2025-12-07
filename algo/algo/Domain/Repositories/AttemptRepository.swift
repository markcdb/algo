//
//  AttemptRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

protocol AttemptRepository {
    /// Fetch all attempts for a specific problem
    func fetchAttempts(for problemId: UUID) async throws -> [Attempt]
    
    /// Fetch all attempts
    func fetchAllAttempts() async throws -> [Attempt]
    
    /// Save a new attempt
    func saveAttempt(_ attempt: Attempt) async throws
    
    /// Get the most recent attempt for a problem
    func getLatestAttempt(for problemId: UUID) async throws -> Attempt?
    
    /// Get total number of attempts
    func getAttemptCount() async throws -> Int
}
