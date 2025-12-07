//
//  ProblemRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

protocol ProblemRepository {
    /// Fetch all available problems
    func fetchAllProblems() async throws -> [Problem]
    
    /// Fetch problems for a specific pattern
    func fetchProblems(for pattern: PatternType) async throws -> [Problem]
    
    /// Fetch a specific problem by ID
    func fetchProblem(by id: UUID) async throws -> Problem?
    
    /// Get a random problem, optionally filtered by pattern
    func getRandomProblem(pattern: PatternType?) async throws -> Problem?
    
    /// Add a new problem
    func addProblem(_ problem: Problem) async throws
}
