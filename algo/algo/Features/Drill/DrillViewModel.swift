//
//  DrillViewModel.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation
import SwiftUI

enum DrillStep {
    case tutorial  // NEW: Interactive visual learning
    case patternRecognition
    case coding
    case comparison
    case rating
}

@MainActor
class DrillViewModel: ObservableObject {
    @Published var currentStep: DrillStep = .tutorial
    @Published var problem: Problem?
    @Published var tutorial: PatternTutorial?
    @Published var showTutorial: Bool = true  // Can be toggled in settings
    @Published var selectedPattern: PatternType?
    @Published var userApproach: String = ""
    @Published var userCode: String = ""
    @Published var selectedLanguage: SupportedLanguage = .swift
    @Published var selectedRating: AttemptRating?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var startTime: Date = Date()
    
    // Code execution state
    @Published var isExecuting: Bool = false
    @Published var testResults: [TestResult]?
    @Published var executionError: String?
    
    private let router: AppRouting
    private let startDrillUseCase: StartDrillUseCase
    private let completeAttemptUseCase: CompleteAttemptUseCase
    private let codeExecutionService: CodeExecutionService
    
    init(
        router: AppRouting,
        startDrillUseCase: StartDrillUseCase,
        completeAttemptUseCase: CompleteAttemptUseCase,
        codeExecutionService: CodeExecutionService = PistonCodeExecutor()
    ) {
        self.router = router
        self.startDrillUseCase = startDrillUseCase
        self.completeAttemptUseCase = completeAttemptUseCase
        self.codeExecutionService = codeExecutionService
    }
    
    // MARK: - Actions
    
    func loadProblem(problemId: UUID? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            if let problemId = problemId {
                problem = try await startDrillUseCase.getProblem(by: problemId)
            } else {
                problem = try await startDrillUseCase.getNextProblem()
            }
            
            if let problem = problem {
                startTime = Date()
                setupInitialCode()
                
                // Load tutorial if available
                if showTutorial {
                    tutorial = PatternTutorial.tutorial(for: problem.pattern)
                    currentStep = tutorial != nil ? .tutorial : .patternRecognition
                } else {
                    currentStep = .patternRecognition
                }
            } else {
                errorMessage = "No problems available"
            }
        } catch {
            errorMessage = "Failed to load problem: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func loadAndStartDrill(problemId: UUID? = nil) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let loadedProblem: Problem?
            if let problemId = problemId {
                loadedProblem = try await startDrillUseCase.getProblem(by: problemId)
            } else {
                loadedProblem = try await startDrillUseCase.getNextProblem()
            }
            
            guard let loadedProblem = loadedProblem else {
                errorMessage = "No problems available"
                isLoading = false
                return
            }
            
            problem = loadedProblem
            let tutorial = PatternTutorial.tutorial(for: loadedProblem.pattern)
            let currentStartTime = Date()
            
            isLoading = false
            
            // Navigate to first drill step (pattern recognition or tutorial)
            router.push(.drillPatternRecognition(
                problem: loadedProblem,
                tutorial: showTutorial ? tutorial : nil,
                startTime: currentStartTime
            ))
        } catch {
            errorMessage = "Failed to load problem: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func completeTutorial() {
        currentStep = .patternRecognition
    }
    
    func submitPatternSelection() {
        guard selectedPattern != nil else { return }
        currentStep = .coding
    }
    
    func submitCode() {
        currentStep = .comparison
    }
    
    func runTests() async {
        guard let problem = problem, !problem.testCases.isEmpty else {
            executionError = "No test cases available for this problem"
            return
        }
        
        isExecuting = true
        executionError = nil
        testResults = nil
        
        do {
            // Get the solution for the selected language
            guard let solution = problem.solution(for: selectedLanguage) else {
                executionError = "No solution available for \(selectedLanguage.rawValue)"
                isExecuting = false
                return
            }
            
            // Combine user code with wrapper for execution
            let executableCode = userCode + solution.wrapper
            
            let results = try await codeExecutionService.runTests(
                code: executableCode,
                language: selectedLanguage.rawValue.lowercased(),
                testCases: problem.testCases
            )
            testResults = results
        } catch {
            executionError = error.localizedDescription
        }
        
        isExecuting = false
    }
    
    func submitRating() async {
        guard let problem = problem,
              let rating = selectedRating else { return }
        
        isLoading = true
        
        do {
            let duration = Int(Date().timeIntervalSince(startTime))
            try await completeAttemptUseCase.completeAttempt(
                problemId: problem.id,
                userCode: userCode,
                rating: rating,
                durationSeconds: duration
            )
            
            router.pop()
        } catch {
            errorMessage = "Failed to save attempt: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func goBack() {
        switch currentStep {
        case .tutorial:
            break // Can't go back from tutorial
        case .patternRecognition:
            if tutorial != nil {
                currentStep = .tutorial
            }
        case .coding:
            currentStep = .patternRecognition
        case .comparison:
            currentStep = .coding
        case .rating:
            currentStep = .comparison
        }
    }
    
    // MARK: - Helpers
    
    private func setupInitialCode() {
        guard let problem = problem else { return }
        
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
    
    var elapsedTime: String {
        let duration = Int(Date().timeIntervalSince(startTime))
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var patternMatches: Bool {
        guard let problem = problem,
              let selected = selectedPattern else { return false }
        return problem.pattern.id == selected.id
    }
}
