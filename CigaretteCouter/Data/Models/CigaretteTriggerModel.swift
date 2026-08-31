//
//  CigaretteTriggerModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//



import Foundation

enum CigaretteTriggerModel: String, Codable, CaseIterable, Identifiable, Hashable {
    
    case stress
    case afterMeal
    case social
    case habit
    
    var id: String {
        rawValue
    }
    
    var title: String {
        switch self {
        case .stress: return "Stress"
        case .afterMeal: return "After Meal"
        case .social: return "Social"
        case .habit: return "Habit"
        }
    }
}
