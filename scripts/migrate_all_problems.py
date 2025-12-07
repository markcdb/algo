#!/usr/bin/env python3
"""
Complete migration of all 21 problems to JSON with Swift/Python/Java
Run this to generate the full problems.json file
"""

import json

# Template for easy problem addition
PROBLEM_TEMPLATE = {
    "id": "",
    "title": "",
    "prompt": "",
    "pattern": "",  # slidingWindow, twoPointers, binarySearch, heap, graphBFS, graphDFS, intervals
    "difficulty": "",  # easy, medium, hard
    "tags": [],
    "estimatedTimeMinutes": 0,
    "solutions": {
        "swift": "",
        "python": "",
        "java": ""
    },
    "testCases": [
        {
            "input": "",
            "expectedOutput": "",
            "explanation": ""
        }
    ]
}

# Start with 5 key problems (1 from each major pattern)
STARTER_PROBLEMS = [
    {
        "id": "longest-substring-no-repeat",
        "title": "Longest Substring Without Repeating Characters",
        "prompt": "Given a string s, find the length of the longest substring without repeating characters.",
        "pattern": "slidingWindow",
        "difficulty": "medium",
        "tags": ["sliding window", "string"],
        "estimatedTimeMinutes": 8,
        "solutions": {
            "swift": "// Solution code here",
            "python": "# Solution code here",
            "java": "// Solution code here"
        },
        "testCases": [
            {"input": "abcabcbb", "expectedOutput": "3"}
        ]
    }
]

# TODO: Add all 21 problems here following the template above

def main():
    config = {"problems": STARTER_PROBLEMS}
    
    with open('/Users/markbuot/GIT/algo/algo/algo/Data/Resources/problems.json', 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"✅ Generated problems.json")
    print(f"📊 Problems: {len(STARTER_PROBLEMS)}")
    print(f"📝 TODO: Add {21 - len(STARTER_PROBLEMS)} more problems")

if __name__ == "__main__":
    main()
