//
//  PatternRecognitionStep.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import SwiftUI

struct PatternRecognitionView: View {
    @ObservedObject var viewModel: PatternRecognitionViewModel
    @State private var patternOptions: [PatternType] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Problem Title
                Text(viewModel.problem.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Problem Prompt with formatting
                FormattedProblemPrompt(text: viewModel.problem.prompt)
                
                Divider()
                    .padding(.vertical, 8)
                
                // Pattern Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("What pattern is this?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(patternOptions, id: \.id) { pattern in
                        PatternOptionButton(
                            pattern: pattern,
                            isSelected: viewModel.selectedPattern?.id == pattern.id
                        ) {
                            viewModel.selectedPattern = pattern
                        }
                    }
                }
                .onAppear {
                    if patternOptions.isEmpty {
                        patternOptions = generateRandomPatternOptions()
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                // Optional: Approach
                VStack(alignment: .leading, spacing: 8) {
                    Text("High-level approach (optional)")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Describe your strategy before coding")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $viewModel.userApproach)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Spacer()
                
                PrimaryButton(
                    title: "Next: Write Code",
                    action: {
                        viewModel.submitPatternSelection()
                    },
                    isEnabled: viewModel.selectedPattern != nil
                )
            }
            .padding()
        }
    }
    
    // Generate 3 random pattern options including the correct answer
    private func generateRandomPatternOptions() -> [PatternType] {
        let correctPattern = viewModel.problem.pattern
        
        // Get all other patterns (excluding the correct one)
        let otherPatterns = PatternType.allPatterns.filter { $0.id != correctPattern.id }
        
        // Randomly select 2 wrong patterns
        let wrongPatterns = otherPatterns.shuffled().prefix(2)
        
        // Combine correct pattern with wrong ones and shuffle
        var options = Array(wrongPatterns) + [correctPattern]
        options.shuffle()
        
        return options
    }
}

struct PatternOptionButton: View {
    let pattern: PatternType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(pattern.shortDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
