//
//  algoApp.swift
//  algo
//
//  Created by Mark Buot on 4/12/25.
//

import SwiftUI

@main
struct algoApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                HomeView(viewModel: coordinator.makeHomeViewModel())
                    .navigationDestination(for: AppRoute.self) { route in
                        destinationView(for: route)
                    }
            }
            .environmentObject(coordinator)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: coordinator.makeHomeViewModel())
        case .drillPatternRecognition(let problem, let tutorial, let startTime):
            if let tutorial = tutorial {
                PatternTutorialView(tutorial: tutorial) {
                    // After tutorial, navigate to pattern recognition
                    coordinator.push(.drillPatternRecognition(
                        problem: problem,
                        tutorial: nil,
                        startTime: startTime
                    ))
                }
            } else {
                PatternRecognitionView(
                    viewModel: coordinator.makePatternRecognitionViewModel(
                        problem: problem,
                        startTime: startTime
                    )
                )
            }
        case .drillCoding(let problem, let selectedPattern, let startTime):
            CodingScreen(
                viewModel: coordinator.makeCodingViewModel(
                    problem: problem,
                    selectedPattern: selectedPattern,
                    startTime: startTime
                )
            )
        case .drillComparison(let problem, let selectedPattern, let userCode, let selectedLanguage, let startTime):
            ComparisonView(
                viewModel: coordinator.makeComparisonViewModel(
                    problem: problem,
                    selectedPattern: selectedPattern,
                    userCode: userCode,
                    selectedLanguage: selectedLanguage,
                    startTime: startTime
                )
            )
        case .drillRating(let problem, let selectedPattern, let userCode, let selectedLanguage, let startTime):
            RatingView(
                viewModel: coordinator.makeRatingViewModel(
                    problem: problem,
                    selectedPattern: selectedPattern,
                    userCode: userCode,
                    selectedLanguage: selectedLanguage,
                    startTime: startTime
                )
            )
        case .reviewQueue:
            Text("Review Queue - Coming Soon")
        case .patternDetail(let pattern):
            Text("Pattern: \(pattern.name) - Coming Soon")
        }
    }
}
