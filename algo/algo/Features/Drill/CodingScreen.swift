//
//  CodingScreen.swift
//  algo
//
//  Created by Copilot on 12/6/25.
//

import SwiftUI

struct CodingScreen: View {
    @ObservedObject var viewModel: DrillViewModel
    let problem: Problem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Code Editor
            CodeEditorView(
                code: $viewModel.userCode,
                language: $viewModel.selectedLanguage
            )
            .frame(maxHeight: .infinity)
            
            Divider()
            
            // Bottom toolbar
            VStack(spacing: 12) {
                // Run Tests Button
                if !problem.testCases.isEmpty {
                    HStack(spacing: 12) {
                        Button(action: {
                            Task {
                                await viewModel.runTests()
                            }
                        }) {
                            HStack {
                                if viewModel.isExecuting {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "play.circle.fill")
                                }
                                Text(viewModel.isExecuting ? "Running Tests..." : "Run Tests")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isExecuting ? Color.gray : Color.green)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.isExecuting || viewModel.userCode.isEmpty)
                        
                        Button(action: {
                            viewModel.testResults = nil
                            viewModel.executionError = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .opacity(viewModel.testResults != nil || viewModel.executionError != nil ? 1 : 0)
                    }
                }
                
                // Test Results
                if let testResults = viewModel.testResults {
                    TestResultsView(results: testResults)
                }
                
                // Execution Error
                if let error = viewModel.executionError {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(error)
                            .font(.caption)
                    }
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Submit Button
                PrimaryButton(
                    title: "Submit Solution",
                    action: {
                        viewModel.submitCode()
                        dismiss()
                    },
                    isEnabled: !viewModel.userCode.isEmpty
                )
            }
            .padding()
            .background(Color(UIColor.systemBackground))
        }
        .navigationTitle("Write Code")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    ForEach(SupportedLanguage.allCases, id: \.self) { language in
                        Button(action: {
                            viewModel.selectedLanguage = language
                        }) {
                            HStack {
                                Text(language.rawValue.capitalized)
                                if viewModel.selectedLanguage == language {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedLanguage.rawValue.capitalized)
                        Image(systemName: "chevron.down")
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CodingScreen(
            viewModel: DrillViewModel(
                startDrillUseCase: StartDrillUseCase(
                    problemRepository: InMemoryProblemRepository(),
                    reviewScheduleRepository: InMemoryReviewScheduleRepository()
                ),
                completeAttemptUseCase: CompleteAttemptUseCase(
                    attemptRepository: InMemoryAttemptRepository(),
                    reviewScheduleRepository: InMemoryReviewScheduleRepository()
                )
            ),
            problem: Problem(
                title: "Test Problem",
                prompt: "Test prompt",
                pattern: .slidingWindow,
                languageHint: .swift,
                canonicalSolution: "func test() {}",
                solutions: [],
                tags: [],
                estimatedTimeMinutes: 5,
                testCases: []
            )
        )
    }
}
