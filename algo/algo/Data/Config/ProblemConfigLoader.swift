//
//  ProblemConfig.swift
//  algo
//
//  Created by Copilot on 12/5/25.
//

import Foundation

/// Configuration structure for problems loaded from JSON
struct ProblemConfig: Codable {
    let problems: [ProblemData]
}

struct SolutionData: Codable {
    let language: String
    let code: String
    let wrapper: String
}

struct ProblemData: Codable {
    let id: String
    let title: String
    let prompt: String
    let pattern: String
    let difficulty: String
    let tags: [String]
    let estimatedTimeMinutes: Int
    let solutions: [SolutionData]  // NEW: Array of solution objects
    let testCases: [TestCaseData]
}

struct TestCaseData: Codable {
    let input: String
    let expectedOutput: String
    let explanation: String?
}

/// Loads problems from JSON configuration file
class ProblemConfigLoader {
    static func loadProblems(from filename: String = "problems") -> [Problem] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(ProblemConfig.self, from: data) else {
            print("⚠️ Failed to load problems from \(filename).json, using fallback")
            return []
        }
        
        return config.problems.compactMap { convertToProblem($0) }
    }
    
    private static func convertToProblem(_ data: ProblemData) -> Problem? {
        guard let pattern = patternFromString(data.pattern) else {
            print("⚠️ Unknown pattern: \(data.pattern)")
            return nil
        }
        
        // Convert solution data to Solution objects
        let solutions = data.solutions.map { solutionData in
            Solution(
                language: solutionData.language,
                code: solutionData.code,
                wrapper: solutionData.wrapper
            )
        }
        
        // Determine default language (prefer Swift, fallback to first available)
        let languageHint: SupportedLanguage
        if solutions.contains(where: { $0.language.lowercased() == "swift" }) {
            languageHint = .swift
        } else if solutions.contains(where: { $0.language.lowercased() == "python" }) {
            languageHint = .python
        } else if solutions.contains(where: { $0.language.lowercased() == "java" }) {
            languageHint = .java
        } else if solutions.contains(where: { $0.language.lowercased() == "javascript" }) {
            languageHint = .javascript
        } else if solutions.contains(where: { $0.language.lowercased() == "cpp" }) {
            languageHint = .cpp
        } else {
            languageHint = .swift
        }
        
        // Get the canonical solution for the hint language
        let canonicalSolution = solutions.first(where: { $0.language.lowercased() == languageHint.rawValue.lowercased() })?.code ?? ""
        
        // Convert test cases
        let testCases = data.testCases.map { testData in
            TestCase(
                input: testData.input,
                expectedOutput: testData.expectedOutput,
                explanation: testData.explanation
            )
        }
        
        return Problem(
            title: data.title,
            prompt: data.prompt,
            pattern: pattern,
            languageHint: languageHint,
            canonicalSolution: canonicalSolution,
            solutions: solutions,
            tags: data.tags,
            estimatedTimeMinutes: data.estimatedTimeMinutes,
            testCases: testCases
        )
    }
    
    private static func patternFromString(_ str: String) -> PatternType? {
        switch str.lowercased() {
        case "slidingwindow": return .slidingWindow
        case "twopointers": return .twoPointers
        case "binarysearch": return .binarySearch
        case "heap": return .heap
        case "graphbfs": return .graphBFS
        case "graphdfs": return .graphDFS
        case "intervals": return .intervals
        case "dynamicprogramming": return .dynamicProgramming
        default: return nil
        }
    }
}
