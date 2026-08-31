//
//  AnalyticsService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//

import Foundation

protocol AnalyticsServiceProtocol: Sendable {
    func getAnalytics(
        userId: String
    ) async throws -> CigaretteAnalytics
}

final class AnalyticsService:
    AnalyticsServiceProtocol,
    @unchecked Sendable {

    static let shared = AnalyticsService()

    private let cigaretteService: CigaretteRecordServiceProtocol

    private init(
        cigaretteService: CigaretteRecordServiceProtocol =
            CigaretteRecordService.shared
    ) {
        self.cigaretteService = cigaretteService
    }

    // MARK: - Public

    func getAnalytics(
        userId: String
    ) async throws -> CigaretteAnalytics {

        let cigarettes = try await cigaretteService.getAllCigarettes(
            userId: userId
        )

        return calculateAnalytics(
            cigarettes: cigarettes,
            referenceDate: Date()
        )
    }

    // MARK: - Main Calculation

    private func calculateAnalytics(
        cigarettes: [CigaretteModel],
        referenceDate: Date
    ) -> CigaretteAnalytics {

        let calendar = Calendar.current

        let todayCount = calculateTodayCount(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let weeklyCount = calculateWeeklyCount(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let monthlyCount = calculateMonthlyCount(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let weeklyData = calculateWeeklyData(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let monthlyData = calculateMonthlyData(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let averageGap = calculateAverageGap(
            cigarettes: cigarettes,
            referenceDate: referenceDate
        )

        let longestGap = calculateLongestGap(
            cigarettes: cigarettes,
            referenceDate: referenceDate
        )

        let timeDistribution = calculateTimeDistribution(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        let mostFrequentHour = calculateMostFrequentHour(
            cigarettes: cigarettes,
            calendar: calendar
        )

        let recommendations = generateRecommendations(
            cigarettes: cigarettes,
            calendar: calendar,
            date: referenceDate
        )

        return CigaretteAnalytics(
            todayCount: todayCount,
            weeklyCount: weeklyCount,
            monthlyCount: monthlyCount,
            weeklyData: weeklyData,
            monthlyData: monthlyData,
            averageGap: averageGap,
            longestGap: longestGap,
            timeDistribution: timeDistribution,
            mostFrequentHour: mostFrequentHour,
            recommendations: recommendations
        )
    }

    // MARK: - Today

    private func calculateTodayCount(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> Int {

        cigarettes.filter {
            calendar.isDate(
                $0.smokedAt,
                inSameDayAs: date
            )
        }.count
    }

    // MARK: - Week

    private func calculateWeeklyCount(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> Int {

        let startOfToday = calendar.startOfDay(
            for: date
        )

        guard let weekStart = calendar.date(
            byAdding: .day,
            value: -6,
            to: startOfToday
        ) else {
            return 0
        }

        return cigarettes.filter {
            $0.smokedAt >= weekStart &&
            $0.smokedAt <= date
        }.count
    }

    // MARK: - Month

    private func calculateMonthlyCount(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> Int {

        guard let monthStart = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: date
            )
        ) else {
            return 0
        }

        return cigarettes.filter {
            $0.smokedAt >= monthStart &&
            $0.smokedAt <= date
        }.count
    }

    // MARK: - Weekly Data

    private func calculateWeeklyData(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> [WeeklyData] {

        let startOfToday = calendar.startOfDay(
            for: date
        )

        return (0..<7).reversed().map { offset in

            guard let currentDate = calendar.date(
                byAdding: .day,
                value: -offset,
                to: startOfToday
            ) else {
                return WeeklyData(
                    day: "",
                    value: 0
                )
            }

            let count = cigarettes.filter {
                calendar.isDate(
                    $0.smokedAt,
                    inSameDayAs: currentDate
                )
            }.count

            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"

            return WeeklyData(
                day: formatter.string(
                    from: currentDate
                ).uppercased(),
                value: count
            )
        }
    }

    // MARK: - Monthly Data

    private func calculateMonthlyData(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> [MonthlyData] {

        guard let range = calendar.range(
            of: .day,
            in: .month,
            for: date
        ) else {
            return []
        }

        return range.map { day in

            var components = calendar.dateComponents(
                [.year, .month],
                from: date
            )

            components.day = day

            guard let currentDate = calendar.date(
                from: components
            ) else {
                return MonthlyData(
                    day: day,
                    value: 0
                )
            }

            let count = cigarettes.filter {
                calendar.isDate(
                    $0.smokedAt,
                    inSameDayAs: currentDate
                )
            }.count

            return MonthlyData(
                day: day,
                value: count
            )
        }
    }

    // MARK: - Average Gap

    private func calculateAverageGap(
        cigarettes: [CigaretteModel],
        referenceDate: Date
    ) -> TimeInterval? {

        let sorted = cigarettes
            .filter {
                $0.smokedAt <= referenceDate
            }
            .sorted {
                $0.smokedAt < $1.smokedAt
            }

        guard sorted.count >= 2 else {
            return nil
        }

        var totalGap: TimeInterval = 0

        for index in 1..<sorted.count {

            let gap = sorted[index]
                .smokedAt
                .timeIntervalSince(
                    sorted[index - 1].smokedAt
                )

            totalGap += gap
        }

        return totalGap / Double(sorted.count - 1)
    }

    // MARK: - Longest Gap

    private func calculateLongestGap(
        cigarettes: [CigaretteModel],
        referenceDate: Date
    ) -> TimeInterval? {

        let sorted = cigarettes
            .filter {
                $0.smokedAt <= referenceDate
            }
            .sorted {
                $0.smokedAt < $1.smokedAt
            }

        guard sorted.count >= 2 else {
            return nil
        }

        var longestGap: TimeInterval = 0

        for index in 1..<sorted.count {

            let gap = sorted[index]
                .smokedAt
                .timeIntervalSince(
                    sorted[index - 1].smokedAt
                )

            longestGap = max(
                longestGap,
                gap
            )
        }

        return longestGap
    }

    // MARK: - Time Distribution

    private func calculateTimeDistribution(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> [TimeDistributionData] {

        guard let monthStart = calendar.date(
            from: calendar.dateComponents(
                [.year, .month],
                from: date
            )
        ) else {
            return []
        }

        let monthCigarettes = cigarettes.filter {
            $0.smokedAt >= monthStart &&
            $0.smokedAt <= date
        }

        let morning = monthCigarettes.filter {

            let hour = calendar.component(
                .hour,
                from: $0.smokedAt
            )

            return hour >= 5 && hour < 12
        }.count

        let afternoon = monthCigarettes.filter {

            let hour = calendar.component(
                .hour,
                from: $0.smokedAt
            )

            return hour >= 12 && hour < 17
        }.count

        let evening = monthCigarettes.filter {

            let hour = calendar.component(
                .hour,
                from: $0.smokedAt
            )

            return hour >= 17 && hour < 21
        }.count

        let night = monthCigarettes.filter {

            let hour = calendar.component(
                .hour,
                from: $0.smokedAt
            )

            return hour >= 21 || hour < 5
        }.count

        let total = morning +
                    afternoon +
                    evening +
                    night

        guard total > 0 else {
            return [
                TimeDistributionData(
                    title: "MORNING",
                    percentage: 0
                ),
                TimeDistributionData(
                    title: "AFTERNOON",
                    percentage: 0
                ),
                TimeDistributionData(
                    title: "EVENING",
                    percentage: 0
                ),
                TimeDistributionData(
                    title: "NIGHT",
                    percentage: 0
                )
            ]
        }

        return [
            TimeDistributionData(
                title: "MORNING",
                percentage: Double(morning) / Double(total)
            ),
            TimeDistributionData(
                title: "AFTERNOON",
                percentage: Double(afternoon) / Double(total)
            ),
            TimeDistributionData(
                title: "EVENING",
                percentage: Double(evening) / Double(total)
            ),
            TimeDistributionData(
                title: "NIGHT",
                percentage: Double(night) / Double(total)
            )
        ]
    }

    // MARK: - Most Frequent Hour

    private func calculateMostFrequentHour(
        cigarettes: [CigaretteModel],
        calendar: Calendar
    ) -> Int? {

        guard !cigarettes.isEmpty else {
            return nil
        }

        let grouped = Dictionary(
            grouping: cigarettes
        ) {
            calendar.component(
                .hour,
                from: $0.smokedAt
            )
        }

        return grouped.max {
            $0.value.count < $1.value.count
        }?.key
    }

    // MARK: - Recommendations

    private func generateRecommendations(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        date: Date
    ) -> [AnalyticsRecommendation] {

        var result: [AnalyticsRecommendation] = []

        let startOfToday = calendar.startOfDay(
            for: date
        )

        guard
            let currentWeekStart = calendar.date(
                byAdding: .day,
                value: -6,
                to: startOfToday
            ),
            let previousWeekStart = calendar.date(
                byAdding: .day,
                value: -13,
                to: startOfToday
            )
        else {
            return result
        }

        let currentWeek = cigarettes.filter {
            $0.smokedAt >= currentWeekStart &&
            $0.smokedAt <= date
        }.count

        let previousWeek = cigarettes.filter {
            $0.smokedAt >= previousWeekStart &&
            $0.smokedAt < currentWeekStart
        }.count

        if previousWeek > 0 {

            let percentage = Int(
                abs(
                    Double(currentWeek - previousWeek)
                    / Double(previousWeek)
                    * 100
                )
            )

            if currentWeek < previousWeek {

                result.append(
                    AnalyticsRecommendation(
                        icon: "arrow.down.right",
                        message:
                            "You smoked \(percentage)% less this week compared to last week. Keep it up."
                    )
                )

            } else if currentWeek > previousWeek {

                result.append(
                    AnalyticsRecommendation(
                        icon: "arrow.up.right",
                        message:
                            "You smoked \(percentage)% more this week compared to last week."
                    )
                )
            }
        }

        // Most frequent smoking hour

        if let mostFrequentHour =
            calculateMostFrequentHour(
                cigarettes: cigarettes,
                calendar: calendar
            ) {

            let formatter = DateFormatter()
            formatter.dateFormat = "h a"

            var components = DateComponents()
            components.hour = mostFrequentHour

            if let time = calendar.date(
                from: components
            ) {

                let formattedTime = formatter.string(
                    from: time
                )

                result.append(
                    AnalyticsRecommendation(
                        icon: "clock",
                        message:
                            "Your most frequent smoking time is around \(formattedTime)."
                    )
                )
            }
        }

        return result
    }
}
