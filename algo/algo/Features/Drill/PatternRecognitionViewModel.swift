//
//  PatternRecognitionViewModel.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

@MainActor
class PatternRecognitionViewModel: ObservableObject {
    @Published var selectedPattern: PatternType?
    @Published var userApproach: String = ""
    
    let problem: Problem
    let startTime: Date
    private let router: AppRouting
    
    init(problem: Problem, startTime: Date, router: AppRouting) {
        self.problem = problem
        self.startTime = startTime
        self.router = router
    }
    
    var patternMatches: Bool {
        guard let selected = selectedPattern else { return false }
        return problem.pattern.id == selected.id
    }
    
    func submitPatternSelection() {
        guard let selectedPattern = selectedPattern else { return }
        router.push(.drillCoding(
            problem: problem,
            selectedPattern: selectedPattern,
            startTime: startTime
        ))
    }
}
