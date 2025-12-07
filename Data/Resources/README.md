# Problem Configuration System

## Overview

Problems are now defined in **JSON configuration files** instead of hardcoded Swift. This makes it easy to:
- ✅ Add/edit problems without recompiling
- ✅ Support multiple programming languages (Swift, Python, Java, JavaScript, C++)
- ✅ Manage test cases separately
- ✅ Version control problem content independently

## File Structure

```
Data/
├── Resources/
│   └── problems.json          # Main problem definitions
├── Config/
│   └── ProblemConfigLoader.swift  # JSON loader
└── InMemoryProblemRepository.swift  # Uses JSON or fallback
```

## Problem JSON Format

```json
{
  "problems": [
    {
      "id": "unique-problem-id",
      "title": "Problem Title",
      "prompt": "Full problem description with examples and constraints",
      "pattern": "slidingWindow",
      "difficulty": "medium",
      "tags": ["tag1", "tag2"],
      "estimatedTimeMinutes": 10,
      "solutions": {
        "swift": "// Swift solution code",
        "python": "# Python solution code",
        "java": "// Java solution code"
      },
      "testCases": [
        {
          "input": "test input",
          "expectedOutput": "expected output",
          "explanation": "why this is the answer"
        }
      ]
    }
  ]
}
```

## Supported Patterns

- `slidingWindow`
- `twoPointers`
- `binarySearch`
- `heap`
- `graphBFS`
- `graphDFS`
- `intervals`
- `dynamicProgramming`

## Adding Multi-Language Support

### For Each Problem:

1. Add solution code for each language in the `solutions` object
2. Each solution must:
   - Read input from stdin
   - Print output to stdout
   - Match the expected I/O format

### Language-Specific Solution Format:

**Swift:**
```swift
func solve() -> String {
    // solution
}
print(solve(readLine()!))
```

**Python:**
```python
def solve(input_data):
    # solution
    return result

print(solve(input()))
```

**Java:**
```java
import java.util.*;

public class Solution {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // solution
        System.out.println(result);
    }
}
```

## How It Works

1. **App Startup**: `InMemoryProblemRepository` initializes
2. **Load JSON**: `ProblemConfigLoader.loadProblems()` reads `problems.json`
3. **Parse & Convert**: JSON → `ProblemData` → `Problem` models
4. **Fallback**: If JSON fails, uses hardcoded `fallbackProblems` in Swift

## Benefits

### Before (Hardcoded):
```swift
// 1200+ lines of Swift code
static let mockProblems: [Problem] = [
    Problem(title: "...", solution: "...", testCases: [...])
    // x21 problems
]
```

### After (JSON Config):
```json
// Clean, language-agnostic data
{
  "problems": [...]  // Easy to edit, validate, version
}
```

## Migration Status

✅ Infrastructure complete (loader, models, repository)
✅ First problem migrated with Swift/Python/Java
⏳ Need to migrate remaining 20 problems

## Next Steps

1. Run `scripts/convert_problems_to_json.py` to extract all problems
2. Add Python/Java solutions for each problem
3. Test with `ProblemConfigLoader.loadProblems()`
4. Remove hardcoded `fallbackProblems` once JSON is complete
