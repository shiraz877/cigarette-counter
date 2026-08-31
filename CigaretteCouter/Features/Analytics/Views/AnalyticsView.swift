//
//  AnalyticsView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @State private var viewModel = AnalyticsViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 32) {
                
                // MARK: Header
                Text("Your smoking")
                    .font(
                        .system(
                            size: 28,
                            weight: .semibold
                        )
                    )
                    .tracking(-0.5)
                    .foregroundStyle(AppColors.primaryColor)
                
                summarySection
                Divider().overlay(AppColors.tertiaryColor)
                
                weeklyChartSection
                Divider().overlay(AppColors.tertiaryColor)
                
                monthlyChartSection
                Divider().overlay(AppColors.tertiaryColor)
                
                insightsSection
                Divider().overlay(AppColors.tertiaryColor)
                
                timeDistributionSection
                Divider().overlay(AppColors.tertiaryColor)
                
                recommendationSection
                Divider().overlay(AppColors.tertiaryColor)
                
                Spacer()
                    .frame(height: 80)
            }
            .padding(AppTheme.standardPadding)
            
        }
        .mainBackgroundColor()
        .task {
            await viewModel.loadAnalytics()
        }
        
        
    }
}

// MARK: - Summary

private extension AnalyticsView {
    
    var summarySection: some View {
        
        HStack(spacing: 12) {
            
            AnalyticsStat(
                title: "TODAY",
                value: "\(viewModel.todayCount)"
            )
            
            AnalyticsStat(
                title: "THIS WEEK",
                value: "\(viewModel.weeklyCount)"
            )
            
            AnalyticsStat(
                title: "THIS MONTH",
                value: "\(viewModel.monthlyCount)"
            )
        }
        .padding(.bottom, 16)
        
    }
}

// MARK: - Weekly Chart

private extension AnalyticsView {
    
    var weeklyChartSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            sectionTitle("WEEKLY OVERVIEW")
    
            Chart(viewModel.weeklyData) { item in
                
                BarMark(
                    x: .value("Day", item.day),
                    y: .value("Cigarettes", item.value)
                )
                .foregroundStyle(
                    AppColors.primaryColor
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 2
                    )
                )
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            Text(day)
                                .font(.system(size: 11))
                                .foregroundStyle(
                                    AppColors.tertiaryColor
                                )
                        }
                    }
                    
                    AxisGridLine(
                        stroke: StrokeStyle(lineWidth: 0)
                    )
                    
                    AxisTick(
                        stroke: StrokeStyle(lineWidth: 0)
                    )
                }
            }
            
            .chartYAxis {
                AxisMarks { _ in
                    AxisGridLine(
                        stroke: StrokeStyle(
                            lineWidth: 1,
                            dash: [2, 2]
                        )
                    )
                    .foregroundStyle(
                        AppColors.tertiaryColor
                    )
                }
            }
            .chartPlotStyle { plotArea in
                plotArea
                    .background(.clear)
            }
            .frame(height: 192)
        }
        .padding(.bottom, 16)
        
    }
}

// MARK: - Monthly Chart

private extension AnalyticsView {
    var monthlyChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            sectionTitle("MONTHLY TREND")
            
            Chart(viewModel.monthlyData) { item in
                
                LineMark(
                    x: .value("Day", item.day),
                    y: .value("Cigarettes", item.value)
                )
                .foregroundStyle(
                    AppColors.primaryColor
                )
                .lineStyle(
                    StrokeStyle(
                        lineWidth: 2,
                        lineCap: .round
                    )
                )
                
                PointMark(
                    x: .value("Day", item.day),
                    y: .value("Cigarettes", item.value)
                )
                .foregroundStyle(
                    AppColors.primaryColor
                )
                .opacity(0)
            }
            .chartXAxis {
                AxisMarks(values: [5,15,30]) { value in
                    AxisGridLine(
                        stroke: StrokeStyle(lineWidth: 0)
                    )
                    
                    AxisTick(
                        stroke: StrokeStyle(lineWidth: 0)
                    )
                    
                    AxisValueLabel {
                        if let day = value.as(Int.self) {
                            Text("\(day)")
                                .font(.system(size: 11))
                                .foregroundStyle(
                                    AppColors.tertiaryColor
                                )
                        }
                    }
                }
            }
            
            .chartYAxis {
                
                AxisMarks { _ in
                    
                    AxisGridLine(
                        stroke: StrokeStyle(
                            lineWidth: 1,
                            dash: [2, 2]
                        )
                    )
                    .foregroundStyle(
                        AppColors.tertiaryColor
                    )
                }
            }
            .frame(height: 192)
        }
        .padding(.bottom, 16)
        
    }
}

// MARK: - Insights

private extension AnalyticsView {
    
    var insightsSection: some View {
        
        HStack(spacing: 12) {
            
            InsightCard(
                title: "AVERAGE GAP",
                value:
                    viewModel.averageGapText
                
            )
            
            InsightCard(
                title: "LONGEST GAP",
                value:
                    viewModel.longestGapText
                
            )
        }
        .padding(.bottom, 16)
        
    }
}

// MARK: - Time Distribution

private extension AnalyticsView {

    var timeDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("TIME DISTRIBUTION")

            GeometryReader { geometry in
                HStack(spacing: 2) {
                    ForEach(
                        viewModel.timeDistribution.filter { $0.percentage > 0 }
                    ) { item in

                        TimeDistributionItem(
                            title: item.title,
                            color: AppColors.primaryColor.opacity(
                                0.2 + item.percentage * 0.8
                            ),
                            textColor: item.percentage > 0.5
                            ? AppColors.neutralColor
                            : AppColors.primaryColor
                        )
                        .frame(
                            width: geometry.size.width * item.percentage
                        )
                    }
                }
            }
            .frame(height: 48)
            .clipShape(
                RoundedRectangle(cornerRadius: 4)
            )
        }
        .padding(.bottom, 16)
    }
}


// MARK: - Section Title

private extension AnalyticsView {
    
    func sectionTitle(_ title: LocalizedStringKey) -> some View {
        
        Text(title)
            .font(
                .system(
                    size: 12,
                    weight: .semibold
                )
            )
            .tracking(1.5)
            .foregroundStyle(AppColors.tertiaryColor)
    }
}

// MARK: - Analytics Stat

struct AnalyticsStat: View {
    
    let title: LocalizedStringKey
    let value: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            
            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.2)
                .foregroundStyle(
                    AppColors.tertiaryColor
                )
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(value)
                .font(
                    .system(
                        size: 48,
                        weight: .light,
                        design: .rounded
                    )
                )
                .tracking(-2)
                .foregroundStyle(AppColors.primaryColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Insight Card

struct InsightCard: View {
    
    let title: LocalizedStringKey
    let value: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.2)
                .foregroundStyle(
                    AppColors.tertiaryColor
                )
            
            Text(value)
                .font(
                    .system(
                        size: 28,
                        weight: .semibold
                    )
                )
                .tracking(-0.5)
                .foregroundStyle(AppColors.primaryColor)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(16)
        .background(
            AppColors.secondaryColor
        )
        
    }
}

// MARK: - Time Distribution Item

struct TimeDistributionItem: View {

    let title: String
    let color: Color
    let textColor: Color

    var body: some View {
        Text(title)
            .font(
                .system(
                    size: 10,
                    weight: .semibold
                )
            )
            .tracking(0.8)
            .foregroundStyle(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(color)
    }
}
// MARK: - Recommendations

private extension AnalyticsView {

    var recommendationSection: some View {
        VStack(spacing: 16) {
            AnalyticsMessageCard(
                icon: "arrow.down.right",
                message: "You smoked 12% less this week compared to last week. Keep it up."
            )

            AnalyticsMessageCard(
                icon: "clock",
                message: frequentTimeMessage
            )
        }
    }

    var frequentTimeMessage: LocalizedStringKey {
        guard let hour = viewModel.mostFrequentHour else {
            return "Not enough data yet to identify your most frequent smoking time."
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        let calendar = Calendar.current

        let date = calendar.date(
            bySettingHour: hour,
            minute: 0,
            second: 0,
            of: Date()
        ) ?? Date()

        return "Your most frequent smoking hour is around \(formatter.string(from: date))."
    }
}

struct AnalyticsMessageCard: View {

    let icon: String
    let message: LocalizedStringKey

    var body: some View {
        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(
                    .system(
                        size: 20,
                        weight: .light
                    )
                )
                .foregroundStyle(AppColors.primaryColor)

            Text(message)
                .font(.system(size: 16))
                .foregroundStyle(AppColors.primaryColor)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

            Spacer(minLength: 0)
        }
        .padding(16)
        .background(
            AppColors.secondaryColor
        )
    }
}

private func formatDuration(
    _ duration: TimeInterval?
) -> String {
    
    guard let duration else {
        return "--"
    }
    
    let totalMinutes =
    Int(duration / 60)
    
    let hours =
    totalMinutes / 60
    
    let minutes =
    totalMinutes % 60
    
    if hours > 0 {
        return "\(hours)h \(minutes)m"
    }
    
    return "\(minutes)m"
}
