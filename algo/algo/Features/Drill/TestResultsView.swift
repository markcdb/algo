//
//  TestResultsView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct TestResultsView: View {
    let results: [TestResult]
    
    var passedCount: Int {
        results.filter { $0.passed }.count
    }
    
    var totalCount: Int {
        results.count
    }
    
    var allPassed: Bool {
        passedCount == totalCount
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Summary header
            HStack {
                Image(systemName: allPassed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(allPassed ? .green : .red)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Test Results")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(passedCount) of \(totalCount) tests passed")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(
                (allPassed ? Color.green : Color.red)
                    .opacity(0.1)
            )
            .cornerRadius(12)
            
            // Console Output (if available from first test)
            if let firstResult = results.first, !firstResult.actualOutput.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "terminal")
                            .foregroundColor(.green)
                        Text("Console Output")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    
                    ScrollView {
                        Text(firstResult.actualOutput)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                    .frame(maxHeight: 150)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(12)
            }
            
            // Individual test results
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                    TestCaseResultRow(index: index + 1, result: result)
                }
            }
        }
    }
}

struct TestCaseResultRow: View {
    let index: Int
    let result: TestResult
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    Image(systemName: result.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(result.passed ? .green : .red)
                    
                    Text("Test Case \(index)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    if !result.passed {
                        Text("Failed")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(.plain)
            
            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Input
                    DetailSection(title: "Input", content: result.testCase.input, color: .blue)
                    
                    // Expected vs Actual
                    HStack(alignment: .top, spacing: 12) {
                        DetailSection(
                            title: "Expected",
                            content: result.testCase.expectedOutput,
                            color: .green
                        )
                        
                        DetailSection(
                            title: "Actual",
                            content: result.actualOutput.isEmpty ? "(no output)" : result.actualOutput,
                            color: result.passed ? .green : .red
                        )
                    }
                    
                    // Error message if any
                    if let error = result.error {
                        DetailSection(title: "Error", content: error, color: .red)
                    }
                    
                    // Explanation if available
                    if let explanation = result.testCase.explanation {
                        Text(explanation)
                            .font(.caption)
                            .italic()
                            .foregroundColor(.secondary)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.tertiarySystemBackground))
                            .cornerRadius(6)
                    }
                }
                .padding(.leading, 28)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(content)
                .font(.system(.caption, design: .monospaced))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(color.opacity(0.05))
                .cornerRadius(6)
        }
    }
}

#Preview {
    ScrollView {
        TestResultsView(results: [
            TestResult(
                testCase: TestCase(
                    input: "abcabcbb",
                    expectedOutput: "3",
                    explanation: "The answer is \"abc\", with the length of 3."
                ),
                passed: true,
                actualOutput: "3"
            ),
            TestResult(
                testCase: TestCase(
                    input: "bbbbb",
                    expectedOutput: "1"
                ),
                passed: false,
                actualOutput: "2",
                error: "Wrong answer"
            ),
            TestResult(
                testCase: TestCase(
                    input: "pwwkew",
                    expectedOutput: "3"
                ),
                passed: true,
                actualOutput: "3"
            )
        ])
        .padding()
    }
}
