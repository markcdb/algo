//
//  Attempt.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

struct Attempt: Identifiable, Codable {
    let id: UUID
    let problemId: UUID
    let createdAt: Date
    let userCode: String
    let selfRating: AttemptRating
    let durationSeconds: Int
    
    init(
        problemId: UUID,
        userCode: String,
        selfRating: AttemptRating,
        durationSeconds: Int
    ) {
        self.id = UUID()
        self.problemId = problemId
        self.createdAt = Date()
        self.userCode = userCode
        self.selfRating = selfRating
        self.durationSeconds = durationSeconds
    }
}
