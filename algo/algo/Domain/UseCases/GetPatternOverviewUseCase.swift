//
//  GetPatternOverviewUseCase.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

struct PatternMastery {
    let pattern: PatternType
    let totalProblems: Int
    let attemptedProblems: Int
    let averageRating: Double?
    
    var masteryPercentage: Double {
        guard totalProblems > 0 else { return 0 }
        return Double(attemptedProblems) / Double(totalProblems)
    }
}

/// Use case for getting pattern mastery overview
class GetPatternOverviewUseCase {
    private let problemRepository: ProblemRepository
    private let attemptRepository: AttemptRepository
    
    init(
        problemRepository: ProblemRepository,
        attemptRepository: AttemptRepository
    ) {
        self.problemRepository = problemRepository
        self.attemptRepository = attemptRepository
    }
    
    /// Get mastery data for all patterns
    func getPatternMastery() async throws -> [PatternMastery] {
        let allProblems = try await problemRepository.fetchAllProblems()
        let allAttempts = try await attemptRepository.fetchAllAttempts()
        
        // Group problems by pattern
        let problemsByPattern = Dictionary(grouping: allProblems) { $0.pattern.id }
        
        // Get attempted problem IDs
        let attemptedProblemIds = Set(allAttempts.map { $0.problemId })
        
        var masteryData: [PatternMastery] = []
        
        for pattern in PatternType.allPatterns {
            let problems = problemsByPattern[pattern.id] ?? []
            let attempted = problems.filter { attemptedProblemIds.contains($0.id) }
            
            // Calculate average rating for this pattern
            let patternAttempts = allAttempts.filter { attempt in
                problems.contains { $0.id == attempt.problemId }
            }
            
            let averageRating: Double? = {
                guard !patternAttempts.isEmpty else { return nil }
                let ratingValues = patternAttempts.map { ratingToValue($0.selfRating) }
                return ratingValues.reduce(0, +) / Double(ratingValues.count)
            }()
            
            masteryData.append(
                PatternMastery(
                    pattern: pattern,
                    totalProblems: problems.count,
                    attemptedProblems: attempted.count,
                    averageRating: averageRating
                )
            )
        }
        
        return masteryData
    }
    
    /// Get mastery for a specific pattern
    func getPatternMastery(for pattern: PatternType) async throws -> PatternMastery? {
        let allMastery = try await getPatternMastery()
        return allMastery.first { $0.pattern.id == pattern.id }
    }
    
    private func ratingToValue(_ rating: AttemptRating) -> Double {
        switch rating {
        case .easy: return 4.0
        case .medium: return 3.0
        case .hard: return 2.0
        case .gaveUp: return 1.0
        }
    }
}
