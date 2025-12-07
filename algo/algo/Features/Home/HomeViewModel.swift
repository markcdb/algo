//
//  HomeViewModel.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var dueReviewsCount: Int = 0
    @Published var patternMastery: [PatternMastery] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getDueReviewsUseCase: GetDueReviewsUseCase
    private let getPatternOverviewUseCase: GetPatternOverviewUseCase
    
    var onStartDrill: (() -> Void)?
    var onViewReviews: (() -> Void)?
    var onSelectPattern: ((PatternType) -> Void)?
    
    init(
        getDueReviewsUseCase: GetDueReviewsUseCase,
        getPatternOverviewUseCase: GetPatternOverviewUseCase
    ) {
        self.getDueReviewsUseCase = getDueReviewsUseCase
        self.getPatternOverviewUseCase = getPatternOverviewUseCase
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Load due reviews count
            dueReviewsCount = try await getDueReviewsUseCase.getDueReviewsCount()
            
            // Load pattern mastery
            patternMastery = try await getPatternOverviewUseCase.getPatternMastery()
            
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func startDrill() {
        onStartDrill?()
    }
    
    func viewReviews() {
        onViewReviews?()
    }
    
    func selectPattern(_ pattern: PatternType) {
        onSelectPattern?(pattern)
    }
    
    func colorForMastery(_ mastery: PatternMastery) -> Color {
        let percentage = mastery.masteryPercentage
        if percentage >= 0.75 {
            return .green
        } else if percentage >= 0.5 {
            return .blue
        } else if percentage >= 0.25 {
            return .orange
        } else {
            return .gray
        }
    }
}
