//
//  TestCase.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Represents a test case for validating problem solutions
struct TestCase: Identifiable, Codable {
    let id: UUID
    let input: String
    let expectedOutput: String
    let explanation: String?
    
    init(
        id: UUID? = nil,
        input: String,
        expectedOutput: String,
        explanation: String? = nil
    ) {
        self.id = id ?? UUID()
        self.input = input
        self.expectedOutput = expectedOutput
        self.explanation = explanation
    }
}

// MARK: - Hashable conformance
extension TestCase: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TestCase, rhs: TestCase) -> Bool {
        lhs.id == rhs.id
    }
}
