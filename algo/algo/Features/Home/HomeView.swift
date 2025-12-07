//
//  HomeView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero Section
                heroSection
                
                // Pattern Mastery
                if !viewModel.patternMastery.isEmpty {
                    patternMasterySection
                }
                
                // Error Message
                if let error = viewModel.errorMessage {
                    errorView(error)
                }
            }
            .padding()
        }
        .navigationTitle("Algorithm Study")
        .task {
            await viewModel.loadData()
        }
        .refreshable {
            await viewModel.loadData()
        }
    }
    
    private var heroSection: some View {
        VStack(spacing: 16) {
            // Primary CTA
            PrimaryButton(title: "Start 5-Minute Drill 🚀") {
                Task {
                    await viewModel.startDrill()
                }
            }
            
            // Review CTA
            if viewModel.dueReviewsCount > 0 {
                Button(action: { viewModel.viewReviews() }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("\(viewModel.dueReviewsCount) problems due for review")
                            .font(.subheadline)
                    }
                    .foregroundColor(.orange)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var patternMasterySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pattern Mastery")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(viewModel.patternMastery, id: \.pattern.id) { mastery in
                PatternMasteryRow(
                    mastery: mastery,
                    color: viewModel.colorForMastery(mastery)
                ) {
                    viewModel.selectPattern(mastery.pattern)
                }
            }
        }
    }
    
    private func errorView(_ message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text(message)
                .font(.caption)
        }
        .foregroundColor(.red)
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
}

struct PatternMasteryRow: View {
    let mastery: PatternMastery
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mastery.pattern.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(mastery.pattern.shortDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(mastery.attemptedProblems)/\(mastery.totalProblems)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(color)
                        
                        TagView(
                            text: mastery.pattern.difficulty.displayName,
                            color: difficultyColor(mastery.pattern.difficulty)
                        )
                    }
                }
                
                ProgressBarView(
                    progress: mastery.masteryPercentage,
                    color: color
                )
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
    
    private func difficultyColor(_ difficulty: PatternDifficulty) -> Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

#Preview {
    HomeView(
        viewModel: HomeViewModel(
            router: MockRouter(),
            getDueReviewsUseCase: GetDueReviewsUseCase(
                reviewScheduleRepository: InMemoryReviewScheduleRepository(),
                problemRepository: InMemoryProblemRepository()
            ),
            getPatternOverviewUseCase: GetPatternOverviewUseCase(
                problemRepository: InMemoryProblemRepository(),
                attemptRepository: InMemoryAttemptRepository()
            ),
            startDrillUseCase: StartDrillUseCase(
                problemRepository: InMemoryProblemRepository(),
                reviewScheduleRepository: InMemoryReviewScheduleRepository()
            )
        )
    )
}
