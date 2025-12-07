//
//  CodeEditorView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI
import CodeEditor

struct CodeEditorView: View {
    @Binding var code: String
    @Binding var language: SupportedLanguage
    var isEditable: Bool = true
    var placeholder: String = "Write your solution here..."
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with language picker or badge
            HStack {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundColor(.secondary)
                Text("Code")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                
                if isEditable {
                    // Language Picker (editable mode)
                    Picker("Language", selection: $language) {
                        Text("Swift").tag(SupportedLanguage.swift)
                        Text("Python").tag(SupportedLanguage.python)
                        Text("Java").tag(SupportedLanguage.java)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 200)
                    .onChange(of: language, {
                        updateCode()
                    })
                    
                } else {
                    // Language badge (read-only mode)
                    Text(language.displayName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.secondarySystemBackground))
            
            // Editor with syntax highlighting
            CodeEditor(
                source: $code,
                language: language.editorLanguage,
                theme: .ocean,
                flags: isEditable ? .defaultEditorFlags : [.selectable],
                indentStyle: .system
            )
            .id(language)
            .frame(minHeight: 200)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func updateCode() {
        // Generate a starter template based on the language
        switch language {
        case .swift:
            code = "func solve() {\n    // Your solution here\n}\n"
        case .python:
            code = "def solve():\n    # Your solution here\npass\n"
        case .java:
            code = "public void solve() {\n    // Your solution here\n}\n"
        case .javascript:
            code = "function solve() {\n    // Your solution here\n}\n"
        case .cpp:
            code = "void solve() {\n    // Your solution here\n}\n"
        }
    }
}

#Preview {
    VStack(spacing: 20) {
//        CodeEditorView(
//            code: .constant("func solve() {\n    // Your Swift solution\n}"),
//            language: .swift
//        )
//        .frame(height: 200)
//        
//        CodeEditorView(
//            code: .constant("def solve():\n    # Your Python solution\n    pass"),
//            language: .python
//        )
//        .frame(height: 200)
//        
//        CodeEditorView(
//            code: .constant("public class Solution {\n    public void solve() {\n        // Your Java solution\n    }\n}"),
//            language: .java
//        )
//        .frame(height: 200)
    }
    .padding()
}
