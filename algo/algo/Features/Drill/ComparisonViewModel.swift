//
//  ComparisonViewModel.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

@MainActor
class ComparisonViewModel: ObservableObject {
    let problem: Problem
    let selectedPattern: PatternType
    let userCode: String
    let selectedLanguage: SupportedLanguage
    let startTime: Date
    private let router: AppRouting
    
    var patternMatches: Bool {
        selectedPattern == problem.pattern
    }
    
    init(
        problem: Problem,
        selectedPattern: PatternType,
        userCode: String,
        selectedLanguage: SupportedLanguage,
        startTime: Date,
        router: AppRouting
    ) {
        self.problem = problem
        self.selectedPattern = selectedPattern
        self.userCode = userCode
        self.selectedLanguage = selectedLanguage
        self.startTime = startTime
        self.router = router
    }
    
    func proceedToRating() {
        router.push(.drillRating(
            problem: problem,
            selectedPattern: selectedPattern,
            userCode: userCode,
            selectedLanguage: selectedLanguage,
            startTime: startTime
        ))
    }
}
