//
//  SupportedLanguage.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import Foundation
import CodeEditor

enum SupportedLanguage: String, Codable, CaseIterable {
    case swift
    case python
    case java
    case javascript
    case cpp = "C++"
    
    var displayName: String {
        switch self {
        case .cpp:
            return "C++"
        default:
            return rawValue.capitalized
        }
    }
    
    var fileExtension: String {
        switch self {
        case .swift: return ".swift"
        case .python: return ".py"
        case .java: return ".java"
        case .javascript: return ".js"
        case .cpp: return ".cpp"
        }
    }
    
    var editorLanguage: CodeEditor.Language {
        switch self {
        case .swift:
            return .swift
        case .python:
            return .python
        case .java:
            return .java
        case .javascript:
            return .javascript
        case .cpp:
            return .cpp
        }
    }
}
