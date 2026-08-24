////
////  AppViewModel.swift
////  CigaretteCouter
////
////  Created by Shiraz on 18/08/26.
////
//
//import SwiftUI
//import Observation
//
//@Observable
//@MainActor
//final class AppViewModel {
//    
//    var selectedTab: MainTab = .home
//
//    enum MainTab: String, CaseIterable, Hashable {
//        case home
//        case analytics
//        case settings
//
//        var title: String {
//            switch self {
//            case .home:
//                "Home"
//
//            case .analytics:
//                "Analytics"
//
//            case .settings:
//                "Settings"
//            }
//        }
//
//        var iconName: String {
//            switch self {
//            case .home:
//                "house.fill"
//
//            case .analytics:
//                "chart.bar.xaxis"
//
//            case .settings:
//                "gearshape.fill"
//            }
//        }
//    }
//}
//
//  AppViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI
import Observation

@Observable
final class AppViewModel {
    
    var hasCompletedOnboarding: Bool
    var selectedTab: MainTab = .home

    enum MainTab: Int, CaseIterable, Identifiable {
        case home
        case analytics
        case settings
        
        var id: Int { rawValue }

        var title: String {
            switch self {
            case .home: return "Home"
            case .analytics: return "Analytics"
            case .settings: return "Settings"
            }
        }

        var iconName: String {
            switch self {
            case .home: return "house.fill"
            case .analytics: return "chart.bar.xaxis"
            case .settings: return "gearshape.fill"
            }
        }
    }
    
    func completeOnboarding(){
        UserPreferences.shared.hasCompletedOnboarding = true
        hasCompletedOnboarding = true
    }
    
    init(){
        hasCompletedOnboarding = UserPreferences.shared.hasCompletedOnboarding
    }
}
