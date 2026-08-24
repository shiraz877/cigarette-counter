//
//  SettingView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI

struct SettingsView: View {
    


    @State private var showDeleteAlert = false
    @State private var viewModel = SettingsViewModel()

    // MARK: - Body

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 48) {

                // MARK: Title

                Text("Settings")
                    .font(
                        .system(
                            size: 52,
                            weight: .bold
                        )
                    )
                    .tracking(-2)
                    .foregroundStyle(.white)
                    .padding(.top, 32)

                // MARK: Tracking

                settingsSection(title: "TRACKING") {

                    SettingsRow(
                        title: "Daily average",
                        value: "\(viewModel.dailyAverage)"
                    ) {
                        // Open daily average editor
                    }

                    SettingsRow(
                        title: "Cigarettes per pack",
                        value: "\(viewModel.cigarettesPerPack)"
                    ) {
                        // Open cigarettes per pack editor
                    }

                    SettingsRow(
                        title: "Pack price",
                        value: viewModel.packPrice
                    ) {
                        // Open pack price editor
                    }

                    SettingsRow(
                        title: "Default trigger",
                        value: viewModel.defaultTrigger,
                        showChevron: true
                    ) {
                        // Open trigger selection
                    }
                }

                // MARK: Notifications

                settingsSection(title: "NOTIFICATIONS") {

                    SettingsRow(
                        title: "Daily reminder",
                        trailingView: {
                            StatusBadge(
                                title: viewModel.dailyReminder ? "ON" : "OFF",
                                isOn: viewModel.dailyReminder
                            )
                        }
                    ) {
                        viewModel.dailyReminder.toggle()
                    }

                    SettingsRow(
                        title: "Evening summary",
                        trailingView: {
                            StatusBadge(
                                title: viewModel.eveningSummary ? "ON" : "OFF",
                                isOn: viewModel.eveningSummary
                            )
                        }
                    ) {
                        viewModel.eveningSummary.toggle()
                    }
                }

                // MARK: Data

                settingsSection(title: "DATA") {

                    SettingsActionRow(
                        title: "Export data",
                        icon: "arrow.down.circle"
                    ) {
                        exportData()
                    }

                    SettingsActionRow(
                        title: "Delete all history",
                        icon: "trash",
                        isDestructive: true
                    ) {
                        showDeleteAlert = true
                    }
                }

                // MARK: Privacy

                settingsSection(title: "PRIVACY") {

                    SettingsActionRow(
                        title: "Privacy Policy",
                        icon: "arrow.forward"
                    ) {
                        openPrivacyPolicy()
                    }

                    SettingsActionRow(
                        title: "Terms of Service",
                        icon: "arrow.forward"
                    ) {
                        openTerms()
                    }
                }

                // MARK: App

                settingsSection(title: "APP") {

                    SettingsActionRow(
                        title: "Rate us",
                        icon: "star"
                    ) {
                        rateApp()
                    }

                    SettingsActionRow(
                        title: "Share",
                        icon: "square.and.arrow.up"
                    ) {
                        shareApp()
                    }

                    SettingsActionRow(
                        title: "Support",
                        icon: "questionmark"
                    ) {
                        openSupport()
                    }
                }

                // MARK: Account

                settingsSection(title: "ACCOUNT") {

                    VStack(spacing: 8) {

                        AccountButton(
                            title: "Continue with Apple",
                            style: .apple
                        ) {
                            signInWithApple()
                        }

                        AccountButton(
                            title: "Continue with Google",
                            style: .google
                        ) {
                            signInWithGoogle()
                        }

                        AccountButton(
                            title: "Continue with Email",
                            style: .email
                        ) {
                            signInWithEmail()
                        }
                    }
                    .padding(.top, 8)
                }

                // Bottom spacing
                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 672)
            .frame(maxWidth: .infinity)
        }
        .background(Color.appBackground)
        .scrollBounceBehavior(.basedOnSize)
        .alert(
            "Delete all history?",
            isPresented: $showDeleteAlert
        ) {
            Button("Delete", role: .destructive) {
                deleteHistory()
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

// MARK: - Section

private extension SettingsView {

    @ViewBuilder
    func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {

        VStack(alignment: .leading, spacing: 16) {

            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.5)
                .foregroundStyle(Color.secondaryText)

            VStack(spacing: 0) {
                content()
            }
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {

    let title: String

    var value: String? = nil

    var showChevron = false

    var trailingView: (() -> AnyView)? = nil

    let action: () -> Void

    init(
        title: String,
        value: String? = nil,
        showChevron: Bool = false,
        @ViewBuilder trailingView: @escaping () -> some View = { EmptyView() },
        action: @escaping () -> Void
    ) {
        self.title = title
        self.value = value
        self.showChevron = showChevron
        self.trailingView = {
            AnyView(trailingView())
        }
        self.action = action
    }

    var body: some View {

        Button(action: action) {

            HStack(spacing: 16) {

                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)

                Spacer()

                if let trailingView {
                    trailingView()
                } else if let value {

                    HStack(spacing: 8) {

                        Text(value)
                            .font(.system(size: 16))
                            .foregroundStyle(Color.secondaryText)

                        if showChevron {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(Color.secondaryText)
                        }
                    }
                }
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }
}

// MARK: - Action Row

struct SettingsActionRow: View {

    let title: String
    let icon: String
    var isDestructive = false

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack {

                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(
                        isDestructive
                        ? Color.errorRed
                        : Color.white
                    )

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 19, weight: .light))
                    .foregroundStyle(
                        isDestructive
                        ? Color.errorRed
                        : Color.secondaryText
                    )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.outline)
                .frame(height: 1)
        }
    }
}

// MARK: - Status Badge

struct StatusBadge: View {

    let title: String
    let isOn: Bool

    var body: some View {

        Text(title)
            .font(
                .system(
                    size: 12,
                    weight: .semibold
                )
            )
            .tracking(1)
            .foregroundStyle(
                isOn
                ? Color.black
                : Color.secondaryText
            )
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(
                isOn
                ? Color.white
                : Color.surfaceContainerLow
            )
            .clipShape(Capsule())
            .overlay {
                if !isOn {
                    Capsule()
                        .stroke(
                            Color.outline,
                            lineWidth: 1
                        )
                }
            }
    }
}

// MARK: - Account Button

struct AccountButton: View {

    enum ButtonStyle {
        case apple
        case google
        case email
    }

    let title: String
    let style: ButtonStyle
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {

                if style == .apple {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 18))
                }

                if style == .google {
                    Image(systemName: "g.circle")
                        .font(.system(size: 18))
                }

                Text(title)
                    .font(.system(size: 16))
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay {
                if style == .email {
                    Capsule()
                        .stroke(
                            Color.outline,
                            lineWidth: 1
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var backgroundColor: Color {

        switch style {
        case .apple:
            return .white

        case .google:
            return Color.surfaceContainerHighest

        case .email:
            return .clear
        }
    }

    private var foregroundColor: Color {

        switch style {
        case .apple:
            return .black

        case .google, .email:
            return .white
        }
    }
}

// MARK: - Actions

private extension SettingsView {

    func exportData() {
        print("Export data")
    }

    func deleteHistory() {
        print("Delete history")
    }

    func openPrivacyPolicy() {
        print("Privacy policy")
    }

    func openTerms() {
        print("Terms of service")
    }

    func rateApp() {
        print("Rate app")
    }

    func shareApp() {
        print("Share app")
    }

    func openSupport() {
        print("Support")
    }

    func signInWithApple() {
        print("Apple login")
    }

    func signInWithGoogle() {
        print("Google login")
    }

    func signInWithEmail() {
        print("Email login")
    }
}

// MARK: - Colors

extension Color {

    static let appBackground = Color(
        red: 19 / 255,
        green: 19 / 255,
        blue: 19 / 255
    )

    static let secondaryText = Color(
        red: 198 / 255,
        green: 198 / 255,
        blue: 198 / 255
    )

    static let outline = Color(
        red: 68 / 255,
        green: 71 / 255,
        blue: 70 / 255
    )

    static let surfaceContainerLow = Color(
        red: 27 / 255,
        green: 27 / 255,
        blue: 27 / 255
    )

    static let surfaceContainerHighest = Color(
        red: 55 / 255,
        green: 55 / 255,
        blue: 55 / 255
    )

    static let errorRed = Color(
        red: 255 / 255,
        green: 180 / 255,
        blue: 171 / 255
    )
}

// MARK: - Preview

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
