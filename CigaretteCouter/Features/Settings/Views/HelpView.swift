//
//  HelpView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 01/09/26.
//


import SwiftUI

struct HelpView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var expandedQuestion: HelpQuestion?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {
                        Text("How can we help?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text("Find answers to common questions about Cigarette Counter.")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.tertiaryColor)
                    }

                    // MARK: - FAQ

                    VStack(spacing: 0) {
                        ForEach(HelpQuestion.allCases) { question in

                            FAQRow(
                                question: question,
                                isExpanded: expandedQuestion == question
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if expandedQuestion == question {
                                        expandedQuestion = nil
                                    } else {
                                        expandedQuestion = question
                                    }
                                }
                            }

                            if question != HelpQuestion.allCases.last {
                                Divider()
                                    .overlay(AppColors.primaryColor)
                            }
                        }
                    }
                    .background(
//                        RoundedRectangle(cornerRadius: 16)
                        Rectangle()
                            .fill(AppColors.secondaryColor)
                    )
                }
                .padding(24)
            }
            .mainBackgroundColor()
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(
                                .system(
                                    size: 13,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Question

private enum HelpQuestion: String, CaseIterable, Identifiable {

    case howToAdd
    case dailyCount
    case analytics
    case cigarettePrice
    case language
    case account
    case deleteHistory
    case dataStorage

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .howToAdd:
            return "How do I add a cigarette?"

        case .dailyCount:
            return "How is my daily count calculated?"

        case .analytics:
            return "How does Analytics work?"

        case .cigarettePrice:
            return "How do I change the cigarette price?"

        case .language:
            return "How do I change the language?"

        case .account:
            return "Do I need an account to use the app?"

        case .deleteHistory:
            return "How do I delete my history?"

        case .dataStorage:
            return "Where is my data stored?"
        }
    }

    var answer: String {
        switch self {
        case .howToAdd:
            return """
            Tap the Add Cigarette button on the Home screen whenever you smoke a cigarette. The app records the time automatically.
            """

        case .dailyCount:
            return """
            Your daily count includes all cigarettes recorded from the beginning of the current day until the end of that day.
            """

        case .analytics:
            return """
            Analytics uses your recorded cigarette history to show daily, weekly, and monthly consumption patterns and other useful statistics.
            """

        case .cigarettePrice:
            return """
            Go to Settings → Cigarette Price. Enter the price of a single cigarette and save it. The app uses this value when calculating your spending.
            """

        case .language:
            return """
            Go to Settings → Language and select your preferred language. The app will update the supported text automatically.
            """

        case .account:
            return """
            You can use the app without an account. When you sign in, your account-based data can be associated with your account and synchronized using the app's cloud storage.
            """

        case .deleteHistory:
            return """
            Go to Settings → Delete All History. You will be asked to confirm before your cigarette history is deleted.
            """

        case .dataStorage:
            return """
            When you are not signed in, your data is stored locally on your device. When you use an account, account data can be stored in the app's cloud database.
            """
        }
    }
}

// MARK: - FAQ Row

private struct FAQRow: View {

    let question: HelpQuestion
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {

                HStack(alignment: .center, spacing: 16) {

                    Text(question.title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(
                        systemName: isExpanded
                            ? "chevron.up"
                            : "chevron.down"
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColors.tertiaryColor)
                }

                if isExpanded {
                    Text(question.answer)
                        .font(.subheadline)
                        .foregroundStyle(AppColors.tertiaryColor)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(20)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}


