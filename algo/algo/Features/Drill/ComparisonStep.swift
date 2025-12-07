//
//  ComparisonStep.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import SwiftUI

struct ComparisonView: View {
    @ObservedObject var viewModel: DrillViewModel
    let problem: Problem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Compare Solutions")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Review your approach against the optimal solution")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                // Pattern feedback
                if let selectedPattern = viewModel.selectedPattern {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pattern Recognition")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 12) {
                            Image(systemName: viewModel.patternMatches ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(viewModel.patternMatches ? .green : .orange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("You identified:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(selectedPattern.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("Correct pattern:")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(problem.pattern.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(viewModel.patternMatches ? .green : .orange)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            (viewModel.patternMatches ? Color.green : Color.orange)
                                .opacity(0.1)
                        )
                        .cornerRadius(12)
                    }
                }
                
                Divider()
                
                // Side by side comparison
                VStack(alignment: .leading, spacing: 16) {
                    // Your Solution
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("Your Solution")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        CodeEditorView(
                            code: .constant(viewModel.userCode),
                            language: .constant(viewModel.selectedLanguage),
                            isEditable: false
                        )
                        .frame(height: 200)
                    }
                    
                    // Canonical Solution
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text("Optimal Solution")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        // Show the clean solution code without wrapper
                        if let solution = problem.solution(for: viewModel.selectedLanguage) {
                            CodeEditorView(
                                code: .constant(solution.code),
                                language: .constant(viewModel.selectedLanguage),
                                isEditable: false
                            )
                            .frame(height: 200)
                        } else {
                            // Fallback to canonical solution
                            CodeEditorView(
                                code: .constant(problem.canonicalSolution),
                                language: .constant(problem.languageHint),
                                isEditable: false
                            )
                            .frame(height: 200)
                        }
                    }
                }
                
                Spacer()
                
                PrimaryButton(
                    title: "Next: Rate Difficulty",
                    action: { viewModel.currentStep = .rating }
                )
            }
            .padding()
        }
    }
}
