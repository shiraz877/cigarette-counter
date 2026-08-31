//
//  AnalyticsModels.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//

import Foundation
import Foundation

struct WeeklyData: Identifiable, Sendable {
    let id = UUID()
    let day: String
    let value: Int
}

struct MonthlyData: Identifiable, Sendable {
    let id = UUID()
    let day: Int
    let value: Int
}

struct TimeDistributionData: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let percentage: Double
}

struct AnalyticsRecommendation: Identifiable, Sendable {
    let id = UUID()
    let icon: String
    let message: String
}
