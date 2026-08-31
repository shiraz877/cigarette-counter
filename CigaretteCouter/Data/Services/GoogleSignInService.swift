//
//  GoogleSignInService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 27/08/26.
//


import Foundation
import GoogleSignIn
import UIKit

struct GoogleSignInResult: Sendable {

    let idToken: String
    let accessToken: String
}

protocol GoogleSignInServiceProtocol: Sendable {

    func signIn() async throws -> GoogleSignInResult
}
final class GoogleSignInService:
    GoogleSignInServiceProtocol,
    @unchecked Sendable {

    func signIn() async throws -> GoogleSignInResult {

        guard let presentingViewController =
            Self.topViewController()
        else {
            throw GoogleSignInError
                .presentingViewControllerNotFound
        }

        let result = try await GIDSignIn.sharedInstance
            .signIn(
                withPresenting: presentingViewController
            )

        guard let idToken =
            result.user.idToken?.tokenString
        else {
            throw GoogleSignInError
                .missingIDToken
        }

        let accessToken =
            result.user.accessToken.tokenString

        return GoogleSignInResult(
            idToken: idToken,
            accessToken: accessToken
        )
    }

    // MARK: - Top View Controller

    private static func topViewController(
        from rootViewController: UIViewController? = nil
    ) -> UIViewController? {

        let root =
            rootViewController ??
            UIApplication.shared.connectedScenes
                .compactMap {
                    $0 as? UIWindowScene
                }
                .flatMap {
                    $0.windows
                }
                .first {
                    $0.isKeyWindow
                }?
                .rootViewController

        if let navigationController =
            root as? UINavigationController {

            return topViewController(
                from: navigationController
                    .visibleViewController
            )
        }

        if let tabBarController =
            root as? UITabBarController {

            return topViewController(
                from: tabBarController
                    .selectedViewController
            )
        }

        if let presented =
            root?.presentedViewController {

            return topViewController(
                from: presented
            )
        }

        return root
    }
}
enum GoogleSignInError: LocalizedError {

    case presentingViewControllerNotFound
    case missingIDToken

    var errorDescription: String? {

        switch self {

        case .presentingViewControllerNotFound:
            return "Unable to start Google Sign-In."

        case .missingIDToken:
            return "Google did not return an ID token."
        }
    }
}
