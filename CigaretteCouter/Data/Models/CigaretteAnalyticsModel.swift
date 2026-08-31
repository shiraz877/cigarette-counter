//
//  CigaretteAnalyticsModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//


import Foundation

struct CigaretteAnalytics: Sendable {

    let todayCount: Int
    let weeklyCount: Int
    let monthlyCount: Int

    let weeklyData: [WeeklyData]
    let monthlyData: [MonthlyData]

    let averageGap: TimeInterval?
    let longestGap: TimeInterval?

    let timeDistribution: [TimeDistributionData]

    let mostFrequentHour: Int?

    let recommendations: [AnalyticsRecommendation]
}
