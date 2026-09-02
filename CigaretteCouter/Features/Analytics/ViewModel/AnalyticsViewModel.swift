//
//  AnalyticsViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class AnalyticsViewModel {

    // MARK: - State

    var isLoading = false
    var errorMessage: String?

    var todayCount = 0
    var weeklyCount = 0
    var monthlyCount = 0

    var cigarettes: [CigaretteModel] = []

    var weeklyData: [WeeklyData] = []
    var monthlyData: [MonthlyData] = []

    var averageGapText = "--"
    var longestGapText = "--"

    var timeDistribution: [TimeDistributionData] = []

    var recommendations: [AnalyticsRecommendation] = []

    // MARK: - Computed Properties

    var mostFrequentHour: Int? {
        guard !cigarettes.isEmpty else {
            return nil
        }

        let calendar = Calendar.current

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

    // MARK: - Dependencies

    @ObservationIgnored
    private let cigaretteRepository: CigaretteRepositoryProtocol

    // MARK: - Init

    init(
        cigaretteRepository: CigaretteRepositoryProtocol = CigaretteRepository.shared
    ) {
        self.cigaretteRepository = cigaretteRepository
    }

    // MARK: - Load

    func loadAnalytics() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        let userId =
            await AuthService.shared.getCurrentUser()?.id ?? "guest"

        do {

            let fetchedCigarettes =
                try await cigaretteRepository.fetchAllCigarettes(
                    userId: userId
                )

            cigarettes = fetchedCigarettes.sorted {
                $0.smokedAt < $1.smokedAt
            }

            calculateAnalytics(
                from: cigarettes
            )

        } catch {

            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Calculate

    private func calculateAnalytics(
        from cigarettes: [CigaretteModel]
    ) {

        let calendar = Calendar.current
        let now = Date()

        // MARK: Today

        todayCount = cigarettes.filter {
            calendar.isDate(
                $0.smokedAt,
                inSameDayAs: now
            )
        }.count

        // MARK: Current Week

        let weekStart =
            calendar.date(
                byAdding: .day,
                value: -6,
                to: calendar.startOfDay(
                    for: now
                )
            )!

        let weekCigarettes = cigarettes.filter {
            $0.smokedAt >= weekStart &&
            $0.smokedAt <= now
        }

        weeklyCount = weekCigarettes.count

        // MARK: Current Month

        let monthStart =
            calendar.date(
                from: calendar.dateComponents(
                    [.year, .month],
                    from: now
                )
            )!

        let monthCigarettes = cigarettes.filter {
            $0.smokedAt >= monthStart &&
            $0.smokedAt <= now
        }

        monthlyCount = monthCigarettes.count

        // MARK: Charts

        calculateWeeklyData(
            cigarettes: cigarettes,
            calendar: calendar,
            now: now
        )

        calculateMonthlyData(
            cigarettes: cigarettes,
            calendar: calendar,
            now: now
        )

        // MARK: Insights

        calculateGaps(
            cigarettes: cigarettes,
            now: now
        )

        calculateTimeDistribution(
            cigarettes: monthCigarettes,
            calendar: calendar
        )

        // MARK: Recommendations

        generateRecommendations(
            cigarettes: cigarettes,
            calendar: calendar,
            now: now
        )
    }

    // MARK: - Weekly

    private func calculateWeeklyData(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        now: Date
    ) {

        weeklyData = (0..<7).reversed().map { offset in

            let date =
                calendar.date(
                    byAdding: .day,
                    value: -offset,
                    to: now
                )!

            let count = cigarettes.filter {
                calendar.isDate(
                    $0.smokedAt,
                    inSameDayAs: date
                )
            }.count

            let formatter = DateFormatter()
            formatter.dateFormat = "EEE"

            return WeeklyData(
                day: formatter
                    .string(from: date)
                    .uppercased(),
                value: count
            )
        }
    }

    // MARK: - Monthly

    private func calculateMonthlyData(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        now: Date
    ) {

        let range =
            calendar.range(
                of: .day,
                in: .month,
                for: now
            ) ?? (1..<30)

        monthlyData = range.map { day in

            var components =
                calendar.dateComponents(
                    [.year, .month],
                    from: now
                )

            components.day = day

            let date =
                calendar.date(
                    from: components
                )!

            let count = cigarettes.filter {
                calendar.isDate(
                    $0.smokedAt,
                    inSameDayAs: date
                )
            }.count

            return MonthlyData(
                day: day,
                value: count
            )
        }
    }

    // MARK: - Gaps

    private func calculateGaps(
        cigarettes: [CigaretteModel],
        now: Date
    ) {

        let sorted =
            cigarettes
                .filter {
                    $0.smokedAt <= now
                }
                .sorted {
                    $0.smokedAt < $1.smokedAt
                }

        guard sorted.count >= 2 else {
            averageGapText = "--"
            longestGapText = "--"
            return
        }

        var gaps: [TimeInterval] = []

        for index in 1..<sorted.count {

            let gap =
                sorted[index]
                    .smokedAt
                    .timeIntervalSince(
                        sorted[index - 1].smokedAt
                    )

            gaps.append(gap)
        }

        guard !gaps.isEmpty else {
            return
        }

        let average =
            gaps.reduce(0, +) /
            Double(gaps.count)

        let longest =
            gaps.max() ?? 0

        averageGapText =
            formatDuration(average)

        longestGapText =
            formatDuration(longest)
    }

    private func formatDuration(
        _ interval: TimeInterval
    ) -> String {

        let totalMinutes =
            Int(interval / 60)

        let hours =
            totalMinutes / 60

        let minutes =
            totalMinutes % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }

        return "\(minutes)m"
    }

    // MARK: - Time Distribution

    private func calculateTimeDistribution(
        cigarettes: [CigaretteModel],
        calendar: Calendar
    ) {

        let morning =
            cigarettes.filter {
                let hour =
                    calendar.component(
                        .hour,
                        from: $0.smokedAt
                    )

                return hour >= 5 && hour < 12
            }.count

        let afternoon =
            cigarettes.filter {
                let hour =
                    calendar.component(
                        .hour,
                        from: $0.smokedAt
                    )

                return hour >= 12 && hour < 17
            }.count

        let evening =
            cigarettes.filter {
                let hour =
                    calendar.component(
                        .hour,
                        from: $0.smokedAt
                    )

                return hour >= 17 && hour < 21
            }.count

        let night =
            cigarettes.filter {
                let hour =
                    calendar.component(
                        .hour,
                        from: $0.smokedAt
                    )

                return hour >= 21 || hour < 5
            }.count

        let total =
            max(
                morning +
                afternoon +
                evening +
                night,
                1
            )

        timeDistribution = [

            TimeDistributionData(
                title: "MORNING",
                percentage:
                    Double(morning) /
                    Double(total)
            ),

            TimeDistributionData(
                title: "AFTERNOON",
                percentage:
                    Double(afternoon) /
                    Double(total)
            ),

            TimeDistributionData(
                title: "EVENING",
                percentage:
                    Double(evening) /
                    Double(total)
            ),

            TimeDistributionData(
                title: "NIGHT",
                percentage:
                    Double(night) /
                    Double(total)
            )
        ]
    }

    // MARK: - Recommendations

    private func generateRecommendations(
        cigarettes: [CigaretteModel],
        calendar: Calendar,
        now: Date
    ) {

        var result: [AnalyticsRecommendation] = []

        let currentWeekStart =
            calendar.date(
                byAdding: .day,
                value: -6,
                to: calendar.startOfDay(
                    for: now
                )
            )!

        let previousWeekStart =
            calendar.date(
                byAdding: .day,
                value: -13,
                to: calendar.startOfDay(
                    for: now
                )
            )!

        let currentWeek =
            cigarettes.filter {
                $0.smokedAt >= currentWeekStart &&
                $0.smokedAt <= now
            }.count

        let previousWeek =
            cigarettes.filter {
                $0.smokedAt >= previousWeekStart &&
                $0.smokedAt < currentWeekStart
            }.count

        if previousWeek > 0 {

            let percentage =
                Int(
                    abs(
                        Double(
                            currentWeek -
                            previousWeek
                        ) /
                        Double(previousWeek)
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

        // MARK: Most Frequent Hour

        let groupedByHour =
            Dictionary(
                grouping: cigarettes
            ) {
                calendar.component(
                    .hour,
                    from: $0.smokedAt
                )
            }

        if let mostFrequent =
            groupedByHour.max(
                by: {
                    $0.value.count <
                    $1.value.count
                }
            ) {

            let formatter =
                DateFormatter()

            formatter.dateFormat = "h:mm a"

            var components =
                DateComponents()

            components.hour =
                mostFrequent.key

            if let date =
                calendar.date(
                    from: components
                ) {

                let time =
                    formatter.string(
                        from: date
                    )

                result.append(
                    AnalyticsRecommendation(
                        icon: "clock",
                        message:
                            "Your most frequent smoking time is around \(time)."
                    )
                )
            }
        }

        recommendations = result
    }
 
}
