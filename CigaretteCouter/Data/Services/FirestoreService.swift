//
//  FirestoreService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 22/08/26.
//


import Foundation
import FirebaseFirestore

protocol FirestoreServiceProtocol: Sendable {

    func fetchCigarettes(
        userId: String,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [CigaretteModel]

    func fetchAllCigarettes(
        userId: String
    ) async throws -> [CigaretteModel]

    func saveCigarette(
        userId: String,
        cigarette: CigaretteModel
    ) async throws

    func deleteCigarette(
        userId: String,
        cigaretteId: String
    ) async throws
}

final class FirestoreService: FirestoreServiceProtocol, @unchecked Sendable {

    static let shared = FirestoreService()

    private let db: Firestore

    private init() {
        self.db = FirebaseManager.shared.firestore
    }

    // MARK: - Collection

    private func cigarettesCollection(
        userId: String
    ) -> CollectionReference {

        db.collection("users")
            .document(userId)
            .collection("cigarettes")
    }

    // MARK: - Save

    func saveCigarette(
        userId: String,
        cigarette: CigaretteModel
    ) async throws {

        let document = cigarettesCollection(userId: userId)
            .document(cigarette.id)

      

        do {
            try document.setData(
                from: cigarette,
                merge: true
            )

          

        } catch {
            

            throw error
        }
    }

    // MARK: - Fetch

    func fetchCigarettes(
        userId: String,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [CigaretteModel] {

        let snapshot = try await cigarettesCollection(userId: userId)
            .whereField(
                "smokedAt",
                isGreaterThanOrEqualTo: Timestamp(date: startDate)
            )
            .whereField(
                "smokedAt",
                isLessThan: Timestamp(date: endDate)
            )
            .order(
                by: "smokedAt",
                descending: false
            )
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: CigaretteModel.self)
        }
    }

    // MARK: - Fetch All

    func fetchAllCigarettes(
        userId: String
    ) async throws -> [CigaretteModel] {

        let snapshot = try await cigarettesCollection(userId: userId)
            .order(
                by: "smokedAt",
                descending: false
            )
            .getDocuments()

        return try snapshot.documents.map {
            try $0.data(as: CigaretteModel.self)
        }
    }

    // MARK: - Delete

    func deleteCigarette(
        userId: String,
        cigaretteId: String
    ) async throws {

        let document = cigarettesCollection(userId: userId)
            .document(cigaretteId)

        try await document.delete()

   
    }
}
