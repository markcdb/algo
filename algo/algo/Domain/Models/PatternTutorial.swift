//
//  PatternTutorial.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Represents a visual step-by-step tutorial for understanding an algorithm pattern
struct PatternTutorial: Codable {
    let patternId: UUID
    let steps: [TutorialStep]
    let keyInsights: [String]
    let whenToUse: String
    let timeComplexity: String
    let spaceComplexity: String
}

struct TutorialStep: Codable, Identifiable {
    let id: UUID
    let title: String
    let explanation: String
    let visualization: VisualizationData
    let code: String?  // Optional code snippet for this step
    
    init(
        title: String,
        explanation: String,
        visualization: VisualizationData,
        code: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.explanation = explanation
        self.visualization = visualization
        self.code = code
    }
}

/// Visual representation data for each step
struct VisualizationData: Codable {
    let type: VisualizationType
    let elements: [VisualElement]
    let highlights: [Int]  // Indices to highlight
    let pointers: [PointerData]
}

enum VisualizationType: String, Codable {
    case array
    case window
    case twoPointer
    case tree
    case graph
    case hashMap
}

struct VisualElement: Codable, Identifiable {
    let id: UUID
    let value: String
    let state: ElementState
    
    init(value: String, state: ElementState = .normal) {
        self.id = UUID()
        self.value = value
        self.state = state
    }
}

enum ElementState: String, Codable {
    case normal
    case active
    case visited
    case result
    case excluded
}

struct PointerData: Codable, Identifiable {
    let id: UUID
    let name: String
    let index: Int
    let color: String
    
    init(name: String, index: Int, color: String) {
        self.id = UUID()
        self.name = name
        self.index = index
        self.color = color
    }
}
