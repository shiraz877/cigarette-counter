//
//  AppLanguage.swift
//  CigaretteCouter
//
//  Created by Shiraz on 29/08/26.
//

import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {

    case english = "en"
    case arabic = "ar"
    case bengali = "bn"
    case chinese = "zh"
    case french = "fr"
    case german = "de"
    case hindi = "hi"
    case indonesian = "id"
    case kannada = "kn"
    case malayalam = "ml"
    case portuguese = "pt"
    case russian = "ru"
    case spanish = "es"
    case tamil = "ta"
    case telugu = "te"
    case turkish = "tr"
    case urdu = "ur"

    // MARK: - Identifiable

    var id: String {
        rawValue
    }

    // MARK: - Display Name

    var displayName: String {
        switch self {
        case .english:
            return "English"

        case .arabic:
            return "العربية"

        case .bengali:
            return "বাংলা"

        case .chinese:
            return "中文"

        case .french:
            return "Français"

        case .german:
            return "Deutsch"

        case .hindi:
            return "हिन्दी"

        case .indonesian:
            return "Bahasa Indonesia"

        case .kannada:
            return "ಕನ್ನಡ"

        case .malayalam:
            return "മലയാളം"

        case .portuguese:
            return "Português"

        case .russian:
            return "Русский"

        case .spanish:
            return "Español"

        case .tamil:
            return "தமிழ்"

        case .telugu:
            return "తెలుగు"

        case .turkish:
            return "Türkçe"

        case .urdu:
            return "اردو"
        }
    }

    // MARK: - Locale

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    // MARK: - Layout Direction

    var layoutDirection: LayoutDirection {
        switch self {
        case .arabic, .urdu:
            return .rightToLeft

        default:
            return .leftToRight
        }
    }
}
