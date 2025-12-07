//
//  PistonCodeExecutor.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation

/// Implementation of CodeExecutionService using Piston API
/// https://github.com/engineer-man/piston
class PistonCodeExecutor: CodeExecutionService {
    private let baseURL = "https://emkc.org/api/v2/piston"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Language Mapping
    
    /// Maps our SupportedLanguage to Piston API language identifiers
    private func pistonLanguage(from language: String) -> (language: String, version: String)? {
        let lang = language.lowercased()
        
        switch lang {
        case "swift":
            return ("swift", "5.9.0")
        case "python":
            return ("python", "3.10.0")
        case "java":
            return ("java", "15.0.2")
        case "javascript", "js":
            return ("javascript", "18.15.0")
        case "c++", "cpp":
            return ("c++", "10.2.0")
        default:
            return nil
        }
    }
    
    // MARK: - Execute Code
    
    func execute(request: ExecutionRequest) async throws -> ExecutionResult {
        guard let (language, version) = pistonLanguage(from: request.language) else {
            throw CodeExecutionError.unsupportedLanguage(request.language)
        }
        
        // Build Piston API request
        let url = URL(string: "\(baseURL)/execute")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "language": language,
            "version": version,
            "files": [
                [
                    "name": "main.\(fileExtension(for: language))",
                    "content": request.code
                ]
            ],
            "stdin": request.stdin ?? ""
        ]
        
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        // Execute request
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CodeExecutionError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw CodeExecutionError.apiError("HTTP \(httpResponse.statusCode)")
        }
        
        // Parse response
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let run = json["run"] as? [String: Any] else {
            throw CodeExecutionError.invalidResponse
        }
        
        let stdout = run["stdout"] as? String ?? ""
        let stderr = run["stderr"] as? String ?? ""
        let exitCode = run["code"] as? Int ?? 1
        
        return ExecutionResult(
            stdout: stdout,
            stderr: stderr,
            exitCode: exitCode,
            executionTime: nil
        )
    }
    
    // MARK: - Run Tests
    
    func runTests(code: String, language: String, testCases: [TestCase]) async throws -> [TestResult] {
        var results: [TestResult] = []
        
        for testCase in testCases {
            let request = ExecutionRequest(
                language: language,
                code: code,  // Code should already include wrapper from Solution.executableCode
                stdin: testCase.input
            )
            
            do {
                let execution = try await execute(request: request)
                
                let actualOutput = execution.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
                let expectedOutput = testCase.expectedOutput.trimmingCharacters(in: .whitespacesAndNewlines)
                let passed = actualOutput == expectedOutput && execution.isSuccess
                
                let result = TestResult(
                    testCase: testCase,
                    passed: passed,
                    actualOutput: execution.stdout,
                    executionTime: execution.executionTime,
                    error: execution.stderr.isEmpty ? nil : execution.stderr
                )
                
                results.append(result)
            } catch {
                // If execution fails, record as failed test
                let result = TestResult(
                    testCase: testCase,
                    passed: false,
                    actualOutput: "",
                    error: error.localizedDescription
                )
                results.append(result)
            }
        }
        
        return results
    }
    
    // MARK: - Helpers
    
    private func fileExtension(for language: String) -> String {
        switch language {
        case "swift": return "swift"
        case "python": return "py"
        case "java": return "java"
        case "javascript": return "js"
        case "c++": return "cpp"
        default: return "txt"
        }
    }
}
