//
//  MockRouter.swift
//  algo
//
//  Created by Copilot on 12/7/25.
//

import Foundation

/// Mock router for previews and tests
class MockRouter: AppRouting {
    var pushedRoutes: [AppRoute] = []
    var popCount = 0
    var popToRootCount = 0
    
    func push(_ route: AppRoute) {
        pushedRoutes.append(route)
    }
    
    func pop() {
        popCount += 1
    }
    
    func popToRoot() {
        popToRootCount += 1
    }
}
