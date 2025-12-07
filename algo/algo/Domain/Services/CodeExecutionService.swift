//
//  CodeExecutionService.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

// MARK: - Execution Request

struct ExecutionRequest {
    let language: String
    let code: String
    let stdin: String?
    
    init(language: String, code: String, stdin: String? = nil) {
        self.language = language
        self.code = code
        self.stdin = stdin
    }
}

// MARK: - Execution Result

struct ExecutionResult {
    let stdout: String
    let stderr: String
    let exitCode: Int
    let executionTime: Double?
    
    var isSuccess: Bool {
        exitCode == 0 && stderr.isEmpty
    }
}

// MARK: - Test Result

struct TestResult: Identifiable {
    let id: UUID
    let testCase: TestCase
    let passed: Bool
    let actualOutput: String
    let executionTime: Double?
    let error: String?
    
    init(
        id: UUID = UUID(),
        testCase: TestCase,
        passed: Bool,
        actualOutput: String,
        executionTime: Double? = nil,
        error: String? = nil
    ) {
        self.id = id
        self.testCase = testCase
        self.passed = passed
        self.actualOutput = actualOutput
        self.executionTime = executionTime
        self.error = error
    }
}

// MARK: - Code Execution Service Protocol

protocol CodeExecutionService {
    /// Execute code with optional stdin input
    func execute(request: ExecutionRequest) async throws -> ExecutionResult
    
    /// Run code against multiple test cases
    func runTests(code: String, language: String, testCases: [TestCase]) async throws -> [TestResult]
}

// MARK: - Execution Errors

enum CodeExecutionError: LocalizedError {
    case networkError(Error)
    case invalidResponse
    case apiError(String)
    case timeout
    case unsupportedLanguage(String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from execution service"
        case .apiError(let message):
            return "Execution error: \(message)"
        case .timeout:
            return "Code execution timed out"
        case .unsupportedLanguage(let lang):
            return "Language '\(lang)' is not supported"
        }
    }
}
