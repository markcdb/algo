#!/usr/bin/env python3
"""
Script to convert hardcoded Swift problems to JSON configuration format.
This extracts all problems from InMemoryProblemRepository.swift and generates problems.json
"""

import json
import re

# You can manually define all problems here or extract them
# For now, I'll create a template you can use to add all 21 problems

problems_config = {
    "problems": [
        {
            "id": "longest-substring-no-repeat",
            "title": "Longest Substring Without Repeating Characters",
            "prompt": "Given a string s, find the length of the longest substring without repeating characters.\n\nExample 1:\nInput: s = \"abcabcbb\"\nOutput: 3\nExplanation: The answer is \"abc\", with the length of 3.\n\nExample 2:\nInput: s = \"bbbbb\"\nOutput: 1\nExplanation: The answer is \"b\", with the length of 1.\n\nExample 3:\nInput: s = \"pwwkew\"\nOutput: 3\nExplanation: The answer is \"wke\", with the length of 3.\n\nConstraints:\n- 0 <= s.length <= 5 * 10^4\n- s consists of English letters, digits, symbols and spaces.",
            "pattern": "slidingWindow",
            "difficulty": "medium",
            "tags": ["sliding window", "string", "hash set"],
            "estimatedTimeMinutes": 8,
            "solutions": {
                "swift": "func lengthOfLongestSubstring(_ s: String) -> Int {\n    var charSet = Set<Character>()\n    var left = 0\n    var maxLength = 0\n    let chars = Array(s)\n    \n    for right in 0..<chars.count {\n        while charSet.contains(chars[right]) {\n            charSet.remove(chars[left])\n            left += 1\n        }\n        charSet.insert(chars[right])\n        maxLength = max(maxLength, right - left + 1)\n    }\n    \n    return maxLength\n}\n\nprint(lengthOfLongestSubstring(readLine()!))",
                "python": "def lengthOfLongestSubstring(s: str) -> int:\n    char_set = set()\n    left = 0\n    max_length = 0\n    \n    for right in range(len(s)):\n        while s[right] in char_set:\n            char_set.remove(s[left])\n            left += 1\n        char_set.add(s[right])\n        max_length = max(max_length, right - left + 1)\n    \n    return max_length\n\nprint(lengthOfLongestSubstring(input()))",
                "java": "import java.util.*;\n\npublic class Solution {\n    public static int lengthOfLongestSubstring(String s) {\n        Set<Character> charSet = new HashSet<>();\n        int left = 0;\n        int maxLength = 0;\n        \n        for (int right = 0; right < s.length(); right++) {\n            while (charSet.contains(s.charAt(right))) {\n                charSet.remove(s.charAt(left));\n                left++;\n            }\n            charSet.add(s.charAt(right));\n            maxLength = Math.max(maxLength, right - left + 1);\n        }\n        \n        return maxLength;\n    }\n    \n    public static void main(String[] args) {\n        Scanner scanner = new Scanner(System.in);\n        System.out.println(lengthOfLongestSubstring(scanner.nextLine()));\n    }\n}"
            },
            "testCases": [
                {
                    "input": "abcabcbb",
                    "expectedOutput": "3",
                    "explanation": "The answer is \"abc\", with the length of 3."
                },
                {
                    "input": "bbbbb",
                    "expectedOutput": "1",
                    "explanation": "The answer is \"b\", with the length of 1."
                },
                {
                    "input": "pwwkew",
                    "expectedOutput": "3",
                    "explanation": "The answer is \"wke\", with the length of 3."
                }
            ]
        },
        # Add all 21 problems here...
    ]
}

# Write to file
output_path = "algo/algo/Data/Resources/problems.json"
with open(output_path, 'w') as f:
    json.dump(problems_config, f, indent=2)

print(f"✅ Generated {output_path}")
print(f"📊 Total problems: {len(problems_config['problems'])}")
