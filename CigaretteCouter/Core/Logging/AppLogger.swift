//
//  AppLogger.swift
//  CigaretteCouter
//
//  Created by Shiraz on 22/08/26.
//

import Foundation
import OSLog

enum AppLogger {

    private static let subsystem =
        Bundle.main.bundleIdentifier ?? "CigaretteCouter"

    static let auth = Logger(
        subsystem: subsystem,
        category: "Authentication"
    )

    static let storage = Logger(
        subsystem: subsystem,
        category: "Storage"
    )

    static let firestore = Logger(
        subsystem: subsystem,
        category: "Firestore"
    )

    static let app = Logger(
        subsystem: subsystem,
        category: "Application"
    )

    static func info(
        _ message: String,
        category: Logger = app
    ) {
        category.info("\(message, privacy: .public)")
    }

    static func error(
        _ message: String,
        error: Error? = nil,
        category: Logger = app
    ) {
        if let error {
            category.error(
                "\(message, privacy: .public) - \(error.localizedDescription, privacy: .public)"
            )
        } else {
            category.error("\(message, privacy: .public)")
        }
    }

    static func warning(
        _ message: String,
        category: Logger = app
    ) {
        category.warning("\(message, privacy: .public)")
    }

    static func debug(
        _ message: String,
        category: Logger = app
    ) {
        category.debug("\(message, privacy: .public)")
    }
}
