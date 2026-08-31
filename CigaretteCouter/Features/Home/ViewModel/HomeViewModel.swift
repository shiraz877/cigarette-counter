//
//  HomeViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class HomeViewModel {
    
    var cigarettes: [CigaretteModel] = []
    var selectedDate: Date = Date()
    var isLoading = false
    var isRecording = false
    
    var errorMessage: String?
    
    @ObservationIgnored
    private let cigaretteRepository: CigaretteRepositoryProtocol
    @ObservationIgnored
    private let settingsRepository: SettingsRepositoryProtocol
    
    var settings: UserSettingModel?
    
    init(
        cigaretteRepository: CigaretteRepositoryProtocol = CigaretteRepository(),
        settingsRepository: SettingsRepositoryProtocol = SettingsRepository()
    ) {
        self.cigaretteRepository = cigaretteRepository
        self.settingsRepository = settingsRepository
    }
    
    // MARK: - Computed Properties
    var cigaretteCount: Int {
        cigarettes.count
    }
    var latestCigarette: CigaretteModel? {
        cigarettes.max {
            $0.smokedAt < $1.smokedAt
        }
    }
    var cigarettesToday: Int {
        cigaretteCount
    }

    func loadCigarettes() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        let userId =
            await AuthService.shared.getCurrentUser()?.id ?? "guest"

        do {
            let records = try await cigaretteRepository.fetchCigarettes(
                userId: userId,
                date: selectedDate
            )

            settings = try await settingsRepository.getSettings()

            cigarettes = records.sorted {
                $0.smokedAt > $1.smokedAt
            }

        } catch {
            errorMessage = error.localizedDescription
        }
    }
    // MARK: - Record
    func recordCigarette(trigger: CigaretteTriggerModel? = nil) async {
        
        errorMessage = nil
        let userId =
        await    AuthService.shared.getCurrentUser()?.id ??
        "guest"
        
        do {
            
            let cigarette =
            try await cigaretteRepository.recordCigarette(
                userId: userId,
                smokedAt: Date(),
                trigger: trigger
            )
            
            cigarettes.insert(
                cigarette,
                at: 0
            )
            
        } catch {
            
            errorMessage = error.localizedDescription
            
            
        }
    }
    
    // MARK: - Delete
    func deleteCigarette(
        _ cigarette: CigaretteModel
    ) async {
        
        let userId =
        await  AuthService.shared.getCurrentUser()?.id ??
        "guest"
        
        do {
            
            try await cigaretteRepository.deleteCigarette(
                userId: userId,
                cigaretteId: cigarette.id
            )
            
            cigarettes.removeAll {
                $0.id == cigarette.id
            }
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
    func formatDuration(
        _ interval: TimeInterval
    ) -> String {
        
        let totalMinutes = Int(interval / 60)
        
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        
        return "\(minutes)m"
    }
}
