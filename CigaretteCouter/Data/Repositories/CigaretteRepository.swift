//
//  CigaretteRepository.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//


import Foundation

protocol CigaretteRepositoryProtocol: Sendable {

    func fetchCigarettes(
        userId: String,
        date: Date
    ) async throws-> [CigaretteModel]

    func fetchAllCigarettes(
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

final class CigaretteRepository:
    CigaretteRepositoryProtocol,
    @unchecked Sendable {

    static let shared = CigaretteRepository()

    private let cigaretteRecordService: CigaretteRecordServiceProtocol

    init(
        cigaretteRecordService: CigaretteRecordServiceProtocol =
            CigaretteRecordService.shared
    ) {
        self.cigaretteRecordService = cigaretteRecordService
    }

    // MARK: - Read
    func fetchCigarettes(userId: String, date: Date) async throws -> [CigaretteModel] {

       try await cigaretteRecordService.getCigarettes(
            userId: userId,
            date: date
        )
    }

    // MARK: - Get All Cigarette
    func fetchAllCigarettes(
        userId: String
    ) async throws -> [CigaretteModel] {

        try await cigaretteRecordService.getAllCigarettes(
            userId: userId
        )
    }

    // MARK: - Write

    func recordCigarette(
        userId: String,
        smokedAt: Date,
        trigger: CigaretteTriggerModel?
    ) async throws -> CigaretteModel {

        try await cigaretteRecordService.recordCigarette(
            userId: userId,
            smokedAt: smokedAt,
            trigger: trigger
        )
    }

    // MARK: - Delete
    func deleteCigarette(
        userId: String,
        cigaretteId: String
    ) async throws {

        try await cigaretteRecordService.deleteCigarette(
            userId: userId,
            cigaretteId: cigaretteId
        )
    }
    

}
