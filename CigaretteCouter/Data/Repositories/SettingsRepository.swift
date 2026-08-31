//
//  SettingsRepository.swift
//  CigaretteCouter
//
//  Created by Shiraz on 20/08/26.
//

import Foundation

protocol SettingsRepositoryProtocol: Sendable {
    func getSettings() async throws -> UserSettingModel
    func saveSettings(_ settings: UserSettingModel) async throws
    func deleteAllHistory() async throws
}

final class SettingsRepository: SettingsRepositoryProtocol, @unchecked Sendable {

    private let localStorage: LocalStorageProtocol

    init(
        localStorage: LocalStorageProtocol = LocalStorage.shared
    ) {
        self.localStorage = localStorage
    }

    func getSettings() async throws -> UserSettingModel {
        try localStorage.getUserSettings()
    }

    func saveSettings(_ settings: UserSettingModel) async throws {
        try localStorage.saveUserSettings(settings)
    }
    
    func deleteAllHistory() async throws {
           try await localStorage.deleteAll()
    }
}
