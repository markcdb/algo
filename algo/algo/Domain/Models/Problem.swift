//
//  Problem.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Represents a coding solution in a specific language
struct Solution: Codable, Hashable {
    let language: String
    let code: String
    let wrapper: String  // Input/output execution code
    
    init(language: String, code: String, wrapper: String) {
        self.language = language
        self.code = code
        self.wrapper = wrapper
    }
    
    /// Returns the complete executable code (solution + wrapper)
    var executableCode: String {
        return code + wrapper
    }
}

struct Problem: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let prompt: String
    let pattern: PatternType
    let languageHint: SupportedLanguage
    let canonicalSolution: String
    let solutions: [Solution]  // NEW: Array of Solution objects
    let tags: [String]
    let estimatedTimeMinutes: Int
    let testCases: [TestCase]
    
    init(
        title: String,
        prompt: String,
        pattern: PatternType,
        languageHint: SupportedLanguage,
        canonicalSolution: String,
        solutions: [Solution] = [],  // NEW: multi-language support
        tags: [String],
        estimatedTimeMinutes: Int,
        testCases: [TestCase] = []
    ) {
        self.id = UUID()
        self.title = title
        self.prompt = prompt
        self.pattern = pattern
        self.languageHint = languageHint
        self.canonicalSolution = canonicalSolution
        self.solutions = solutions
        self.tags = tags
        self.estimatedTimeMinutes = estimatedTimeMinutes
        self.testCases = testCases
    }
    
    /// Get solution for a specific language, falls back to canonical if not available
    func solution(for language: SupportedLanguage) -> Solution? {
        return solutions.first { $0.language.lowercased() == language.rawValue.lowercased() }
    }
}
