//
//  TutorialData.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Pre-loaded tutorials for each pattern
extension PatternTutorial {
    
    // MARK: - Sliding Window Tutorial
    static func slidingWindowTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.slidingWindow.id,
            steps: [
                TutorialStep(
                    title: "The Problem",
                    explanation: "We want to find the maximum sum of 3 consecutive numbers in [2, 1, 5, 1, 3, 2]",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "2", state: .normal),
                            VisualElement(value: "1", state: .normal),
                            VisualElement(value: "5", state: .normal),
                            VisualElement(value: "1", state: .normal),
                            VisualElement(value: "3", state: .normal),
                            VisualElement(value: "2", state: .normal)
                        ],
                        highlights: [],
                        pointers: []
                    ),
                    code: nil
                ),
                
                TutorialStep(
                    title: "First Window",
                    explanation: "Create a window of size 3. Sum = 2 + 1 + 5 = 8",
                    visualization: VisualizationData(
                        type: .window,
                        elements: [
                            VisualElement(value: "2", state: .active),
                            VisualElement(value: "1", state: .active),
                            VisualElement(value: "5", state: .active),
                            VisualElement(value: "1", state: .normal),
                            VisualElement(value: "3", state: .normal),
                            VisualElement(value: "2", state: .normal)
                        ],
                        highlights: [0, 1, 2],
                        pointers: [
                            PointerData(name: "window", index: 0, color: "blue")
                        ]
                    ),
                    code: "windowSum = arr[0] + arr[1] + arr[2]  // 8"
                ),
                
                TutorialStep(
                    title: "Slide Right",
                    explanation: "Remove leftmost (2), add next element (1). Sum = 8 - 2 + 1 = 7",
                    visualization: VisualizationData(
                        type: .window,
                        elements: [
                            VisualElement(value: "2", state: .excluded),
                            VisualElement(value: "1", state: .active),
                            VisualElement(value: "5", state: .active),
                            VisualElement(value: "1", state: .active),
                            VisualElement(value: "3", state: .normal),
                            VisualElement(value: "2", state: .normal)
                        ],
                        highlights: [1, 2, 3],
                        pointers: [
                            PointerData(name: "window", index: 1, color: "blue")
                        ]
                    ),
                    code: "windowSum = windowSum - arr[0] + arr[3]  // 7"
                ),
                
                TutorialStep(
                    title: "Keep Sliding",
                    explanation: "Remove 1, add 3. Sum = 7 - 1 + 3 = 9 ← Maximum!",
                    visualization: VisualizationData(
                        type: .window,
                        elements: [
                            VisualElement(value: "2", state: .excluded),
                            VisualElement(value: "1", state: .excluded),
                            VisualElement(value: "5", state: .result),
                            VisualElement(value: "1", state: .result),
                            VisualElement(value: "3", state: .result),
                            VisualElement(value: "2", state: .normal)
                        ],
                        highlights: [2, 3, 4],
                        pointers: [
                            PointerData(name: "window", index: 2, color: "green")
                        ]
                    ),
                    code: "windowSum = windowSum - arr[1] + arr[4]  // 9"
                ),
                
                TutorialStep(
                    title: "Final Slide",
                    explanation: "Remove 5, add 2. Sum = 9 - 5 + 2 = 6. Maximum stays 9.",
                    visualization: VisualizationData(
                        type: .window,
                        elements: [
                            VisualElement(value: "2", state: .excluded),
                            VisualElement(value: "1", state: .excluded),
                            VisualElement(value: "5", state: .excluded),
                            VisualElement(value: "1", state: .active),
                            VisualElement(value: "3", state: .active),
                            VisualElement(value: "2", state: .active)
                        ],
                        highlights: [3, 4, 5],
                        pointers: [
                            PointerData(name: "window", index: 3, color: "blue")
                        ]
                    ),
                    code: "maxSum = 9  // Answer found!"
                )
            ],
            keyInsights: [
                "🪟 Maintain a fixed or variable-size window",
                "➡️ Slide efficiently - don't recalculate everything",
                "⚡️ O(n) time instead of O(n*k) brute force",
                "💡 Works great for substring/subarray problems"
            ],
            whenToUse: "Use when you need to find something in a contiguous sequence (substring, subarray) and you're asked to optimize or find max/min.",
            timeComplexity: "O(n) - single pass through array",
            spaceComplexity: "O(1) - only tracking window state"
        )
    }
    
    // MARK: - Two Pointers Tutorial
    static func twoPointersTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.twoPointers.id,
            steps: [
                TutorialStep(
                    title: "The Problem",
                    explanation: "Find two numbers in sorted array [2, 7, 11, 15] that sum to 9",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "2", state: .normal),
                            VisualElement(value: "7", state: .normal),
                            VisualElement(value: "11", state: .normal),
                            VisualElement(value: "15", state: .normal)
                        ],
                        highlights: [],
                        pointers: []
                    ),
                    code: nil
                ),
                
                TutorialStep(
                    title: "Start with Two Pointers",
                    explanation: "Place LEFT at start, RIGHT at end. Check sum: 2 + 15 = 17 (too big!)",
                    visualization: VisualizationData(
                        type: .twoPointer,
                        elements: [
                            VisualElement(value: "2", state: .active),
                            VisualElement(value: "7", state: .normal),
                            VisualElement(value: "11", state: .normal),
                            VisualElement(value: "15", state: .active)
                        ],
                        highlights: [0, 3],
                        pointers: [
                            PointerData(name: "LEFT", index: 0, color: "blue"),
                            PointerData(name: "RIGHT", index: 3, color: "red")
                        ]
                    ),
                    code: "sum = arr[left] + arr[right]  // 17 > 9"
                ),
                
                TutorialStep(
                    title: "Sum Too Large? Move RIGHT Left",
                    explanation: "17 > 9, so move RIGHT pointer left. Now: 2 + 11 = 13 (still too big)",
                    visualization: VisualizationData(
                        type: .twoPointer,
                        elements: [
                            VisualElement(value: "2", state: .active),
                            VisualElement(value: "7", state: .normal),
                            VisualElement(value: "11", state: .active),
                            VisualElement(value: "15", state: .excluded)
                        ],
                        highlights: [0, 2],
                        pointers: [
                            PointerData(name: "LEFT", index: 0, color: "blue"),
                            PointerData(name: "RIGHT", index: 2, color: "red")
                        ]
                    ),
                    code: "right -= 1  // sum = 13, still too big"
                ),
                
                TutorialStep(
                    title: "Found It!",
                    explanation: "Move RIGHT again: 2 + 7 = 9 ✓ Perfect match!",
                    visualization: VisualizationData(
                        type: .twoPointer,
                        elements: [
                            VisualElement(value: "2", state: .result),
                            VisualElement(value: "7", state: .result),
                            VisualElement(value: "11", state: .excluded),
                            VisualElement(value: "15", state: .excluded)
                        ],
                        highlights: [0, 1],
                        pointers: [
                            PointerData(name: "LEFT", index: 0, color: "green"),
                            PointerData(name: "RIGHT", index: 1, color: "green")
                        ]
                    ),
                    code: "return [left, right]  // Found [2, 7]!"
                )
            ],
            keyInsights: [
                "👈👉 Use two pointers moving toward each other",
                "📊 Works best on SORTED arrays",
                "⚡️ O(n) time - each pointer moves once",
                "🎯 Move left if sum too small, right if too big"
            ],
            whenToUse: "Use when dealing with sorted arrays and you need to find pairs/triplets, or when you need to partition data.",
            timeComplexity: "O(n) - linear scan with two pointers",
            spaceComplexity: "O(1) - only pointer variables"
        )
    }
    
    // MARK: - Binary Search Tutorial
    static func binarySearchTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.binarySearch.id,
            steps: [
                TutorialStep(
                    title: "The Problem",
                    explanation: "Find number 9 in sorted array [-1, 0, 3, 5, 9, 12]",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "-1", state: .normal),
                            VisualElement(value: "0", state: .normal),
                            VisualElement(value: "3", state: .normal),
                            VisualElement(value: "5", state: .normal),
                            VisualElement(value: "9", state: .normal),
                            VisualElement(value: "12", state: .normal)
                        ],
                        highlights: [],
                        pointers: []
                    ),
                    code: nil
                ),
                
                TutorialStep(
                    title: "Check the Middle",
                    explanation: "Middle element is 3. Is 9 > 3? Yes! So search RIGHT half.",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "-1", state: .normal),
                            VisualElement(value: "0", state: .normal),
                            VisualElement(value: "3", state: .active),
                            VisualElement(value: "5", state: .normal),
                            VisualElement(value: "9", state: .normal),
                            VisualElement(value: "12", state: .normal)
                        ],
                        highlights: [2],
                        pointers: [
                            PointerData(name: "L", index: 0, color: "blue"),
                            PointerData(name: "M", index: 2, color: "purple"),
                            PointerData(name: "R", index: 5, color: "red")
                        ]
                    ),
                    code: "mid = (0 + 5) / 2 = 2\narr[2] = 3 < 9"
                ),
                
                TutorialStep(
                    title: "Eliminate Left Half",
                    explanation: "Discard everything left of middle. New range: [5, 9, 12]",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "-1", state: .excluded),
                            VisualElement(value: "0", state: .excluded),
                            VisualElement(value: "3", state: .excluded),
                            VisualElement(value: "5", state: .normal),
                            VisualElement(value: "9", state: .normal),
                            VisualElement(value: "12", state: .normal)
                        ],
                        highlights: [3, 4, 5],
                        pointers: [
                            PointerData(name: "L", index: 3, color: "blue"),
                            PointerData(name: "R", index: 5, color: "red")
                        ]
                    ),
                    code: "left = mid + 1  // Search [3..5]"
                ),
                
                TutorialStep(
                    title: "Check New Middle",
                    explanation: "New middle is 9. Found it! Return index 4.",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "-1", state: .excluded),
                            VisualElement(value: "0", state: .excluded),
                            VisualElement(value: "3", state: .excluded),
                            VisualElement(value: "5", state: .excluded),
                            VisualElement(value: "9", state: .result),
                            VisualElement(value: "12", state: .excluded)
                        ],
                        highlights: [4],
                        pointers: [
                            PointerData(name: "M", index: 4, color: "green")
                        ]
                    ),
                    code: "mid = (3 + 5) / 2 = 4\narr[4] = 9 ✓ Found!"
                )
            ],
            keyInsights: [
                "✂️ Cut search space in HALF each step",
                "📊 Only works on SORTED data",
                "🚀 O(log n) - incredibly fast!",
                "🎯 Compare middle, then go left or right"
            ],
            whenToUse: "Use when searching in sorted data, or when you can binary search on the answer space (like 'minimum speed to eat bananas').",
            timeComplexity: "O(log n) - halving each iteration",
            spaceComplexity: "O(1) - iterative version"
        )
    }
    
    // MARK: - Get Tutorial for Pattern
    static func tutorial(for pattern: PatternType) -> PatternTutorial? {
        switch pattern.name {
        case "Sliding Window":
            return slidingWindowTutorial()
        case "Two Pointers":
            return twoPointersTutorial()
        case "Binary Search":
            return binarySearchTutorial()
        default:
            return nil
        }
    }
}
