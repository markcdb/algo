//
//  AppCoordinator.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case home
    case drillPatternRecognition(problem: Problem, tutorial: PatternTutorial?, startTime: Date)
    case drillCoding(problem: Problem, selectedPattern: PatternType, startTime: Date)
    case drillComparison(problem: Problem, selectedPattern: PatternType, userCode: String, selectedLanguage: SupportedLanguage, startTime: Date)
    case drillRating(problem: Problem, selectedPattern: PatternType, userCode: String, selectedLanguage: SupportedLanguage, startTime: Date)
    case reviewQueue
    case patternDetail(PatternType)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    
    // Dependencies (repositories and use cases)
    let problemRepository: ProblemRepository
    let attemptRepository: AttemptRepository
    let reviewScheduleRepository: ReviewScheduleRepository
    
    let startDrillUseCase: StartDrillUseCase
    let completeAttemptUseCase: CompleteAttemptUseCase
    let getDueReviewsUseCase: GetDueReviewsUseCase
    let getPatternOverviewUseCase: GetPatternOverviewUseCase
    
    init() {
        // Initialize repositories
        self.problemRepository = InMemoryProblemRepository()
        self.attemptRepository = InMemoryAttemptRepository()
        self.reviewScheduleRepository = InMemoryReviewScheduleRepository()
        
        // Initialize use cases
        self.startDrillUseCase = StartDrillUseCase(
            problemRepository: problemRepository,
            reviewScheduleRepository: reviewScheduleRepository
        )
        
        self.completeAttemptUseCase = CompleteAttemptUseCase(
            attemptRepository: attemptRepository,
            reviewScheduleRepository: reviewScheduleRepository
        )
        
        self.getDueReviewsUseCase = GetDueReviewsUseCase(
            reviewScheduleRepository: reviewScheduleRepository,
            problemRepository: problemRepository
        )
        
        self.getPatternOverviewUseCase = GetPatternOverviewUseCase(
            problemRepository: problemRepository,
            attemptRepository: attemptRepository
        )
    }
    
    // MARK: - Navigation Actions
    
    func showReviewQueue() {
        navigationPath.append(AppRoute.reviewQueue)
    }
    
    func showPatternDetail(_ pattern: PatternType) {
        navigationPath.append(AppRoute.patternDetail(pattern))
    }
    
    func popToRoot() {
        navigationPath.removeLast(navigationPath.count)
    }
    
    // MARK: - View Model Factories
    
    func makeHomeViewModel() -> HomeViewModel {
        let viewModel = HomeViewModel(
            router: self,
            getDueReviewsUseCase: getDueReviewsUseCase,
            getPatternOverviewUseCase: getPatternOverviewUseCase,
            startDrillUseCase: startDrillUseCase
        )
        return viewModel
    }
    
    func makePatternRecognitionViewModel(problem: Problem, startTime: Date) -> PatternRecognitionViewModel {
        return PatternRecognitionViewModel(
            problem: problem,
            startTime: startTime,
            router: self
        )
    }
    
    func makeCodingViewModel(problem: Problem, selectedPattern: PatternType, startTime: Date) -> CodingViewModel {
        return CodingViewModel(
            problem: problem,
            selectedPattern: selectedPattern,
            startTime: startTime,
            router: self
        )
    }
    
    func makeComparisonViewModel(
        problem: Problem,
        selectedPattern: PatternType,
        userCode: String,
        selectedLanguage: SupportedLanguage,
        startTime: Date
    ) -> ComparisonViewModel {
        return ComparisonViewModel(
            problem: problem,
            selectedPattern: selectedPattern,
            userCode: userCode,
            selectedLanguage: selectedLanguage,
            startTime: startTime,
            router: self
        )
    }
    
    func makeRatingViewModel(
        problem: Problem,
        selectedPattern: PatternType,
        userCode: String,
        selectedLanguage: SupportedLanguage,
        startTime: Date
    ) -> RatingViewModel {
        return RatingViewModel(
            problem: problem,
            selectedPattern: selectedPattern,
            userCode: userCode,
            selectedLanguage: selectedLanguage,
            startTime: startTime,
            router: self,
            completeAttemptUseCase: completeAttemptUseCase
        )
    }
}

// MARK: - AppRouting Conformance
extension AppCoordinator: AppRouting {
    func push(_ route: AppRoute) {
        navigationPath.append(route)
    }
    
    func pop() {
        if !navigationPath.isEmpty {
            navigationPath.removeLast()
        }
    }
}
