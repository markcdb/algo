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
            } else if let error = viewModel.errorMessage {
                errorView(error)
            }
        }
        .navigationTitle("Drill")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .task {
            await viewModel.loadAndStartDrill()
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
                    await viewModel.loadAndStartDrill()
                }
            }
        }
        .padding()
    }
}

// MARK: - FormattedProblemPrompt Helper
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

#Preview {
    DrillView(
        viewModel: DrillViewModel(
            router: MockRouter(),
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
