//
//  UserPreferences.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import Foundation
import Observation

@Observable
final class UserPreferences {

    static let shared = UserPreferences()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let appLanguage = "app_language"
    }

    var hasCompletedOnboarding: Bool {
        didSet {
            defaults.set(
                hasCompletedOnboarding,
                forKey: AppConstants.StorageKeys.hasCompletedOnboarding
            )
        }
    }

    var appLanguage: AppLanguage {
        get {
            guard let rawValue = defaults.string(
                forKey: Keys.appLanguage
            ),
            let language = AppLanguage(rawValue: rawValue)
            else {
                return .english
            }

            return language
        }

        set {
            defaults.set(
                newValue.rawValue,
                forKey: Keys.appLanguage
            )
        }
    }

    private init() {
        self.hasCompletedOnboarding = defaults.bool(
            forKey: AppConstants.StorageKeys.hasCompletedOnboarding
        )
    }
}
