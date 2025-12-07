//
//  AppRouting.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

/// Protocol for navigation in the app
/// ViewModels depend on this instead of AppCoordinator directly
protocol AppRouting {
    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
}
