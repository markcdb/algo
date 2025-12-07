#!/usr/bin/env swift

import Foundation

// Copy the TestCase struct
struct TestCase: Codable {
    let input: String
    let expectedOutput: String
    let explanation: String?
    
    init(input: String, expectedOutput: String, explanation: String? = nil) {
        self.input = input
        self.expectedOutput = expectedOutput
        self.explanation = explanation
    }
}

// Copy the Problem struct with Codable
struct Problem: Codable {
    let title: String
    let prompt: String
    let pattern: String
    let tags: [String]
    let estimatedTimeMinutes: Int
    let canonicalSolution: String
    let testCases: [TestCase]
    
    enum CodingKeys: String, CodingKey {
        case title, prompt, pattern, tags, estimatedTimeMinutes, canonicalSolution, testCases
    }
}

// Convert to JSON format expected by ProblemConfigLoader
struct ProblemData: Codable {
    let id: String
    let title: String
    let prompt: String
    let pattern: String
    let difficulty: String
    let tags: [String]
    let estimatedTimeMinutes: Int
    let solutions: [String: String]
    let testCases: [TestCase]
}

struct ProblemConfig: Codable {
    let problems: [ProblemData]
}

// Helper to generate ID from title
func generateId(from title: String) -> String {
    return title.lowercased()
        .replacingOccurrences(of: " ", with: "-")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")
}

// Helper to infer difficulty from tags
func inferDifficulty(from tags: [String]) -> String {
    if tags.contains("easy") { return "easy" }
    if tags.contains("hard") { return "hard" }
    return "medium"
}

// Copy ALL the fallbackProblems from InMemoryProblemRepository
let fallbackProblems: [Problem] = [
    Problem(
        title: "Longest Substring Without Repeating Characters",
        prompt: """
        Given a string s, find the length of the longest substring without repeating characters.
        
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
        - s consists of English letters, digits, symbols and spaces.
        """,
        pattern: "slidingWindow",
        tags: ["sliding window", "string", "hash set", "medium"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        func lengthOfLongestSubstring(_ s: String) -> Int {
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
        
        print(lengthOfLongestSubstring(readLine()!))
        """,
        testCases: [
            TestCase(input: "abcabcbb", expectedOutput: "3", explanation: "The answer is \"abc\", with the length of 3."),
            TestCase(input: "bbbbb", expectedOutput: "1", explanation: "The answer is \"b\", with the length of 1."),
            TestCase(input: "pwwkew", expectedOutput: "3", explanation: "The answer is \"wke\", with the length of 3.")
        ]
    ),
    Problem(
        title: "Longest Substring with At Most K Distinct Characters",
        prompt: """
        Given a string s and an integer k, return the length of the longest substring of s that contains at most k distinct characters.
        
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
        - 0 <= k <= 50
        """,
        pattern: "slidingWindow",
        tags: ["sliding window", "hash map", "string", "medium"],
        estimatedTimeMinutes: 10,
        canonicalSolution: """
        func lengthOfLongestSubstringKDistinct(_ s: String, _ k: Int) -> Int {
            guard k > 0 else { return 0 }
            let chars = Array(s)
            var charCount = [Character: Int]()
            var left = 0
            var maxLength = 0
            
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
        let s = String(input[0])
        let k = Int(input[1])!
        print(lengthOfLongestSubstringKDistinct(s, k))
        """,
        testCases: [
            TestCase(input: "eceba|2", expectedOutput: "3", explanation: "The substring is \"ece\" with length 3"),
            TestCase(input: "aa|1", expectedOutput: "2", explanation: "The substring is \"aa\" with length 2")
        ]
    ),
    Problem(
        title: "Minimum Window Substring",
        prompt: """
        Given two strings s and t, return the minimum window substring of s such that every character in t (including duplicates) is included in the window. If there is no such substring, return the empty string "".
        
        Example 1:
        Input: s = "ADOBECODEBANC", t = "ABC"
        Output: "BANC"
        Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.
        
        Example 2:
        Input: s = "a", t = "a"
        Output: "a"
        
        Constraints:
        - 1 <= s.length, t.length <= 10^5
        - s and t consist of uppercase and lowercase English letters.
        """,
        pattern: "slidingWindow",
        tags: ["sliding window", "hash map", "string", "hard"],
        estimatedTimeMinutes: 15,
        canonicalSolution: """
        func minWindow(_ s: String, _ t: String) -> String {
            let sChars = Array(s)
            var need = [Character: Int]()
            var window = [Character: Int]()
            
            for char in t {
                need[char, default: 0] += 1
            }
            
            var left = 0, right = 0
            var valid = 0
            var start = 0, length = Int.max
            
            while right < sChars.count {
                let c = sChars[right]
                right += 1
                
                if let count = need[c] {
                    window[c, default: 0] += 1
                    if window[c] == count {
                        valid += 1
                    }
                }
                
                while valid == need.count {
                    if right - left < length {
                        start = left
                        length = right - left
                    }
                    
                    let d = sChars[left]
                    left += 1
                    
                    if let count = need[d] {
                        if window[d] == count {
                            valid -= 1
                        }
                        window[d]! -= 1
                    }
                }
            }
            
            return length == Int.max ? "" : String(sChars[start..<start+length])
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Max Sum Subarray of Size K",
        prompt: """
        Given an array of positive integers and a number k, find the maximum sum of any contiguous subarray of size k.
        
        Example 1:
        Input: arr = [2, 1, 5, 1, 3, 2], k = 3
        Output: 9
        Explanation: Subarray [5, 1, 3] has the maximum sum of 9.
        
        Example 2:
        Input: arr = [2, 3, 4, 1, 5], k = 2
        Output: 7
        Explanation: Subarray [3, 4] has the maximum sum of 7.
        
        Constraints:
        - 1 <= arr.length <= 10^5
        - 1 <= k <= arr.length
        """,
        pattern: "slidingWindow",
        tags: ["sliding window", "array", "easy"],
        estimatedTimeMinutes: 5,
        canonicalSolution: """
        func maxSumSubarray(_ arr: [Int], _ k: Int) -> Int {
            guard arr.count >= k else { return 0 }
            
            var windowSum = 0
            var maxSum = 0
            
            // Calculate sum of first window
            for i in 0..<k {
                windowSum += arr[i]
            }
            maxSum = windowSum
            
            // Slide the window
            for i in k..<arr.count {
                windowSum = windowSum - arr[i - k] + arr[i]
                maxSum = max(maxSum, windowSum)
            }
            
            return maxSum
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Number of Subarrays with Sum Less Than K",
        prompt: """
        Given an array of positive integers nums and an integer k, return the number of contiguous subarrays where the sum of elements is less than k.
        
        Example 1:
        Input: nums = [1, 2, 3], k = 7
        Output: 6
        Explanation: The 6 subarrays are [1], [2], [3], [1,2], [2,3], [1,2,3]
        
        Example 2:
        Input: nums = [10, 5, 2, 6], k = 100
        Output: 10
        
        Constraints:
        - 1 <= nums.length <= 3 * 10^4
        - 1 <= nums[i] <= 1000
        - 0 <= k <= 10^6
        """,
        pattern: "slidingWindow",
        tags: ["sliding window", "array", "prefix sum", "medium"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        func numSubarraysWithSum(_ nums: [Int], _ k: Int) -> Int {
            var count = 0
            var left = 0
            var sum = 0
            
            for right in 0..<nums.count {
                sum += nums[right]
                
                while sum >= k && left <= right {
                    sum -= nums[left]
                    left += 1
                }
                
                // All subarrays from left to right have sum < k
                count += right - left + 1
            }
            
            return count
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Container With Most Water",
        prompt: """
        You are given an integer array height of length n. There are n vertical lines drawn such that the two endpoints of the ith line are (i, 0) and (i, height[i]).
        
        Find two lines that together with the x-axis form a container that holds the most water. Return the maximum amount of water a container can store.
        
        Example 1:
        Input: height = [1,8,6,2,5,4,8,3,7]
        Output: 49
        Explanation: The vertical lines are at indices 1 and 8, with heights 8 and 7.
        
        Example 2:
        Input: height = [1,1]
        Output: 1
        
        Constraints:
        - n == height.length
        - 2 <= n <= 10^5
        - 0 <= height[i] <= 10^4
        """,
        pattern: "twoPointers",
        tags: ["two pointers", "array", "greedy", "medium"],
        estimatedTimeMinutes: 7,
        canonicalSolution: """
        func maxArea(_ height: [Int]) -> Int {
            var left = 0
            var right = height.count - 1
            var maxArea = 0
            
            while left < right {
                let width = right - left
                let h = min(height[left], height[right])
                maxArea = max(maxArea, width * h)
                
                if height[left] < height[right] {
                    left += 1
                } else {
                    right -= 1
                }
            }
            
            return maxArea
        }
        
        let input = readLine()!
        let height = input.dropFirst().dropLast().split(separator: ",").map { Int($0.trimmingCharacters(in: .whitespaces))! }
        print(maxArea(height))
        """,
        testCases: [
            TestCase(input: "[1,8,6,2,5,4,8,3,7]", expectedOutput: "49", explanation: "The vertical lines are at indices 1 and 8"),
            TestCase(input: "[1,1]", expectedOutput: "1"),
            TestCase(input: "[4,3,2,1,4]", expectedOutput: "16", explanation: "The container uses indices 0 and 4")
        ]
    ),
    Problem(
        title: "Three Sum",
        prompt: """
        Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]] such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.
        
        Notice that the solution set must not contain duplicate triplets.
        
        Example 1:
        Input: nums = [-1,0,1,2,-1,-4]
        Output: [[-1,-1,2],[-1,0,1]]
        
        Example 2:
        Input: nums = [0,1,1]
        Output: []
        
        Constraints:
        - 3 <= nums.length <= 3000
        - -10^5 <= nums[i] <= 10^5
        """,
        pattern: "twoPointers",
        tags: ["two pointers", "array", "sorting", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        func threeSum(_ nums: [Int]) -> [[Int]] {
            let sorted = nums.sorted()
            var result: [[Int]] = []
            
            for i in 0..<sorted.count - 2 {
                if i > 0 && sorted[i] == sorted[i - 1] { continue }
                
                var left = i + 1
                var right = sorted.count - 1
                
                while left < right {
                    let sum = sorted[i] + sorted[left] + sorted[right]
                    
                    if sum == 0 {
                        result.append([sorted[i], sorted[left], sorted[right]])
                        
                        while left < right && sorted[left] == sorted[left + 1] { left += 1 }
                        while left < right && sorted[right] == sorted[right - 1] { right -= 1 }
                        
                        left += 1
                        right -= 1
                    } else if sum < 0 {
                        left += 1
                    } else {
                        right -= 1
                    }
                }
            }
            
            return result
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Sort Colors (Dutch National Flag)",
        prompt: """
        Given an array nums with n objects colored red, white, or blue, sort them in-place so that objects of the same color are adjacent, with the colors in the order red, white, and blue.
        
        We will use the integers 0, 1, and 2 to represent the color red, white, and blue, respectively.
        
        You must solve this problem without using the library's sort function.
        
        Example 1:
        Input: nums = [2,0,2,1,1,0]
        Output: [0,0,1,1,2,2]
        
        Example 2:
        Input: nums = [2,0,1]
        Output: [0,1,2]
        
        Constraints:
        - n == nums.length
        - 1 <= n <= 300
        - nums[i] is either 0, 1, or 2.
        """,
        pattern: "twoPointers",
        tags: ["two pointers", "array", "sorting", "medium"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        func sortColors(_ nums: inout [Int]) {
            var left = 0      // boundary for 0s
            var right = nums.count - 1  // boundary for 2s
            var i = 0
            
            while i <= right {
                if nums[i] == 0 {
                    nums.swapAt(i, left)
                    left += 1
                    i += 1
                } else if nums[i] == 2 {
                    nums.swapAt(i, right)
                    right -= 1
                    // Don't increment i, need to check swapped value
                } else {
                    i += 1
                }
            }
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Binary Search",
        prompt: """
        Given an array of integers nums which is sorted in ascending order, and an integer target, write a function to search target in nums. If target exists, then return its index. Otherwise, return -1.
        
        You must write an algorithm with O(log n) runtime complexity.
        
        Example 1:
        Input: nums = [-1,0,3,5,9,12], target = 9
        Output: 4
        Explanation: 9 exists in nums and its index is 4
        
        Example 2:
        Input: nums = [-1,0,3,5,9,12], target = 2
        Output: -1
        Explanation: 2 does not exist in nums so return -1
        
        Constraints:
        - 1 <= nums.length <= 10^4
        - -10^4 < nums[i], target < 10^4
        - All integers in nums are unique.
        - nums is sorted in ascending order.
        """,
        pattern: "binarySearch",
        tags: ["binary search", "array", "easy"],
        estimatedTimeMinutes: 5,
        canonicalSolution: """
        func search(_ nums: [Int], _ target: Int) -> Int {
            var left = 0
            var right = nums.count - 1
            
            while left <= right {
                let mid = left + (right - left) / 2
                
                if nums[mid] == target {
                    return mid
                } else if nums[mid] < target {
                    left = mid + 1
                } else {
                    right = mid - 1
                }
            }
            
            return -1
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Search in Rotated Sorted Array",
        prompt: """
        There is an integer array nums sorted in ascending order (with distinct values).
        
        Prior to being passed to your function, nums is possibly rotated at an unknown pivot index k (1 <= k < nums.length) such that the resulting array is [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]] (0-indexed).
        
        Given the array nums after the possible rotation and an integer target, return the index of target if it is in nums, or -1 if it is not in nums.
        
        You must write an algorithm with O(log n) runtime complexity.
        
        Example 1:
        Input: nums = [4,5,6,7,0,1,2], target = 0
        Output: 4
        
        Example 2:
        Input: nums = [4,5,6,7,0,1,2], target = 3
        Output: -1
        
        Constraints:
        - 1 <= nums.length <= 5000
        - -10^4 <= nums[i] <= 10^4
        - All values of nums are unique.
        """,
        pattern: "binarySearch",
        tags: ["binary search", "array", "medium"],
        estimatedTimeMinutes: 10,
        canonicalSolution: """
        func search(_ nums: [Int], _ target: Int) -> Int {
            var left = 0
            var right = nums.count - 1
            
            while left <= right {
                let mid = left + (right - left) / 2
                
                if nums[mid] == target {
                    return mid
                }
                
                // Left half is sorted
                if nums[left] <= nums[mid] {
                    if target >= nums[left] && target < nums[mid] {
                        right = mid - 1
                    } else {
                        left = mid + 1
                    }
                }
                // Right half is sorted
                else {
                    if target > nums[mid] && target <= nums[right] {
                        left = mid + 1
                    } else {
                        right = mid - 1
                    }
                }
            }
            
            return -1
        }
        
        let input = readLine()!.split(separator: "|")
        let nums = input[0].dropFirst().dropLast().split(separator: ",").map { Int($0.trimmingCharacters(in: .whitespaces))! }
        let target = Int(input[1].trimmingCharacters(in: .whitespaces))!
        print(search(nums, target))
        """,
        testCases: [
            TestCase(input: "[4,5,6,7,0,1,2]|0", expectedOutput: "4", explanation: "Target 0 is at index 4"),
            TestCase(input: "[4,5,6,7,0,1,2]|3", expectedOutput: "-1", explanation: "Target 3 is not in the array"),
            TestCase(input: "[1]|0", expectedOutput: "-1")
        ]
    ),
    Problem(
        title: "Koko Eating Bananas",
        prompt: """
        Koko loves to eat bananas. There are n piles of bananas, the ith pile has piles[i] bananas. The guards have gone and will come back in h hours.
        
        Koko can decide her bananas-per-hour eating speed of k. Each hour, she chooses some pile of bananas and eats k bananas from that pile. If the pile has less than k bananas, she eats all of them instead and will not eat any more bananas during this hour.
        
        Koko likes to eat slowly but still wants to finish eating all the bananas before the guards return.
        
        Return the minimum integer k such that she can eat all the bananas within h hours.
        
        Example 1:
        Input: piles = [3,6,7,11], h = 8
        Output: 4
        
        Example 2:
        Input: piles = [30,11,23,4,20], h = 5
        Output: 30
        
        Constraints:
        - 1 <= piles.length <= 10^4
        - piles.length <= h <= 10^9
        - 1 <= piles[i] <= 10^9
        """,
        pattern: "binarySearch",
        tags: ["binary search", "array", "binary search on answer", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        func minEatingSpeed(_ piles: [Int], _ h: Int) -> Int {
            var left = 1
            var right = piles.max()!
            
            while left < right {
                let mid = left + (right - left) / 2
                
                if canFinish(piles, mid, h) {
                    right = mid
                } else {
                    left = mid + 1
                }
            }
            
            return left
        }
        
        func canFinish(_ piles: [Int], _ k: Int, _ h: Int) -> Bool {
            var hours = 0
            for pile in piles {
                hours += (pile + k - 1) / k  // Ceiling division
            }
            return hours <= h
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Top K Frequent Elements",
        prompt: """
        Given an integer array nums and an integer k, return the k most frequent elements. You may return the answer in any order.
        
        Example 1:
        Input: nums = [1,1,1,2,2,3], k = 2
        Output: [1,2]
        
        Example 2:
        Input: nums = [1], k = 1
        Output: [1]
        
        Constraints:
        - 1 <= nums.length <= 10^5
        - -10^4 <= nums[i] <= 10^4
        - k is in the range [1, the number of unique elements in the array].
        - It is guaranteed that the answer is unique.
        """,
        pattern: "heap",
        tags: ["hash map", "heap", "bucket sort", "medium"],
        estimatedTimeMinutes: 10,
        canonicalSolution: """
        func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
            var freqMap = [Int: Int]()
            for num in nums {
                freqMap[num, default: 0] += 1
            }
            
            // Bucket sort by frequency
            var buckets = Array(repeating: [Int](), count: nums.count + 1)
            for (num, freq) in freqMap {
                buckets[freq].append(num)
            }
            
            var result = [Int]()
            for i in stride(from: buckets.count - 1, through: 0, by: -1) {
                result.append(contentsOf: buckets[i])
                if result.count >= k {
                    break
                }
            }
            
            return Array(result.prefix(k))
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Group Anagrams",
        prompt: """
        Given an array of strings strs, group the anagrams together. You can return the answer in any order.
        
        An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.
        
        Example 1:
        Input: strs = ["eat","tea","tan","ate","nat","bat"]
        Output: [["bat"],["nat","tan"],["ate","eat","tea"]]
        
        Example 2:
        Input: strs = [""]
        Output: [[""]]
        
        Example 3:
        Input: strs = ["a"]
        Output: [["a"]]
        
        Constraints:
        - 1 <= strs.length <= 10^4
        - 0 <= strs[i].length <= 100
        - strs[i] consists of lowercase English letters.
        """,
        pattern: "heap",
        tags: ["hash map", "string", "sorting", "medium"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        func groupAnagrams(_ strs: [String]) -> [[String]] {
            var groups = [String: [String]]()
            
            for str in strs {
                let key = String(str.sorted())
                groups[key, default: []].append(str)
            }
            
            return Array(groups.values)
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Valid Anagram",
        prompt: """
        Given two strings s and t, return true if t is an anagram of s, and false otherwise.
        
        An Anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.
        
        Example 1:
        Input: s = "anagram", t = "nagaram"
        Output: true
        
        Example 2:
        Input: s = "rat", t = "car"
        Output: false
        
        Constraints:
        - 1 <= s.length, t.length <= 5 * 10^4
        - s and t consist of lowercase English letters.
        """,
        pattern: "heap",
        tags: ["hash map", "string", "sorting", "easy"],
        estimatedTimeMinutes: 5,
        canonicalSolution: """
        func isAnagram(_ s: String, _ t: String) -> Bool {
            guard s.count == t.count else { return false }
            
            var charCount = [Character: Int]()
            
            for char in s {
                charCount[char, default: 0] += 1
            }
            
            for char in t {
                guard let count = charCount[char], count > 0 else {
                    return false
                }
                charCount[char]! -= 1
            }
            
            return true
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Merge Intervals",
        prompt: """
        Given an array of intervals where intervals[i] = [starti, endi], merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.
        
        Example 1:
        Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
        Output: [[1,6],[8,10],[15,18]]
        Explanation: Since intervals [1,3] and [2,6] overlap, merge them into [1,6].
        
        Example 2:
        Input: intervals = [[1,4],[4,5]]
        Output: [[1,5]]
        Explanation: Intervals [1,4] and [4,5] are considered overlapping.
        
        Constraints:
        - 1 <= intervals.length <= 10^4
        - intervals[i].length == 2
        - 0 <= starti <= endi <= 10^4
        """,
        pattern: "intervals",
        tags: ["intervals", "array", "sorting", "medium"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        func merge(_ intervals: [[Int]]) -> [[Int]] {
            guard !intervals.isEmpty else { return [] }
            
            let sorted = intervals.sorted { $0[0] < $1[0] }
            var merged: [[Int]] = [sorted[0]]
            
            for interval in sorted.dropFirst() {
                if interval[0] <= merged[merged.count - 1][1] {
                    // Overlapping - merge
                    merged[merged.count - 1][1] = max(merged[merged.count - 1][1], interval[1])
                } else {
                    // Non-overlapping - add new interval
                    merged.append(interval)
                }
            }
            
            return merged
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Insert Interval",
        prompt: """
        You are given an array of non-overlapping intervals intervals where intervals[i] = [starti, endi] represent the start and the end of the ith interval and intervals is sorted in ascending order by starti. You are also given an interval newInterval = [start, end] that represents the start and end of another interval.
        
        Insert newInterval into intervals such that intervals is still sorted in ascending order by starti and intervals still does not have any overlapping intervals (merge overlapping intervals if necessary).
        
        Return intervals after the insertion.
        
        Example 1:
        Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
        Output: [[1,5],[6,9]]
        
        Example 2:
        Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
        Output: [[1,2],[3,10],[12,16]]
        Explanation: Because the new interval [4,8] overlaps with [3,5],[6,7],[8,10].
        
        Constraints:
        - 0 <= intervals.length <= 10^4
        - intervals[i].length == 2
        - 0 <= starti <= endi <= 10^5
        """,
        pattern: "intervals",
        tags: ["intervals", "array", "medium"],
        estimatedTimeMinutes: 10,
        canonicalSolution: """
        func insert(_ intervals: [[Int]], _ newInterval: [Int]) -> [[Int]] {
            var result: [[Int]] = []
            var newInt = newInterval
            var i = 0
            
            // Add all intervals before newInterval
            while i < intervals.count && intervals[i][1] < newInt[0] {
                result.append(intervals[i])
                i += 1
            }
            
            // Merge overlapping intervals
            while i < intervals.count && intervals[i][0] <= newInt[1] {
                newInt[0] = min(newInt[0], intervals[i][0])
                newInt[1] = max(newInt[1], intervals[i][1])
                i += 1
            }
            result.append(newInt)
            
            // Add remaining intervals
            while i < intervals.count {
                result.append(intervals[i])
                i += 1
            }
            
            return result
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Meeting Rooms II",
        prompt: """
        Given an array of meeting time intervals where intervals[i] = [starti, endi], return the minimum number of conference rooms required.
        
        Example 1:
        Input: intervals = [[0,30],[5,10],[15,20]]
        Output: 2
        Explanation: One room for [0,30] and another for [5,10] and [15,20].
        
        Example 2:
        Input: intervals = [[7,10],[2,4]]
        Output: 1
        
        Constraints:
        - 1 <= intervals.length <= 10^4
        - 0 <= starti < endi <= 10^6
        """,
        pattern: "heap",
        tags: ["intervals", "heap", "sorting", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        func minMeetingRooms(_ intervals: [[Int]]) -> Int {
            guard !intervals.isEmpty else { return 0 }
            
            let sorted = intervals.sorted { $0[0] < $1[0] }
            var endTimes: [Int] = []  // Min heap simulation
            
            for interval in sorted {
                // If earliest ending meeting has ended, reuse that room
                if !endTimes.isEmpty && endTimes[0] <= interval[0] {
                    endTimes.removeFirst()
                }
                
                // Add current meeting's end time
                endTimes.append(interval[1])
                endTimes.sort()  // Maintain min heap
            }
            
            return endTimes.count
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Number of Islands",
        prompt: """
        Given an m x n 2D binary grid which represents a map of '1's (land) and '0's (water), return the number of islands.
        
        An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.
        
        Example 1:
        Input: grid = [
          ["1","1","1","1","0"],
          ["1","1","0","1","0"],
          ["1","1","0","0","0"],
          ["0","0","0","0","0"]
        ]
        Output: 1
        
        Example 2:
        Input: grid = [
          ["1","1","0","0","0"],
          ["1","1","0","0","0"],
          ["0","0","1","0","0"],
          ["0","0","0","1","1"]
        ]
        Output: 3
        
        Constraints:
        - m == grid.length
        - n == grid[i].length
        - 1 <= m, n <= 300
        - grid[i][j] is '0' or '1'.
        """,
        pattern: "graphBFS",
        tags: ["graph", "bfs", "dfs", "matrix", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        func numIslands(_ grid: [[Character]]) -> Int {
            guard !grid.isEmpty else { return 0 }
            var grid = grid
            var count = 0
            
            func bfs(_ row: Int, _ col: Int) {
                var queue = [(row, col)]
                grid[row][col] = "0"
                
                let directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]
                
                while !queue.isEmpty {
                    let (r, c) = queue.removeFirst()
                    
                    for (dr, dc) in directions {
                        let newR = r + dr
                        let newC = c + dc
                        
                        if newR >= 0 && newR < grid.count &&
                           newC >= 0 && newC < grid[0].count &&
                           grid[newR][newC] == "1" {
                            grid[newR][newC] = "0"
                            queue.append((newR, newC))
                        }
                    }
                }
            }
            
            for i in 0..<grid.count {
                for j in 0..<grid[0].count {
                    if grid[i][j] == "1" {
                        count += 1
                        bfs(i, j)
                    }
                }
            }
            
            return count
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Shortest Path in Binary Matrix",
        prompt: """
        Given an n x n binary matrix grid, return the length of the shortest clear path in the matrix. If there is no clear path, return -1.
        
        A clear path in a binary matrix is a path from the top-left cell (i.e., (0, 0)) to the bottom-right cell (i.e., (n - 1, n - 1)) such that:
        - All the visited cells of the path are 0.
        - All the adjacent cells of the path are 8-directionally connected.
        
        The length of a clear path is the number of visited cells of this path.
        
        Example 1:
        Input: grid = [[0,1],[1,0]]
        Output: 2
        
        Example 2:
        Input: grid = [[0,0,0],[1,1,0],[1,1,0]]
        Output: 4
        
        Constraints:
        - n == grid.length
        - n == grid[i].length
        - 1 <= n <= 100
        - grid[i][j] is 0 or 1
        """,
        pattern: "graphBFS",
        tags: ["graph", "bfs", "matrix", "shortest path", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        func shortestPathBinaryMatrix(_ grid: [[Int]]) -> Int {
            let n = grid.count
            guard grid[0][0] == 0 && grid[n-1][n-1] == 0 else { return -1 }
            
            var grid = grid
            var queue: [(Int, Int, Int)] = [(0, 0, 1)]  // row, col, distance
            grid[0][0] = 1  // Mark as visited
            
            let directions = [
                (-1, -1), (-1, 0), (-1, 1),
                (0, -1),           (0, 1),
                (1, -1),  (1, 0),  (1, 1)
            ]
            
            while !queue.isEmpty {
                let (row, col, dist) = queue.removeFirst()
                
                if row == n - 1 && col == n - 1 {
                    return dist
                }
                
                for (dr, dc) in directions {
                    let newR = row + dr
                    let newC = col + dc
                    
                    if newR >= 0 && newR < n &&
                       newC >= 0 && newC < n &&
                       grid[newR][newC] == 0 {
                        grid[newR][newC] = 1
                        queue.append((newR, newC, dist + 1))
                    }
                }
            }
            
            return -1
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Clone Graph",
        prompt: """
        Given a reference of a node in a connected undirected graph, return a deep copy (clone) of the graph.
        
        Each node in the graph contains a value (int) and a list (List[Node]) of its neighbors.
        
        class Node {
            public var val: Int
            public var neighbors: [Node?]
        }
        
        Example 1:
        Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
        Output: [[2,4],[1,3],[2,4],[1,3]]
        Explanation: There are 4 nodes in the graph.
        
        Constraints:
        - The number of nodes in the graph is in the range [0, 100].
        - 1 <= Node.val <= 100
        - Node.val is unique for each node.
        """,
        pattern: "graphDFS",
        tags: ["graph", "dfs", "hash map", "medium"],
        estimatedTimeMinutes: 12,
        canonicalSolution: """
        class Node {
            public var val: Int
            public var neighbors: [Node?]
            public init(_ val: Int) {
                self.val = val
                self.neighbors = []
            }
        }
        
        func cloneGraph(_ node: Node?) -> Node? {
            guard let node = node else { return nil }
            
            var visited = [Int: Node]()
            
            func dfs(_ node: Node) -> Node {
                if let clone = visited[node.val] {
                    return clone
                }
                
                let clone = Node(node.val)
                visited[node.val] = clone
                
                for neighbor in node.neighbors {
                    if let neighbor = neighbor {
                        clone.neighbors.append(dfs(neighbor))
                    }
                }
                
                return clone
            }
            
            return dfs(node)
        }
        """,
        testCases: []
    ),
    Problem(
        title: "Path Sum in Binary Tree",
        prompt: """
        Given the root of a binary tree and an integer targetSum, return true if the tree has a root-to-leaf path such that adding up all the values along the path equals targetSum.
        
        A leaf is a node with no children.
        
        Example 1:
        Input: root = [5,4,8,11,null,13,4,7,2,null,null,null,1], targetSum = 22
        Output: true
        Explanation: The root-to-leaf path with the target sum is 5->4->11->2.
        
        Example 2:
        Input: root = [1,2,3], targetSum = 5
        Output: false
        
        Constraints:
        - The number of nodes in the tree is in the range [0, 5000].
        - -1000 <= Node.val <= 1000
        - -1000 <= targetSum <= 1000
        """,
        pattern: "graphDFS",
        tags: ["tree", "dfs", "binary tree", "easy"],
        estimatedTimeMinutes: 8,
        canonicalSolution: """
        class TreeNode {
            public var val: Int
            public var left: TreeNode?
            public var right: TreeNode?
            public init(_ val: Int) {
                self.val = val
                self.left = nil
                self.right = nil
            }
        }
        
        func hasPathSum(_ root: TreeNode?, _ targetSum: Int) -> Bool {
            guard let root = root else { return false }
            
            // Leaf node
            if root.left == nil && root.right == nil {
                return root.val == targetSum
            }
            
            let remaining = targetSum - root.val
            return hasPathSum(root.left, remaining) || 
                   hasPathSum(root.right, remaining)
        }
        """,
        testCases: []
    )
]

// Convert to ProblemData format
let problemsData = fallbackProblems.map { problem in
    ProblemData(
        id: generateId(from: problem.title),
        title: problem.title,
        prompt: problem.prompt,
        pattern: problem.pattern,
        difficulty: inferDifficulty(from: problem.tags),
        tags: problem.tags.filter { !["easy", "medium", "hard"].contains($0) },
        estimatedTimeMinutes: problem.estimatedTimeMinutes,
        solutions: ["swift": problem.canonicalSolution],
        testCases: problem.testCases
    )
}

let config = ProblemConfig(problems: problemsData)

// Encode to JSON
let encoder = JSONEncoder()
encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

do {
    let jsonData = try encoder.encode(config)
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }
} catch {
    print("Error: \(error)")
}
