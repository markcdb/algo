//
//  TagView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct TagView: View {
    let text: String
    var color: Color = .blue
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .cornerRadius(6)
    }
}

#Preview {
    HStack {
        TagView(text: "Easy", color: .green)
        TagView(text: "Medium", color: .orange)
        TagView(text: "Hard", color: .red)
        TagView(text: "Sliding Window")
    }
    .padding()
}
