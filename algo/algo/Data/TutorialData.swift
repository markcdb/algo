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
    
    // MARK: - Heap Tutorial
    static func heapTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.heap.id,
            steps: [
                TutorialStep(
                    title: "What is a Heap?",
                    explanation: "A heap is a binary tree where parent nodes are always larger (max heap) or smaller (min heap) than children. Perfect for finding top K elements!",
                    visualization: VisualizationData(
                        type: .tree,
                        elements: [
                            VisualElement(value: "9", state: .active),
                            VisualElement(value: "7", state: .normal),
                            VisualElement(value: "5", state: .normal),
                            VisualElement(value: "4", state: .normal),
                            VisualElement(value: "3", state: .normal)
                        ],
                        highlights: [0],
                        pointers: [
                            PointerData(name: "root", index: 0, color: "blue")
                        ]
                    ),
                    code: "// Max heap - root is largest\nlet maxHeap = [9, 7, 5, 4, 3]"
                ),
                
                TutorialStep(
                    title: "Finding Top 3 Numbers",
                    explanation: "To find top 3 from [3, 1, 5, 12, 2, 11]: Use a MIN heap of size 3. Keep only the 3 largest!",
                    visualization: VisualizationData(
                        type: .heap,
                        elements: [
                            VisualElement(value: "5", state: .active),
                            VisualElement(value: "11", state: .active),
                            VisualElement(value: "12", state: .active)
                        ],
                        highlights: [0, 1, 2],
                        pointers: [
                            PointerData(name: "min", index: 0, color: "red")
                        ]
                    ),
                    code: "var heap = MinHeap(maxSize: 3)\nfor num in nums {\n    heap.insert(num)\n    if heap.count > 3 {\n        heap.removeMin() // Remove smallest\n    }\n}"
                ),
                
                TutorialStep(
                    title: "Insert & Remove",
                    explanation: "Insert: O(log k). Remove min/max: O(log k). Perfect for streaming data where k << n!",
                    visualization: VisualizationData(
                        type: .heap,
                        elements: [
                            VisualElement(value: "12", state: .result),
                            VisualElement(value: "11", state: .result),
                            VisualElement(value: "5", state: .result)
                        ],
                        highlights: [0, 1, 2],
                        pointers: []
                    ),
                    code: "// Final top 3: [12, 11, 5]\nreturn heap.sorted().reversed()"
                )
            ],
            keyInsights: [
                "🏔️ Min heap for top K largest (counterintuitive!)",
                "⚡ O(n log k) - much better than O(n log n) sorting",
                "📊 Perfect for streaming data or limited memory"
            ],
            whenToUse: "Use heap for 'top K' problems, kth largest/smallest, merge K sorted lists, or maintaining running median.",
            timeComplexity: "O(n log k) where k is heap size",
            spaceComplexity: "O(k) for the heap"
        )
    }
    
    // MARK: - Graph BFS Tutorial
    static func graphBFSTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.graphBFS.id,
            steps: [
                TutorialStep(
                    title: "BFS: Level by Level",
                    explanation: "BFS explores neighbors first, like ripples in water. Use a QUEUE to track nodes to visit.",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .active),
                            VisualElement(value: "B", state: .normal),
                            VisualElement(value: "C", state: .normal),
                            VisualElement(value: "D", state: .normal),
                            VisualElement(value: "E", state: .normal)
                        ],
                        highlights: [0],
                        pointers: [
                            PointerData(name: "start", index: 0, color: "blue")
                        ]
                    ),
                    code: "// Start at node A\nqueue = [A]\nvisited = {A}"
                ),
                
                TutorialStep(
                    title: "Explore Level 1",
                    explanation: "Visit A's neighbors (B, C). Add them to queue. This guarantees shortest path!",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .visited),
                            VisualElement(value: "B", state: .active),
                            VisualElement(value: "C", state: .active),
                            VisualElement(value: "D", state: .normal),
                            VisualElement(value: "E", state: .normal)
                        ],
                        highlights: [1, 2],
                        pointers: [
                            PointerData(name: "level 1", index: 1, color: "green")
                        ]
                    ),
                    code: "queue = [B, C]\nvisited = {A, B, C}\ndistance[B] = 1\ndistance[C] = 1"
                ),
                
                TutorialStep(
                    title: "Continue Level by Level",
                    explanation: "Process B's neighbors (D), then C's neighbors (E). Queue ensures we visit closest nodes first!",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .visited),
                            VisualElement(value: "B", state: .visited),
                            VisualElement(value: "C", state: .visited),
                            VisualElement(value: "D", state: .active),
                            VisualElement(value: "E", state: .active)
                        ],
                        highlights: [3, 4],
                        pointers: [
                            PointerData(name: "level 2", index: 3, color: "orange")
                        ]
                    ),
                    code: "queue = [D, E]\ndistance[D] = 2\ndistance[E] = 2"
                )
            ],
            keyInsights: [
                "🌊 QUEUE = level-by-level exploration",
                "📏 Finds SHORTEST PATH in unweighted graphs",
                "✅ Track visited nodes to avoid cycles"
            ],
            whenToUse: "Use BFS for shortest path in unweighted graphs, level-order traversal, or 'minimum steps' problems.",
            timeComplexity: "O(V + E) - visit each vertex and edge once",
            spaceComplexity: "O(V) for queue and visited set"
        )
    }
    
    // MARK: - Graph DFS Tutorial
    static func graphDFSTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.graphDFS.id,
            steps: [
                TutorialStep(
                    title: "DFS: Go Deep First",
                    explanation: "DFS explores as far as possible before backtracking. Use a STACK (or recursion) to track path.",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .active),
                            VisualElement(value: "B", state: .normal),
                            VisualElement(value: "C", state: .normal),
                            VisualElement(value: "D", state: .normal),
                            VisualElement(value: "E", state: .normal)
                        ],
                        highlights: [0],
                        pointers: [
                            PointerData(name: "start", index: 0, color: "blue")
                        ]
                    ),
                    code: "// Start at A\nstack = [A]\nvisited = {A}"
                ),
                
                TutorialStep(
                    title: "Go Deep: A → B → D",
                    explanation: "Pick first neighbor (B), then go deeper (D). STACK tracks the path: [A, B, D]",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .visited),
                            VisualElement(value: "B", state: .visited),
                            VisualElement(value: "C", state: .normal),
                            VisualElement(value: "D", state: .active),
                            VisualElement(value: "E", state: .normal)
                        ],
                        highlights: [3],
                        pointers: [
                            PointerData(name: "deep", index: 3, color: "red")
                        ]
                    ),
                    code: "// DFS path\nstack = [A, B, D]\nvisited = {A, B, D}"
                ),
                
                TutorialStep(
                    title: "Backtrack & Explore",
                    explanation: "D has no unvisited neighbors. Backtrack to B, then to A, then explore C → E. Stack unwinds naturally!",
                    visualization: VisualizationData(
                        type: .graph,
                        elements: [
                            VisualElement(value: "A", state: .visited),
                            VisualElement(value: "B", state: .visited),
                            VisualElement(value: "C", state: .visited),
                            VisualElement(value: "D", state: .visited),
                            VisualElement(value: "E", state: .active)
                        ],
                        highlights: [4],
                        pointers: [
                            PointerData(name: "backtrack", index: 4, color: "green")
                        ]
                    ),
                    code: "// Backtrack to A, then C\nstack = [A, C, E]\nvisited = {A, B, C, D, E}"
                )
            ],
            keyInsights: [
                "🏊 STACK = go deep, then backtrack",
                "🔍 Perfect for finding ALL paths or cycles",
                "💡 Recursion = implicit stack!"
            ],
            whenToUse: "Use DFS for detecting cycles, finding all paths, topological sort, or problems requiring full exploration.",
            timeComplexity: "O(V + E) - visit each vertex and edge once",
            spaceComplexity: "O(V) for recursion stack or explicit stack"
        )
    }
    
    // MARK: - Intervals Tutorial
    static func intervalsTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.intervals.id,
            steps: [
                TutorialStep(
                    title: "The Problem: Merge Overlapping",
                    explanation: "Given [[1,3], [2,6], [8,10], [15,18]], merge overlapping intervals.",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "[1,3]", state: .normal),
                            VisualElement(value: "[2,6]", state: .normal),
                            VisualElement(value: "[8,10]", state: .normal),
                            VisualElement(value: "[15,18]", state: .normal)
                        ],
                        highlights: [],
                        pointers: []
                    ),
                    code: "intervals = [[1,3], [2,6], [8,10], [15,18]]"
                ),
                
                TutorialStep(
                    title: "Step 1: Sort by Start",
                    explanation: "ALWAYS sort intervals by start time first! This makes overlap detection simple.",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "[1,3]", state: .active),
                            VisualElement(value: "[2,6]", state: .active),
                            VisualElement(value: "[8,10]", state: .normal),
                            VisualElement(value: "[15,18]", state: .normal)
                        ],
                        highlights: [0, 1],
                        pointers: [
                            PointerData(name: "overlap?", index: 0, color: "blue")
                        ]
                    ),
                    code: "// Already sorted\n// Check: does [1,3] overlap [2,6]?\n// Yes! 3 >= 2"
                ),
                
                TutorialStep(
                    title: "Step 2: Merge Overlapping",
                    explanation: "If intervals[i].end >= intervals[i+1].start, they overlap! Merge by taking max end.",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "[1,6]", state: .result),
                            VisualElement(value: "[8,10]", state: .normal),
                            VisualElement(value: "[15,18]", state: .normal)
                        ],
                        highlights: [0],
                        pointers: [
                            PointerData(name: "merged", index: 0, color: "green")
                        ]
                    ),
                    code: "merged = [[1,6]]\n// [1,3] + [2,6] = [1, max(3,6)] = [1,6]"
                ),
                
                TutorialStep(
                    title: "Continue: Non-overlapping",
                    explanation: "[8,10] doesn't overlap [1,6] (8 > 6), so add it separately. Same with [15,18].",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "[1,6]", state: .result),
                            VisualElement(value: "[8,10]", state: .result),
                            VisualElement(value: "[15,18]", state: .result)
                        ],
                        highlights: [0, 1, 2],
                        pointers: []
                    ),
                    code: "result = [[1,6], [8,10], [15,18]]"
                )
            ],
            keyInsights: [
                "📊 Always SORT intervals first!",
                "🔗 Overlap check: end >= next.start",
                "🎯 Merge: [min(start), max(end)]"
            ],
            whenToUse: "Use for merging intervals, finding free time slots, detecting overlaps, or interval insertion problems.",
            timeComplexity: "O(n log n) for sorting, O(n) for merging",
            spaceComplexity: "O(n) for result array"
        )
    }
    
    // MARK: - Dynamic Programming Tutorial
    static func dynamicProgrammingTutorial() -> PatternTutorial {
        PatternTutorial(
            patternId: PatternType.dynamicProgramming.id,
            steps: [
                TutorialStep(
                    title: "What is DP?",
                    explanation: "DP = solving big problems by breaking into smaller overlapping subproblems. Key: STORE solutions to avoid recomputation!",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "F(5)", state: .active),
                            VisualElement(value: "F(4)", state: .normal),
                            VisualElement(value: "F(3)", state: .normal),
                            VisualElement(value: "F(2)", state: .normal),
                            VisualElement(value: "F(1)", state: .normal)
                        ],
                        highlights: [0],
                        pointers: [
                            PointerData(name: "goal", index: 0, color: "blue")
                        ]
                    ),
                    code: "// Fibonacci: F(n) = F(n-1) + F(n-2)\n// Without DP: exponential time!\n// With DP: O(n)"
                ),
                
                TutorialStep(
                    title: "Example: Climbing Stairs",
                    explanation: "You can climb 1 or 2 steps. How many ways to reach step 5? Answer: ways(5) = ways(4) + ways(3)",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "1", state: .visited),
                            VisualElement(value: "1", state: .visited),
                            VisualElement(value: "2", state: .visited),
                            VisualElement(value: "3", state: .active),
                            VisualElement(value: "5", state: .normal)
                        ],
                        highlights: [3],
                        pointers: [
                            PointerData(name: "dp[3]", index: 3, color: "green")
                        ]
                    ),
                    code: "dp[0] = 1  // base case\ndp[1] = 1\ndp[2] = 2  // (1+1 or 2)\ndp[3] = dp[2] + dp[1] = 3\ndp[4] = dp[3] + dp[2] = 5"
                ),
                
                TutorialStep(
                    title: "Build from Bottom Up",
                    explanation: "Start with smallest subproblems (base cases). Build up to final answer. Store each result in array!",
                    visualization: VisualizationData(
                        type: .array,
                        elements: [
                            VisualElement(value: "1", state: .result),
                            VisualElement(value: "1", state: .result),
                            VisualElement(value: "2", state: .result),
                            VisualElement(value: "3", state: .result),
                            VisualElement(value: "5", state: .result),
                            VisualElement(value: "8", state: .active)
                        ],
                        highlights: [5],
                        pointers: [
                            PointerData(name: "answer", index: 5, color: "blue")
                        ]
                    ),
                    code: "// Answer: 8 ways to climb 5 steps!\nfor i in 0...n {\n    dp[i] = dp[i-1] + dp[i-2]\n}\nreturn dp[n]"
                )
            ],
            keyInsights: [
                "💾 MEMOIZATION = store subproblem results",
                "🔁 Identify the RECURRENCE relation",
                "🎯 Bottom-up (iterative) often cleaner than top-down (recursive)"
            ],
            whenToUse: "Use DP for optimization problems with overlapping subproblems: fibonacci, coin change, longest subsequence, knapsack.",
            timeComplexity: "O(n) to O(n²) typically",
            spaceComplexity: "O(n) for memoization array"
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
        case "Heap":
            return heapTutorial()
        case "Graph BFS":
            return graphBFSTutorial()
        case "Graph DFS":
            return graphDFSTutorial()
        case "Intervals":
            return intervalsTutorial()
        case "Dynamic Programming":
            return dynamicProgrammingTutorial()
        default:
            return nil
        }
    }
}

