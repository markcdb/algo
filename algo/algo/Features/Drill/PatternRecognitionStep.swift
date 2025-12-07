//
//  PatternRecognitionStep.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import SwiftUI

struct PatternRecognitionView: View {
    @ObservedObject var viewModel: DrillViewModel
    let problem: Problem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Problem Title
                Text(problem.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Problem Prompt with formatting
                FormattedProblemPrompt(text: problem.prompt)
                
                Divider()
                    .padding(.vertical, 8)
                
                // Pattern Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("What pattern is this?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    ForEach(PatternType.allPatterns, id: \.id) { pattern in
                        PatternOptionButton(
                            pattern: pattern,
                            isSelected: viewModel.selectedPattern?.id == pattern.id
                        ) {
                            viewModel.selectedPattern = pattern
                        }
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
                
                NavigationLink(destination: CodingScreen(viewModel: viewModel, problem: problem)) {
                    HStack {
                        Text("Next: Write Code")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedPattern != nil ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(viewModel.selectedPattern == nil)
            }
            .padding()
        }
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
