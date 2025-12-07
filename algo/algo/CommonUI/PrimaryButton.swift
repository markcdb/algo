//
//  PrimaryButton.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private var backgroundColor: Color {
        if isDestructive {
            return .red
        }
        return isEnabled ? .blue : .gray
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Start Drill") {
            print("Tapped")
        }
        
        PrimaryButton(title: "Disabled", action: {}, isEnabled: false)
        
        PrimaryButton(title: "Delete", action: {}, isDestructive: true)
    }
    .padding()
}
