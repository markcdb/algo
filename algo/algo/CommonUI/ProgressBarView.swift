//
//  ProgressBarView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct ProgressBarView: View {
    let progress: Double // 0.0 to 1.0
    var color: Color = .blue
    var height: CGFloat = 8
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .cornerRadius(height / 2)
                
                // Progress
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * min(max(progress, 0), 1), height: height)
                    .cornerRadius(height / 2)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 20) {
        VStack(alignment: .leading) {
            Text("25% Complete")
                .font(.caption)
            ProgressBarView(progress: 0.25, color: .green)
        }
        
        VStack(alignment: .leading) {
            Text("50% Complete")
                .font(.caption)
            ProgressBarView(progress: 0.5, color: .blue)
        }
        
        VStack(alignment: .leading) {
            Text("75% Complete")
                .font(.caption)
            ProgressBarView(progress: 0.75, color: .orange)
        }
        
        VStack(alignment: .leading) {
            Text("100% Complete")
                .font(.caption)
            ProgressBarView(progress: 1.0, color: .purple)
        }
    }
    .padding()
}
