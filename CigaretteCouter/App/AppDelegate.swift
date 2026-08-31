//
//  AppDelegate.swift
//  CigaretteCouter
//
//  Created by Shiraz on 22/08/26.
//

import UIKit
import FirebaseCore
import GoogleSignIn

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        FirebaseManager.shared.configure()

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError(
                "Firebase CLIENT_ID is missing. Check GoogleService-Info.plist."
            )
        }

        GIDSignIn.sharedInstance.configuration = GIDConfiguration(
            clientID: clientID
        )

        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {

        return GIDSignIn.sharedInstance.handle(url)
    }
}
