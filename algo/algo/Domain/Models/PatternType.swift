//
//  PatternType.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

struct PatternType: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let shortDescription: String
    let difficulty: PatternDifficulty
    
    init(
        name: String,
        shortDescription: String,
        difficulty: PatternDifficulty
    ) {
        self.id = UUID()
        self.name = name
        self.shortDescription = shortDescription
        self.difficulty = difficulty
    }
}

// MARK: - Common Patterns
extension PatternType {
    static let slidingWindow = PatternType(
        name: "Sliding Window",
        shortDescription: "Maintain a window of elements while traversing",
        difficulty: .beginner
    )
    
    static let twoPointers = PatternType(
        name: "Two Pointers",
        shortDescription: "Use two pointers moving toward or away from each other",
        difficulty: .beginner
    )
    
    static let binarySearch = PatternType(
        name: "Binary Search",
        shortDescription: "Divide search space in half repeatedly",
        difficulty: .intermediate
    )
    
    static let heap = PatternType(
        name: "Heap",
        shortDescription: "Use priority queue for efficient min/max operations",
        difficulty: .intermediate
    )
    
    static let graphBFS = PatternType(
        name: "Graph BFS",
        shortDescription: "Breadth-first traversal for shortest paths",
        difficulty: .advanced
    )
    
    static let graphDFS = PatternType(
        name: "Graph DFS",
        shortDescription: "Depth-first traversal for exhaustive search",
        difficulty: .advanced
    )
    
    static let intervals = PatternType(
        name: "Intervals",
        shortDescription: "Merge, insert, or find overlapping intervals",
        difficulty: .intermediate
    )
    
    static let dynamicProgramming = PatternType(
        name: "Dynamic Programming",
        shortDescription: "Break down into overlapping subproblems",
        difficulty: .advanced
    )
    
    static let allPatterns: [PatternType] = [
        .slidingWindow,
        .twoPointers,
        .binarySearch,
        .heap,
        .graphBFS,
        .graphDFS,
        .intervals,
        .dynamicProgramming
    ]
}
