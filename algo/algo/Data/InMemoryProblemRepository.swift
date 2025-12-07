//
//  InMemoryProblemRepository.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

actor InMemoryProblemRepository: ProblemRepository {
    private var problems: [Problem]
    
    init(problems: [Problem]? = nil) {
        if let problems = problems {
            self.problems = problems
        } else {
            // Load from JSON config file
            self.problems = ProblemConfigLoader.loadProblems()
        }
    }
    
    func fetchAllProblems() async throws -> [Problem] {
        return problems
    }
    
    func fetchProblems(for pattern: PatternType) async throws -> [Problem] {
        return problems.filter { $0.pattern.id == pattern.id }
    }
    
    func fetchProblem(by id: UUID) async throws -> Problem? {
        return problems.first { $0.id == id }
    }
    
    func getRandomProblem(pattern: PatternType?) async throws -> Problem? {
        if let pattern = pattern {
            let filtered = problems.filter { $0.pattern.id == pattern.id }
            return filtered.randomElement()
        } else {
            return problems.randomElement()
        }
    }
    
    func addProblem(_ problem: Problem) async throws {
        problems.append(problem)
    }
}
