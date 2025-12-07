//
//  DrillView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct DrillView: View {
    @StateObject var viewModel: DrillViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading problem...")
            } else if let problem = viewModel.problem {
                currentStepView(problem: problem)
            } else if let error = viewModel.errorMessage {
                errorView(error)
            }
        }
        .navigationTitle(stepTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            if viewModel.currentStep != .tutorial {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(viewModel.elapsedTime)
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
            }
        }
        .task {
            await viewModel.loadProblem()
        }
    }
    
    @ViewBuilder
    private func currentStepView(problem: Problem) -> some View {
        switch viewModel.currentStep {
        case .tutorial:
            if let tutorial = viewModel.tutorial {
                PatternTutorialView(tutorial: tutorial) {
                    viewModel.completeTutorial()
                }
            } else {
                PatternRecognitionView(viewModel: viewModel, problem: problem)
            }
        case .patternRecognition:
            PatternRecognitionView(viewModel: viewModel, problem: problem)
        case .coding:
            CodingScreen(viewModel: viewModel, problem: problem)
        case .comparison:
            ComparisonView(viewModel: viewModel, problem: problem)
        case .rating:
            RatingView(viewModel: viewModel, problem: problem)
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            PrimaryButton(title: "Try Again") {
                Task {
                    await viewModel.loadProblem()
                }
            }
        }
        .padding()
    }
    
    private var stepTitle: String {
        switch viewModel.currentStep {
        case .tutorial: return "Pattern Tutorial"
        case .patternRecognition: return "Pattern Recognition"
        case .coding: return "Solve"
        case .comparison: return "Review"
        case .rating: return "Rate Difficulty"
        }
    }
}

// MARK: - Formatted Problem Prompt
struct FormattedProblemPrompt: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(parseSections(), id: \.self) { section in
                sectionView(for: section)
            }
        }
    }
    
    private func parseSections() -> [String] {
        // Split by common problem sections
        let sections = text.components(separatedBy: "\n\n")
        return sections.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    @ViewBuilder
    private func sectionView(for section: String) -> some View {
        let trimmed = section.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.starts(with: "Example") {
            // Example section with light blue background
            VStack(alignment: .leading, spacing: 6) {
                Text(extractExampleTitle(from: trimmed))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Text(extractExampleContent(from: trimmed))
                    .font(.system(.body, design: .monospaced))
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(6)
            }
        } else if trimmed.starts(with: "Constraints:") || trimmed.starts(with: "Note:") {
            // Constraints or notes in smaller italic text
            Text(trimmed)
                .font(.caption)
                .italic()
                .foregroundColor(.secondary)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.tertiarySystemBackground))
                .cornerRadius(6)
        } else {
            // Regular description text with good line spacing
            Text(trimmed)
                .font(.body)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func extractExampleTitle(from text: String) -> String {
        let lines = text.components(separatedBy: "\n")
        return lines.first ?? ""
    }
    
    private func extractExampleContent(from text: String) -> String {
        let lines = text.components(separatedBy: "\n")
        return lines.dropFirst().joined(separator: "\n")
    }
}

// MARK: - Step 1: Pattern Recognition
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

// MARK: - Step 3: Comparison
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

// MARK: - Step 4: Rating
struct RatingView: View {
    @ObservedObject var viewModel: DrillViewModel
    let problem: Problem
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Header
            VStack(spacing: 12) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.green)
                
                Text("How was it?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Rate the difficulty to schedule your next review")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Rating options
            VStack(spacing: 12) {
                ForEach(AttemptRating.allCases, id: \.self) { rating in
                    RatingButton(
                        rating: rating,
                        isSelected: viewModel.selectedRating == rating
                    ) {
                        viewModel.selectedRating = rating
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Submit button
            PrimaryButton(
                title: "Complete Drill",
                action: {
                    Task {
                        await viewModel.submitRating()
                    }
                },
                isEnabled: viewModel.selectedRating != nil
            )
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct RatingButton: View {
    let rating: AttemptRating
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(rating.displayName)
                        .font(.headline)
                    Text("Review in \(rating.nextReviewDays) day\(rating.nextReviewDays == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(colorForRating(rating))
                }
            }
            .padding()
            .background(isSelected ? colorForRating(rating).opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    private func colorForRating(_ rating: AttemptRating) -> Color {
        switch rating {
        case .easy: return .green
        case .medium: return .blue
        case .hard: return .orange
        case .gaveUp: return .red
        }
    }
}

#Preview {
    DrillView(
        viewModel: DrillViewModel(
            startDrillUseCase: StartDrillUseCase(
                problemRepository: InMemoryProblemRepository(),
                reviewScheduleRepository: InMemoryReviewScheduleRepository()
            ),
            completeAttemptUseCase: CompleteAttemptUseCase(
                attemptRepository: InMemoryAttemptRepository(),
                reviewScheduleRepository: InMemoryReviewScheduleRepository()
            )
        )
    )
}
