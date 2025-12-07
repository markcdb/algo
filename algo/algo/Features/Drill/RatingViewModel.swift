//
//  RatingViewModel.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

@MainActor
class RatingViewModel: ObservableObject {
    @Published var selectedRating: AttemptRating?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let problem: Problem
    let selectedPattern: PatternType
    let userCode: String
    let selectedLanguage: SupportedLanguage
    let startTime: Date
    private let router: AppRouting
    private let completeAttemptUseCase: CompleteAttemptUseCase
    
    init(
        problem: Problem,
        selectedPattern: PatternType,
        userCode: String,
        selectedLanguage: SupportedLanguage,
        startTime: Date,
        router: AppRouting,
        completeAttemptUseCase: CompleteAttemptUseCase
    ) {
        self.problem = problem
        self.selectedPattern = selectedPattern
        self.userCode = userCode
        self.selectedLanguage = selectedLanguage
        self.startTime = startTime
        self.router = router
        self.completeAttemptUseCase = completeAttemptUseCase
    }
    
    var elapsedTime: String {
        let duration = Int(Date().timeIntervalSince(startTime))
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func submitRating() async {
        guard let rating = selectedRating else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let duration = Int(Date().timeIntervalSince(startTime))
            
            try await completeAttemptUseCase.completeAttempt(
                problemId: problem.id,
                userCode: userCode,
                rating: rating,
                durationSeconds: duration
            )
            
            // Pop back to home (removes all drill screens)
            router.popToRoot()
        } catch {
            errorMessage = "Failed to save attempt: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
