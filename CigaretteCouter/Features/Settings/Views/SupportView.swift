//
//  SupportView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 01/09/26.
//


import SwiftUI

struct SupportView: View {

    @Environment(\.dismiss)
    private var dismiss

    @Environment(\.openURL)
    private var openURL

    @State private var subject = ""
    @State private var message = ""

    private let supportEmail = AppConstants.Support.email

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {
                        Text("How can we help?")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        Text(
                            "Send us a message and we'll get back to you as soon as possible."
                        )
                        .font(.subheadline)
                        .foregroundStyle(AppColors.neutralColor)
                    }

                    // MARK: - Subject

                    VStack(alignment: .leading, spacing: 8) {
                        Text("SUBJECT")
                            .font(.system(size: 12, weight: .semibold))
                            .tracking(1.5)
                            .foregroundStyle(AppColors.tertiaryColor)

                        TextField(
                            "What can we help with?",
                            text: $subject,
                            prompt: Text( "What can we help with?")
                                .foregroundStyle(AppColors.tertiaryColor),
                            
                        )
                        .textInputAutocapitalization(.sentences)
                        .padding()
                        .background(
                            Rectangle()
                                .fill(AppColors.secondaryColor)
                        )
                        .foregroundStyle(.white)
                    }

                    // MARK: - Message

                    VStack(alignment: .leading, spacing: 8) {
                        Text("MESSAGE")
                            .font(.system(size: 12, weight: .semibold))
                            .tracking(1.5)
                            .foregroundStyle(AppColors.tertiaryColor)

                        TextField(
                            "Describe your issue...",
                            text: $message,
                            prompt: Text( "Describe your issue...")
                                .foregroundStyle(AppColors.tertiaryColor),
                            axis: .vertical
                        )
                        .lineLimit(6...12)
                        .textInputAutocapitalization(.sentences)
                        .padding()
                        .background(
                            Rectangle()
                                .fill(AppColors.secondaryColor)
                        )
                        .foregroundStyle(.white)
                    }

                    // MARK: - Support Email

                    Text("Your message will be sent to \(supportEmail).")
                        .font(.footnote)
                        .foregroundStyle(AppColors.neutralColor)

                    // MARK: - Send

                    Button {
                        sendSupportEmail()
                    } label: {
                        Text("Send")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                canSend
                                ? AppColors.primaryColor
                                : AppColors.tertiaryColor
                            )
                            .foregroundStyle(.black)
//                            .clipShape(
//                                RoundedRectangle(cornerRadius: 14)
//                            )
                    }
                    .disabled(!canSend)
                }
                .padding(24)
            }
            .mainBackgroundColor()
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                  
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                    .foregroundStyle(AppColors.neutralColor)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 14, weight: .semibold))
//                            .foregroundStyle(AppColors.neutralColor)
//                            .frame(width: 32, height: 32)
//                            .background(
//                                Circle()
//                                    .fill(Color.white.opacity(0.08))
//                            )
//                    }
//                    .buttonStyle(.plain)
//                    .accessibilityLabel("Close")
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundStyle(AppColors.neutralColor)
//
//                    }
//                    .buttonStyle(.plain)
//                    .accessibilityLabel("Close")
//                }
//            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
//                            .background(
//                                Circle()
//                                    .fill(.white)
//                            )
//                            .shadow(
//                                color: .black.opacity(0.2),
//                                radius: 4,
//                                y: 2
//                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close")
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Validation

    private var canSend: Bool {
        !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Send Email

    private func sendSupportEmail() {

        let cleanSubject = subject.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanMessage = message.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        var components = URLComponents()

        components.scheme = "mailto"
        components.path = supportEmail
        components.queryItems = [
            URLQueryItem(
                name: "subject",
                value: cleanSubject
            ),
            URLQueryItem(
                name: "body",
                value: cleanMessage
            )
        ]

        guard let url = components.url else {
            return
        }

        openURL(url)

        dismiss()
    }
}

