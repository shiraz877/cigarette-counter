import SwiftUI

struct ContentView1: View {

    @State private var selectedTab: Tab = .home
    @State private var cigaretteCount = 7

    var body: some View {
        ZStack(alignment: .bottom) {

            Color.background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // MARK: - Header
                    header

                    // MARK: - Today
                    Text("TODAY")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Color.secondaryText)
                        .padding(.top, 32)

                    // MARK: - Counter
                    counterSection
                        .padding(.top, 32)

                    // MARK: - Stats
                    statsSection
                        .padding(.vertical, 32)

                    // MARK: - Primary Action
                    countButton
                        .padding(.bottom, 32)

                    // MARK: - Timeline
                    timeline
                        .padding(.bottom, 100)
                }
                .padding(.horizontal, 24)
                .frame(maxWidth: 672)
                .frame(maxWidth: .infinity)
            }

            // MARK: - Bottom Navigation
            bottomNavigation
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Button {
                // Menu action
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 22, weight: .light))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            }

            Spacer()

            Text("INVENTORY")
                .font(.system(size: 28, weight: .bold))
                .tracking(-0.8)
                .foregroundStyle(.white)

            Spacer()

            Button {
                // Profile action
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }

    // MARK: - Counter

    private var counterSection: some View {
        VStack(alignment: .leading, spacing: 4) {

            Text("\(cigaretteCount)")
                .font(
                    .system(
                        size: 72,
                        weight: .bold,
                        design: .default
                    )
                )
                .tracking(-3)
                .foregroundStyle(.white)
                .lineLimit(1)

            Text("CIGARETTES")
                .font(.system(size: 28, weight: .bold))
                .tracking(-0.5)
                .foregroundStyle(.white)
        }
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack(spacing: 16) {

            StatView(
                title: "DAILY AVERAGE",
                value: "9.2"
            )

            StatView(
                title: "LAST LOG",
                value: "42",
                suffix: "m"
            )

            StatView(
                title: "SPENDING",
                value: "₹84"
            )
        }
        .padding(.vertical, 16)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }

    // MARK: - Count Button

    private var countButton: some View {
        Button {
            cigaretteCount += 1
        } label: {
            HStack(spacing: 8) {

                Image(systemName: "plus")
                    .font(.system(size: 26, weight: .medium))

                Text("Count Cigarette")
                    .font(.system(size: 28, weight: .bold))
                    .tracking(-0.5)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 64)
            .background(Color.white)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .scaleEffect(1.0)
    }

    // MARK: - Timeline

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("TIMELINE")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Color.secondaryText)
                .padding(.bottom, 8)

            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)

            TimelineRow(
                time: "10:40 AM",
                title: "Cigarette"
            )

            TimelineRow(
                time: "8:12 AM",
                title: "Cigarette"
            )
        }
    }

    // MARK: - Bottom Navigation

    private var bottomNavigation: some View {
        HStack {

            BottomTab(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == .home
            ) {
                selectedTab = .home
            }

            BottomTab(
                icon: "chart.bar.xaxis",
                title: "Analytics",
                isSelected: selectedTab == .analytics
            ) {
                selectedTab = .analytics
            }

            BottomTab(
                icon: "gearshape",
                title: "Settings",
                isSelected: selectedTab == .settings
            ) {
                selectedTab = .settings
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .background(Color.background)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }
}

// MARK: - Stat View

struct StatView: View {

    let title: String
    let value: String
    var suffix: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {

            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.secondaryText)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            HStack(alignment: .lastTextBaseline, spacing: 3) {

                Text(value)
                    .font(
                        .system(
                            size: 48,
                            weight: .light,
                            design: .rounded
                        )
                    )
                    .tracking(-2)
                    .foregroundStyle(.white)

                if let suffix {
                    Text(suffix)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(Color.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Timeline Row

struct TimelineRow: View {

    let time: String
    let title: String

    var body: some View {
        HStack {

            HStack(spacing: 16) {

                Text(time)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.secondaryText)
                    .frame(width: 80, alignment: .leading)

                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
            }

            Spacer()

            Button {
                // More options
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.secondaryText)
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.vertical, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }
}

// MARK: - Bottom Tab

struct BottomTab: View {

    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {

            VStack(spacing: 4) {

                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .medium : .light))

                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(1.2)
                    .textCase(.uppercase)
            }
            .foregroundStyle(
                isSelected
                ? Color.white
                : Color.secondaryText.opacity(0.5)
            )
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tab

enum Tab {
    case home
    case analytics
    case settings
}

// MARK: - Colors

extension Color {

    static let background = Color(
        red: 14 / 255,
        green: 14 / 255,
        blue: 14 / 255
    )

    static let secondaryText = Color(
        red: 163 / 255,
        green: 163 / 255,
        blue: 163 / 255
    )

    static let outline = Color(
        red: 57 / 255,
        green: 57 / 255,
        blue: 57 / 255
    )
}

// MARK: - Preview

#Preview {
    ContentView1()
}
