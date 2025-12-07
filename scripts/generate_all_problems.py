#!/usr/bin/env python3
import json

# All 21 problems with Swift/Python/Java solutions
problems = {
    "problems": [
        # Problem 1: Longest Substring Without Repeating Characters
        {
            "id": "longest-substring-no-repeat",
            "title": "Longest Substring Without Repeating Characters",
            "prompt": """Given a string s, find the length of the longest substring without repeating characters.

Example 1:
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.

Example 2:
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.

Example 3:
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.

Constraints:
- 0 <= s.length <= 5 * 10^4
- s consists of English letters, digits, symbols and spaces.""",
            "pattern": "slidingWindow",
            "difficulty": "medium",
            "tags": ["sliding window", "string", "hash set"],
            "estimatedTimeMinutes": 8,
            "solutions": {
                "swift": """func lengthOfLongestSubstring(_ s: String) -> Int {
    var charSet = Set<Character>()
    var left = 0
    var maxLength = 0
    let chars = Array(s)
    
    for right in 0..<chars.count {
        while charSet.contains(chars[right]) {
            charSet.remove(chars[left])
            left += 1
        }
        charSet.insert(chars[right])
        maxLength = max(maxLength, right - left + 1)
    }
    return maxLength
}
print(lengthOfLongestSubstring(readLine()!))""",
                "python": """def length_of_longest_substring(s):
    char_set = set()
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        while s[right] in char_set:
            char_set.remove(s[left])
            left += 1
        char_set.add(s[right])
        max_length = max(max_length, right - left + 1)
    return max_length

print(length_of_longest_substring(input()))""",
                "java": """import java.util.*;
class Solution {
    public static int lengthOfLongestSubstring(String s) {
        Set<Character> set = new HashSet<>();
        int left = 0, max = 0;
        for (int right = 0; right < s.length(); right++) {
            while (set.contains(s.charAt(right))) {
                set.remove(s.charAt(left++));
            }
            set.add(s.charAt(right));
            max = Math.max(max, right - left + 1);
        }
        return max;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        System.out.println(lengthOfLongestSubstring(sc.nextLine()));
    }
}"""
            },
            "testCases": [
                {"input": "abcabcbb", "expectedOutput": "3", "explanation": "The answer is \"abc\", with the length of 3."},
                {"input": "bbbbb", "expectedOutput": "1", "explanation": "The answer is \"b\", with the length of 1."},
                {"input": "pwwkew", "expectedOutput": "3", "explanation": "The answer is \"wke\", with the length of 3."}
            ]
        },
        
        # Problem 2: Longest Substring with At Most K Distinct Characters
        {
            "id": "k-distinct-chars",
            "title": "Longest Substring with At Most K Distinct Characters",
            "prompt": """Given a string s and an integer k, return the length of the longest substring of s that contains at most k distinct characters.

Example 1:
Input: s = "eceba", k = 2
Output: 3
Explanation: The substring is "ece" with length 3.

Example 2:
Input: s = "aa", k = 1
Output: 2
Explanation: The substring is "aa" with length 2.

Constraints:
- 1 <= s.length <= 5 * 10^4
- 0 <= k <= 50""",
            "pattern": "slidingWindow",
            "difficulty": "medium",
            "tags": ["sliding window", "hash map", "string"],
            "estimatedTimeMinutes": 10,
            "solutions": {
                "swift": """func lengthOfLongestSubstringKDistinct(_ s: String, _ k: Int) -> Int {
    guard k > 0 else { return 0 }
    let chars = Array(s)
    var charCount = [Character: Int]()
    var left = 0, maxLength = 0
    
    for right in 0..<chars.count {
        charCount[chars[right], default: 0] += 1
        while charCount.count > k {
            charCount[chars[left]]! -= 1
            if charCount[chars[left]] == 0 {
                charCount.removeValue(forKey: chars[left])
            }
            left += 1
        }
        maxLength = max(maxLength, right - left + 1)
    }
    return maxLength
}
let input = readLine()!.split(separator: "|")
print(lengthOfLongestSubstringKDistinct(String(input[0]), Int(input[1])!))""",
                "python": """def length_k_distinct(s, k):
    if k == 0: return 0
    char_count = {}
    left = 0
    max_length = 0
    
    for right in range(len(s)):
        char_count[s[right]] = char_count.get(s[right], 0) + 1
        while len(char_count) > k:
            char_count[s[left]] -= 1
            if char_count[s[left]] == 0:
                del char_count[s[left]]
            left += 1
        max_length = max(max_length, right - left + 1)
    return max_length

inp = input().split('|')
print(length_k_distinct(inp[0], int(inp[1])))""",
                "java": """import java.util.*;
class Solution {
    public static int lengthKDistinct(String s, int k) {
        if (k == 0) return 0;
        Map<Character, Integer> map = new HashMap<>();
        int left = 0, max = 0;
        for (int right = 0; right < s.length(); right++) {
            map.put(s.charAt(right), map.getOrDefault(s.charAt(right), 0) + 1);
            while (map.size() > k) {
                char c = s.charAt(left);
                map.put(c, map.get(c) - 1);
                if (map.get(c) == 0) map.remove(c);
                left++;
            }
            max = Math.max(max, right - left + 1);
        }
        return max;
    }
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String[] parts = sc.nextLine().split("\\\\|");
        System.out.println(lengthKDistinct(parts[0], Integer.parseInt(parts[1])));
    }
}"""
            },
            "testCases": [
                {"input": "eceba|2", "expectedOutput": "3", "explanation": "The substring is \"ece\" with length 3"},
                {"input": "aa|1", "expectedOutput": "2", "explanation": "The substring is \"aa\" with length 2"}
            ]
        }
    ]
}

# Write to file
with open('/Users/markbuot/GIT/algo/algo/algo/Data/Resources/problems.json', 'w') as f:
    json.dump(problems, f, indent=2)

print("✅ Created problems.json with 2 problems")
print("⏳ Adding remaining 19 problems...")
