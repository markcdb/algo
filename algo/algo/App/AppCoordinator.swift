//
//  AppCoordinator.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case home
    case drill
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
    
    func startDrill() {
        navigationPath.append(AppRoute.drill)
    }
    
    func dismissDrill() {
        navigationPath.removeLast()
    }
    
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
            getDueReviewsUseCase: getDueReviewsUseCase,
            getPatternOverviewUseCase: getPatternOverviewUseCase
        )
        
        viewModel.onStartDrill = { [weak self] in
            self?.startDrill()
        }
        
        viewModel.onViewReviews = { [weak self] in
            self?.showReviewQueue()
        }
        
        viewModel.onSelectPattern = { [weak self] pattern in
            self?.showPatternDetail(pattern)
        }
        
        return viewModel
    }
    
    func makeDrillViewModel() -> DrillViewModel {
        let viewModel = DrillViewModel(
            startDrillUseCase: startDrillUseCase,
            completeAttemptUseCase: completeAttemptUseCase
        )
        
        viewModel.onComplete = { [weak self] in
            self?.dismissDrill()
        }
        
        return viewModel
    }
}
