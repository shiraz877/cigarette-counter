//
//  EmailService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 01/09/26.
//


import Foundation
import UIKit

@MainActor
final class EmailService {

    static let shared = EmailService()

    private init() {}

    // MARK: - Public

    func openSupportEmail(
        to email: String,
        subject: String,
        body: String
    ) {

        // Prefer Gmail when it is installed.
        if let gmailURL = makeGmailURL(
            email: email,
            subject: subject,
            body: body
        ),
        UIApplication.shared.canOpenURL(gmailURL) {

            UIApplication.shared.open(gmailURL)
            return
        }

        // Fallback to the user's default email application.
        if let mailURL = makeMailURL(
            email: email,
            subject: subject,
            body: body
        ),
        UIApplication.shared.canOpenURL(mailURL) {

            UIApplication.shared.open(mailURL)
            return
        }
    }

    // MARK: - Gmail

    private func makeGmailURL(
        email: String,
        subject: String,
        body: String
    ) -> URL? {

        var components = URLComponents()

        components.scheme = "googlegmail"
        components.host = "co"

        components.queryItems = [
            URLQueryItem(
                name: "to",
                value: email
            ),
            URLQueryItem(
                name: "subject",
                value: subject
            ),
            URLQueryItem(
                name: "body",
                value: body
            )
        ]

        return components.url
    }

    // MARK: - Mail

    private func makeMailURL(
        email: String,
        subject: String,
        body: String
    ) -> URL? {

        var components = URLComponents()

        components.scheme = "mailto"
        components.path = email

        components.queryItems = [
            URLQueryItem(
                name: "subject",
                value: subject
            ),
            URLQueryItem(
                name: "body",
                value: body
            )
        ]

        return components.url
    }
}


