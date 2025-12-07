//
//  algoApp.swift
//  algo
//
//  Created by Mark Buot on 4/12/25.
//

import SwiftUI

@main
struct algoApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.navigationPath) {
                HomeView(viewModel: coordinator.makeHomeViewModel())
                    .navigationDestination(for: AppRoute.self) { route in
                        destinationView(for: route)
                    }
            }
            .environmentObject(coordinator)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(viewModel: coordinator.makeHomeViewModel())
        case .drill:
            DrillView(viewModel: coordinator.makeDrillViewModel())
        case .reviewQueue:
            Text("Review Queue - Coming Soon")
        case .patternDetail(let pattern):
            Text("Pattern: \(pattern.name) - Coming Soon")
        }
    }
}
