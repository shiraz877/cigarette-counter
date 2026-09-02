//
//  AppConstants.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import Foundation

enum AppConstants {
    
    enum StorageKeys{
        static let hasCompletedOnboarding = "has_completed_onboarding"
        static let dailyAverage = "daily_average"
        static let appLanguage =
                    "appLanguage"
    }
    enum URLs {
        static let privacyPolicy = URL(
            string: "https://orbitexlabs.blogspot.com/p/privacy-policy-for-puff-counter.html"
        )!

        static let termsOfUse = URL(
            string: "https://orbitexlabs.blogspot.com/p/terms-of-use_0378964855.html"
        )!

        static let support = URL(
            string: "https://your-domain.com/support"
        )!
    }
    enum Support {
           static let email = "support@orbitexlabs.com"
           static let subject = "Puff Counter Support"
       }

}
