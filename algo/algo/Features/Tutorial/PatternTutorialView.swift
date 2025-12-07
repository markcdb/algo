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
                VStack(spacing: 16) {
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
            .scrollBounceBehavior(.basedOnSize)
            
            // Controls - only show play button and completion button
            
            // Action button on last step only
            if isLastStep {
                VStack(spacing: 16) {
                    PrimaryButton(title: "I Got It! Start Drill") {
                        onComplete()
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    if value.translation.width < 0 {
                        // Swipe left - next step
                        nextStep()
                    } else if value.translation.width > 0 {
                        // Swipe right - previous step
                        previousStep()
                    }
                }
        )
        .navigationTitle(tutorial.steps.first?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isLastStep {
                    Button("Skip") {
                        onComplete()
                    }
                    .font(.subheadline)
                }
            }
        }
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
        }
    }
    
    private var visualizationView: some View {
        VStack(spacing: 16) {
            switch currentStep.visualization.type {
            case .array, .window:
                ArrayVisualization(data: currentStep.visualization)
            case .twoPointer:
                TwoPointerVisualization(data: currentStep.visualization)
            case .tree:
                TreeVisualization(data: currentStep.visualization)
            case .heap:
                HeapVisualization(data: currentStep.visualization)
            case .graph:
                GraphVisualization(data: currentStep.visualization)
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
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .frame(minWidth: 50, minHeight: 50)
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

// MARK: - Tree Visualization
struct TreeVisualization: View {
    let data: VisualizationData
    @State private var animatedNodes: Set<Int> = []
    
    // Define positions for binary tree layout
    private let nodePositions: [(x: CGFloat, y: CGFloat)] = [
        (180, 30),   // 0: Root - center top
        (100, 100),  // 1: Left child
        (260, 100),  // 2: Right child
        (50, 170),   // 3: Left-left grandchild
        (150, 170),  // 4: Left-right grandchild
        (210, 170),  // 5: Right-left grandchild
        (310, 170)   // 6: Right-right grandchild
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Tree with Canvas for edges
            ZStack {
                Canvas { context, size in
                    // Draw edges based on binary tree structure
                    let edges: [(from: Int, to: Int)] = [
                        (0, 1), // Root -> Left child
                        (0, 2), // Root -> Right child
                        (1, 3), // Left -> Left-left
                        (1, 4), // Left -> Left-right
                        (2, 5), // Right -> Right-left
                        (2, 6)  // Right -> Right-right
                    ]
                    
                    for edge in edges {
                        if edge.from < nodePositions.count && 
                           edge.to < nodePositions.count &&
                           edge.to < data.elements.count {
                            let from = nodePositions[edge.from]
                            let to = nodePositions[edge.to]
                            
                            var path = Path()
                            path.move(to: CGPoint(x: from.x, y: from.y))
                            path.addLine(to: CGPoint(x: to.x, y: to.y))
                            
                            context.stroke(
                                path,
                                with: .color(.gray.opacity(0.4)),
                                lineWidth: 2
                            )
                        }
                    }
                }
                .frame(height: 200)
                
                // Overlay nodes
                ForEach(Array(data.elements.prefix(7).enumerated()), id: \.element.id) { index, element in
                    nodeView(element, index: index)
                        .position(x: nodePositions[index].x, y: nodePositions[index].y)
                        .opacity(animatedNodes.contains(index) ? 1 : 0)
                        .scaleEffect(animatedNodes.contains(index) ? 1 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1), value: animatedNodes)
                }
            }
            .frame(height: 200)
            .onAppear {
                // Stagger node appearance
                for index in 0..<data.elements.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        animatedNodes.insert(index)
                    }
                }
            }
            
            // Legend for pointers
            if !data.pointers.isEmpty {
                HStack(spacing: 16) {
                    ForEach(data.pointers, id: \.name) { pointer in
                        HStack(spacing: 6) {
                            Circle()
                                .fill(colorForPointer(pointer.color))
                                .frame(width: 10, height: 10)
                            Text(pointer.name)
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(colorForPointer(pointer.color).opacity(0.15))
                        .cornerRadius(8)
                    }
                }
            }
            
            // State legend
            HStack(spacing: 20) {
                legendItem(color: .blue.opacity(0.3), border: .blue, label: "Current")
                legendItem(color: .gray.opacity(0.3), border: .gray, label: "Visited")
                legendItem(color: .green.opacity(0.3), border: .green, label: "Complete")
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
    
    private func nodeView(_ element: VisualElement, index: Int) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(backgroundForState(element.state))
                    .frame(width: 55, height: 55)
                
                Circle()
                    .stroke(borderForState(element.state), lineWidth: 3)
                    .frame(width: 55, height: 55)
                
                Text(element.value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(foregroundForState(element.state))
            }
            .shadow(color: borderForState(element.state).opacity(0.3), radius: 4, x: 0, y: 2)
            .animation(.easeInOut(duration: 0.3), value: element.state)
            
            // Pointer indicator below node
            if let pointer = data.pointers.first(where: { $0.index == index }) {
                Text(pointer.name)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(colorForPointer(pointer.color))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(colorForPointer(pointer.color).opacity(0.2))
                    .cornerRadius(4)
            }
        }
    }
    
    private func legendItem(color: Color, border: Color, label: String) -> some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                Circle()
                    .stroke(border, lineWidth: 2)
                    .frame(width: 16, height: 16)
            }
            Text(label)
                .font(.caption)
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

// MARK: - Heap Visualization
struct HeapVisualization: View {
    let data: VisualizationData
    @State private var animatedNodes: Set<Int> = []
    @State private var pulseSync: Bool = false
    
    // Define positions for heap tree layout
    private let nodePositions: [(x: CGFloat, y: CGFloat)] = [
        (180, 30),   // 0: Root
        (100, 100),  // 1: Left child
        (260, 100),  // 2: Right child
        (50, 170),   // 3: Position 3
        (150, 170),  // 4: Position 4
        (210, 170),  // 5: Position 5
        (310, 170)   // 6: Position 6
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Heap (Priority Queue)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            // Tree structure with edges
            ZStack {
                Canvas { context, size in
                    // Draw parent-child connections
                    let edges: [(from: Int, to: Int)] = [
                        (0, 1), (0, 2),  // Root connections
                        (1, 3), (1, 4),  // Left child connections
                        (2, 5), (2, 6)   // Right child connections
                    ]
                    
                    for edge in edges {
                        if edge.to < data.elements.count {
                            let from = nodePositions[edge.from]
                            let to = nodePositions[edge.to]
                            
                            var path = Path()
                            path.move(to: CGPoint(x: from.x, y: from.y))
                            path.addLine(to: CGPoint(x: to.x, y: to.y))
                            
                            context.stroke(
                                path,
                                with: .color(.gray.opacity(0.4)),
                                lineWidth: 2
                            )
                        }
                    }
                }
                .frame(height: 200)
                
                // Overlay nodes with labels
                ForEach(Array(data.elements.prefix(7).enumerated()), id: \.element.id) { index, element in
                    nodeView(element, index: index, isRoot: index == 0)
                        .position(x: nodePositions[index].x, y: nodePositions[index].y)
                        .opacity(animatedNodes.contains(index) ? 1 : 0)
                        .scaleEffect(animatedNodes.contains(index) ? 1 : 0.5)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(Double(index) * 0.1), value: animatedNodes)
                        .scaleEffect(pulseSync && element.state == .active ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: pulseSync)
                }
            }
            .frame(height: 200)
            .onAppear {
                // Stagger node appearance
                for index in 0..<min(data.elements.count, 7) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                        animatedNodes.insert(index)
                    }
                }
                
                // Sync pulse between tree and array
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
                    pulseSync.toggle()
                }
            }
            
            Divider()
                .padding(.horizontal)
            
            // Array representation - shows how heap is stored
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "square.stack.3d.up")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("Array Storage:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(data.elements.enumerated()), id: \.element.id) { index, element in
                            VStack(spacing: 3) {
                                Text(element.value)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(foregroundForState(element.state))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(backgroundForState(element.state))
                                    .cornerRadius(6)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(borderForState(element.state), lineWidth: 1.5)
                                    )
                                    .scaleEffect(pulseSync && element.state == .active ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 0.3), value: pulseSync)
                                
                                Text("[\(index)]")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal)
            
            // Heap property explanation
            if let pointer = data.pointers.first {
                HStack(spacing: 8) {
                    Circle()
                        .fill(colorForPointer(pointer.color))
                        .frame(width: 10, height: 10)
                    Text(pointer.name)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(colorForPointer(pointer.color).opacity(0.15))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }
    
    private func nodeView(_ element: VisualElement, index: Int, isRoot: Bool) -> some View {
        VStack(spacing: 3) {
            ZStack {
                Circle()
                    .fill(backgroundForState(element.state))
                    .frame(width: 50, height: 50)
                
                Circle()
                    .stroke(borderForState(element.state), lineWidth: 2.5)
                    .frame(width: 50, height: 50)
                
                Text(element.value)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(foregroundForState(element.state))
            }
            .shadow(color: borderForState(element.state).opacity(0.3), radius: 3, x: 0, y: 2)
            .animation(.easeInOut(duration: 0.3), value: element.state)
            
            if isRoot {
                Text("root")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.15))
                    .cornerRadius(4)
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

// MARK: - Graph Visualization
struct GraphVisualization: View {
    let data: VisualizationData
    @State private var animatedNodes: Set<Int> = []
    
    // Define node positions for better layout
    private let nodePositions: [(x: CGFloat, y: CGFloat)] = [
        (180, 30),   // A - center top
        (80, 110),   // B - left middle
        (280, 110),  // C - right middle
        (40, 190),   // D - bottom left
        (280, 190)   // E - bottom right
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            // Graph with Canvas for precise edge drawing
            ZStack {
                Canvas { context, size in
                    // Draw edges (connections)
                    let edges: [(from: Int, to: Int)] = [
                        (0, 1), // A -> B
                        (0, 2), // A -> C
                        (1, 3), // B -> D
                        (2, 4)  // C -> E
                    ]
                    
                    for edge in edges {
                        if edge.from < nodePositions.count && edge.to < nodePositions.count {
                            let from = nodePositions[edge.from]
                            let to = nodePositions[edge.to]
                            
                            var path = Path()
                            path.move(to: CGPoint(x: from.x, y: from.y))
                            path.addLine(to: CGPoint(x: to.x, y: to.y))
                            
                            context.stroke(
                                path,
                                with: .color(.gray.opacity(0.4)),
                                lineWidth: 3
                            )
                        }
                    }
                }
                .frame(height: 220)
                
                // Overlay nodes on top of edges
                ForEach(Array(data.elements.prefix(5).enumerated()), id: \.element.id) { index, element in
                    nodeView(element, index: index)
                        .position(x: nodePositions[index].x, y: nodePositions[index].y)
                        .opacity(animatedNodes.contains(index) ? 1 : 0)
                        .scaleEffect(animatedNodes.contains(index) ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(Double(index) * 0.15), value: animatedNodes)
                }
            }
            .frame(height: 220)
            .onAppear {
                // Stagger node appearance
                for index in 0..<min(data.elements.count, 5) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.15) {
                        animatedNodes.insert(index)
                    }
                }
            }
            
            // Queue/Stack indicator for BFS/DFS
            if !data.pointers.isEmpty {
                VStack(spacing: 8) {
                    Text("Traversal State:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        ForEach(data.pointers, id: \.name) { pointer in
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(colorForPointer(pointer.color))
                                    .frame(width: 10, height: 10)
                                Text(pointer.name)
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(colorForPointer(pointer.color).opacity(0.15))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Visited nodes legend
            HStack(spacing: 20) {
                legendItem(color: .blue.opacity(0.3), border: .blue, label: "Current")
                legendItem(color: .gray.opacity(0.3), border: .gray, label: "Visited")
                legendItem(color: .green.opacity(0.3), border: .green, label: "Complete")
            }
            .font(.caption)
        }
        .padding(.vertical, 8)
    }
    
    private func nodeView(_ element: VisualElement, index: Int) -> some View {
        ZStack {
            Circle()
                .fill(backgroundForState(element.state))
                .frame(width: 60, height: 60)
            
            Circle()
                .stroke(borderForState(element.state), lineWidth: 3)
                .frame(width: 60, height: 60)
            
            Text(element.value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(foregroundForState(element.state))
        }
        .shadow(color: borderForState(element.state).opacity(0.3), radius: 4, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.3), value: element.state)
    }
    
    private func legendItem(color: Color, border: Color, label: String) -> some View {
        HStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 16, height: 16)
                Circle()
                    .stroke(border, lineWidth: 2)
                    .frame(width: 16, height: 16)
            }
            Text(label)
                .font(.caption)
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
        case "orange": return .orange
        default: return .blue
        }
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
