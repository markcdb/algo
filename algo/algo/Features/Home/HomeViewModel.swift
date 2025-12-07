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
    @Published var showTutorial: Bool = true  // Can be toggled in settings
    
    private let router: AppRouting
    private let getDueReviewsUseCase: GetDueReviewsUseCase
    private let getPatternOverviewUseCase: GetPatternOverviewUseCase
    private let startDrillUseCase: StartDrillUseCase
    
    init(
        router: AppRouting,
        getDueReviewsUseCase: GetDueReviewsUseCase,
        getPatternOverviewUseCase: GetPatternOverviewUseCase,
        startDrillUseCase: StartDrillUseCase
    ) {
        self.router = router
        self.getDueReviewsUseCase = getDueReviewsUseCase
        self.getPatternOverviewUseCase = getPatternOverviewUseCase
        self.startDrillUseCase = startDrillUseCase
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
    
    func startDrill() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let problem = try await startDrillUseCase.getNextProblem()
            
            guard let problem = problem else {
                errorMessage = "No problems available"
                isLoading = false
                return
            }
            
            let tutorial = PatternTutorial.tutorial(for: problem.pattern)
            let startTime = Date()
            
            isLoading = false
            
            // Navigate directly to first drill step (with tutorial if enabled)
            router.push(.drillPatternRecognition(
                problem: problem,
                tutorial: showTutorial ? tutorial : nil,
                startTime: startTime
            ))
        } catch {
            errorMessage = "Failed to load problem: \(error.localizedDescription)"
            isLoading = false
        }
    }
    
    func viewReviews() {
        router.push(.reviewQueue)
    }
    
    func selectPattern(_ pattern: PatternType) {
        router.push(.patternDetail(pattern))
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
