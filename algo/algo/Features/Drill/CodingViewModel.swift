//
//  CodingViewModel.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

@MainActor
class CodingViewModel: ObservableObject {
    @Published var userCode: String = ""
    @Published var selectedLanguage: SupportedLanguage = .swift
    @Published var isExecuting: Bool = false
    @Published var testResults: [TestResult]?
    @Published var executionError: String?
    
    let problem: Problem
    let selectedPattern: PatternType
    let startTime: Date
    private let router: AppRouting
    private let codeExecutionService: CodeExecutionService
    
    init(
        problem: Problem,
        selectedPattern: PatternType,
        startTime: Date,
        router: AppRouting,
        codeExecutionService: CodeExecutionService = PistonCodeExecutor()
    ) {
        self.problem = problem
        self.selectedPattern = selectedPattern
        self.startTime = startTime
        self.router = router
        self.codeExecutionService = codeExecutionService
        setupInitialCode()
    }
    
    private func setupInitialCode() {
        // Generate a starter template based on the language
        switch problem.languageHint {
        case .swift:
            userCode = "func solve() {\n    // Your solution here\n}\n"
        case .python:
            userCode = "def solve():\n    # Your solution here\n    pass\n"
        case .java:
            userCode = "public void solve() {\n    // Your solution here\n}\n"
        case .javascript:
            userCode = "function solve() {\n    // Your solution here\n}\n"
        case .cpp:
            userCode = "void solve() {\n    // Your solution here\n}\n"
        }
    }
    
    func runTests() async {
        guard !problem.testCases.isEmpty else {
            executionError = "No test cases available"
            return
        }
        
        isExecuting = true
        executionError = nil
        testResults = nil
        
        do {
            let results = try await codeExecutionService.runTests(
                code: userCode,
                language: selectedLanguage.rawValue,
                testCases: problem.testCases
            )
            testResults = results
        } catch {
            executionError = error.localizedDescription
        }
        
        isExecuting = false
    }
    
    func submitCode() {
        router.push(.drillComparison(
            problem: problem,
            selectedPattern: selectedPattern,
            userCode: userCode,
            selectedLanguage: selectedLanguage,
            startTime: startTime
        ))
    }
}
