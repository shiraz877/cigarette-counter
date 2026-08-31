//
//  CigaretteRecordService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//


import Foundation

protocol CigaretteRecordServiceProtocol: Sendable {

    func getCigarettes(
        userId: String,
        date: Date
    ) async throws -> [CigaretteModel]

    func getAllCigarettes(
        userId: String
    ) async throws -> [CigaretteModel]

    func recordCigarette(
        userId: String,
        smokedAt: Date,
        trigger: CigaretteTriggerModel?
    ) async throws -> CigaretteModel

    func deleteCigarette(
        userId: String,
        cigaretteId: String
    ) async throws
}

final class CigaretteRecordService:
    CigaretteRecordServiceProtocol,
    @unchecked Sendable {

    static let shared = CigaretteRecordService()

    private let localStorage: LocalStorageProtocol
    private let firestoreService: FirestoreServiceProtocol

    init(
        localStorage: LocalStorageProtocol = LocalStorage.shared,
        firestoreService: FirestoreServiceProtocol = FirestoreService.shared
    ) {
        self.localStorage = localStorage
        self.firestoreService = firestoreService
    }

    // MARK: - Get Cigarettes

    func getCigarettes(
        userId: String,
        date: Date
    ) async throws -> [CigaretteModel] {

        // MARK: Guest

        if userId == "guest" {

            let range = dayRange(for: date)

            return localStorage.getCigarettes(
                from: range.start,
                to: range.end
            )
        }

        // MARK: Authenticated User

        guard FirebaseManager.shared.isConfigured else {
            throw CigaretteRecordError.firebaseNotConfigured
        }

        do {

            let range = dayRange(for: date)

            let records = try await firestoreService.fetchCigarettes(
                userId: userId,
                from: range.start,
                to: range.end
            )

            return records

        } catch {

            AppLogger.error(
                "Failed to fetch cigarettes from Firestore",
                error: error,
                category: AppLogger.firestore
            )

            throw error
        }
    }

    // MARK: - Get All

    func getAllCigarettes(
        userId: String
    ) async throws -> [CigaretteModel] {

        // MARK: Guest

        if userId == "guest" {

            return localStorage.getAllCigarettes()
        }

        // MARK: Authenticated

        guard FirebaseManager.shared.isConfigured else {
            throw CigaretteRecordError.firebaseNotConfigured
        }

        do {

            return try await firestoreService.fetchAllCigarettes(
                userId: userId
            )

        } catch {

            AppLogger.error(
                "Failed to fetch all cigarettes from Firestore",
                error: error,
                category: AppLogger.firestore
            )

            throw error
        }
    }

    // MARK: - Record

    func recordCigarette(
        userId: String,
        smokedAt: Date,
        trigger: CigaretteTriggerModel?
    ) async throws -> CigaretteModel {

        let cigarette = CigaretteModel(
            smokedAt: smokedAt,
            trigger: trigger
        )

        // MARK: Guest

        if userId == "guest" {

            try localStorage.saveCigarette(cigarette)

            return cigarette
        }

        // MARK: Authenticated

        guard FirebaseManager.shared.isConfigured else {
            throw CigaretteRecordError.firebaseNotConfigured
        }

        do {

            try await firestoreService.saveCigarette(
                userId: userId,
                cigarette: cigarette
            )

            return cigarette

        } catch {

            AppLogger.error(
                "Failed to save cigarette to Firestore",
                error: error,
                category: AppLogger.firestore
            )

            throw error
        }
    }

    // MARK: - Delete

    func deleteCigarette(
        userId: String,
        cigaretteId: String
    ) async throws {

        // MARK: Guest

        if userId == "guest" {

            try localStorage.deleteCigarette(
                id: cigaretteId
            )

            return
        }

        // MARK: Authenticated

        guard FirebaseManager.shared.isConfigured else {
            throw CigaretteRecordError.firebaseNotConfigured
        }

        do {

            try await firestoreService.deleteCigarette(
                userId: userId,
                cigaretteId: cigaretteId
            )

        } catch {

            AppLogger.error(
                "Failed to delete cigarette from Firestore",
                error: error,
                category: AppLogger.firestore
            )

            throw error
        }
    }

    // MARK: - Date Range

    private func dayRange(
        for date: Date
    ) -> (
        start: Date,
        end: Date
    ) {

        let calendar = Calendar.current

        let start = calendar.startOfDay(
            for: date
        )

        let end = calendar.date(
            byAdding: .day,
            value: 1,
            to: start
        )!

        return (
            start: start,
            end: end
        )
    }
}

// MARK: - Error

enum CigaretteRecordError: LocalizedError {

    case firebaseNotConfigured

    var errorDescription: String? {

        switch self {

        case .firebaseNotConfigured:
            return "Firebase is not configured."
        }
    }
}
