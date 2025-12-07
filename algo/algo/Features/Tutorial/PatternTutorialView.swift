//
//  PatternTutorialView.swift
//  algo
//
//  Created by Copilot on 12/4/25.
//

import SwiftUI

struct PatternTutorialView: View {
    let tutorial: PatternTutorial
    let onComplete: () -> Void
    
    @State private var currentStepIndex = 0
    @State private var isPlaying = false
    @State private var playbackTimer: Timer?
    
    private var currentStep: TutorialStep {
        tutorial.steps[currentStepIndex]
    }
    
    private var isFirstStep: Bool {
        currentStepIndex == 0
    }
    
    private var isLastStep: Bool {
        currentStepIndex == tutorial.steps.count - 1
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            progressBar
            
            ScrollView {
                VStack(spacing: 24) {
                    // Step title
                    stepHeader
                    
                    // Visual representation
                    visualizationView
                    
                    // Explanation
                    explanationCard
                    
                    // Code snippet (if available)
                    if let code = currentStep.code {
                        codeSnippet(code)
                    }
                    
                    // Key insights (show on last step)
                    if isLastStep {
                        keyInsightsCard
                    }
                }
                .padding()
            }
            
            // Controls
            controlBar
        }
        .navigationTitle("Learn: \(tutorial.steps.first?.title ?? "")")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var progressBar: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * CGFloat(currentStepIndex + 1) / CGFloat(tutorial.steps.count))
            }
        }
        .frame(height: 4)
    }
    
    private var stepHeader: some View {
        VStack(spacing: 8) {
            Text("Step \(currentStepIndex + 1) of \(tutorial.steps.count)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(currentStep.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
    }
    
    private var visualizationView: some View {
        VStack(spacing: 16) {
            switch currentStep.visualization.type {
            case .array, .window:
                ArrayVisualization(data: currentStep.visualization)
            case .twoPointer:
                TwoPointerVisualization(data: currentStep.visualization)
            default:
                ArrayVisualization(data: currentStep.visualization)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var explanationCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("What's Happening")
                    .font(.headline)
            }
            
            Text(currentStep.explanation)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func codeSnippet(_ code: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .foregroundColor(.secondary)
                Text("Code")
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Text(code)
                .font(.system(.body, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var keyInsightsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
                Text("Key Insights")
                    .font(.headline)
            }
            
            ForEach(tutorial.keyInsights, id: \.self) { insight in
                HStack(alignment: .top, spacing: 8) {
                    Text(insight)
                        .font(.body)
                }
                .padding(.vertical, 4)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("⏱️ Time:")
                        .fontWeight(.semibold)
                    Text(tutorial.timeComplexity)
                }
                HStack {
                    Text("💾 Space:")
                        .fontWeight(.semibold)
                    Text(tutorial.spaceComplexity)
                }
            }
            .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var controlBar: some View {
        VStack(spacing: 12) {
            // Playback controls
            HStack(spacing: 20) {
                Button {
                    previousStep()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                }
                .disabled(isFirstStep)
                
                Button {
                    isPlaying.toggle()
                    if isPlaying {
                        startAutoplay()
                    } else {
                        stopAutoplay()
                    }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                
                Button {
                    nextStep()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .frame(width: 44, height: 44)
                }
                .disabled(isLastStep)
            }
            
            // Action button
            if isLastStep {
                PrimaryButton(title: "I Got It! Start Drill") {
                    onComplete()
                }
                .padding(.horizontal)
            } else {
                Button("Skip Tutorial") {
                    onComplete()
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Actions
    
    private func nextStep() {
        guard currentStepIndex < tutorial.steps.count - 1 else { return }
        withAnimation(.spring(response: 0.3)) {
            currentStepIndex += 1
        }
    }
    
    private func previousStep() {
        guard currentStepIndex > 0 else { return }
        withAnimation(.spring(response: 0.3)) {
            currentStepIndex -= 1
        }
    }
    
    private func startAutoplay() {
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            if isLastStep {
                stopAutoplay()
            } else {
                nextStep()
            }
        }
    }
    
    private func stopAutoplay() {
        isPlaying = false
        playbackTimer?.invalidate()
        playbackTimer = nil
    }
}

// MARK: - Array Visualization
struct ArrayVisualization: View {
    let data: VisualizationData
    
    var body: some View {
        VStack(spacing: 16) {
            // Array elements
            HStack(spacing: 8) {
                ForEach(Array(data.elements.enumerated()), id: \.element.id) { index, element in
                    VStack(spacing: 4) {
                        // Pointers above
                        if let pointer = data.pointers.first(where: { $0.index == index }) {
                            Text(pointer.name)
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(colorForPointer(pointer.color))
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption2)
                                .foregroundColor(colorForPointer(pointer.color))
                        } else {
                            Spacer()
                                .frame(height: 24)
                        }
                        
                        // Element box
                        Text(element.value)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .frame(width: 50, height: 50)
                            .background(backgroundForState(element.state))
                            .foregroundColor(foregroundForState(element.state))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(borderForState(element.state), lineWidth: 2)
                            )
                        
                        // Index below
                        Text("\(index)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // Window indicator (if window type)
            if data.type == .window && !data.highlights.isEmpty {
                Text("Window Size: \(data.highlights.count)")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
    
    private func backgroundForState(_ state: ElementState) -> Color {
        switch state {
        case .normal: return Color(UIColor.systemBackground)
        case .active: return Color.blue.opacity(0.3)
        case .visited: return Color.gray.opacity(0.3)
        case .result: return Color.green.opacity(0.3)
        case .excluded: return Color.red.opacity(0.1)
        }
    }
    
    private func foregroundForState(_ state: ElementState) -> Color {
        switch state {
        case .excluded: return .secondary
        default: return .primary
        }
    }
    
    private func borderForState(_ state: ElementState) -> Color {
        switch state {
        case .normal, .visited: return Color.gray.opacity(0.3)
        case .active: return Color.blue
        case .result: return Color.green
        case .excluded: return Color.red.opacity(0.3)
        }
    }
    
    private func colorForPointer(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        default: return .orange
        }
    }
}

// MARK: - Two Pointer Visualization
struct TwoPointerVisualization: View {
    let data: VisualizationData
    
    var body: some View {
        ArrayVisualization(data: data)
    }
}

#Preview {
    NavigationStack {
        PatternTutorialView(
            tutorial: PatternTutorial.slidingWindowTutorial(),
            onComplete: {
                print("Tutorial completed")
            }
        )
    }
}
