//
//  SupportView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 01/09/26.
//


//import SwiftUI
import SwiftUI
import UIKit

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

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)

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


    private func sendSupportEmail() {
        let cleanSubject = subject.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanMessage = message.trimmingCharacters(in: .whitespacesAndNewlines)

       

        // Gmail URL
        var gmailComponents = URLComponents()
        gmailComponents.scheme = "googlegmail"
        gmailComponents.host = "co"
        gmailComponents.queryItems = [
            URLQueryItem(name: "to", value: supportEmail),
            URLQueryItem(name: "subject", value: cleanSubject),
            URLQueryItem(name: "body", value: cleanMessage)
        ]

        guard let gmailURL = gmailComponents.url else {
          
            return
        }

       

        let canOpenGmail = UIApplication.shared.canOpenURL(gmailURL)

      

        if canOpenGmail {
          
            openURL(gmailURL)
            dismiss()
            return
        }

        // Mail fallback
        var mailComponents = URLComponents()
        mailComponents.scheme = "mailto"
        mailComponents.path = supportEmail
        mailComponents.queryItems = [
            URLQueryItem(name: "subject", value: cleanSubject),
            URLQueryItem(name: "body", value: cleanMessage)
        ]

        guard let mailURL = mailComponents.url else {
           
            return
        }

       

        openURL(mailURL)
        dismiss()
    }
}

