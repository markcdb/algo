//
//  RatingStep.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import SwiftUI

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
