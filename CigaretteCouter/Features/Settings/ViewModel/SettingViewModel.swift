//
//  SettingViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    
    @ObservationIgnored
    private let settingsRepository: SettingsRepositoryProtocol
    
    var settings = UserSettingModel()
    
    var isLoading = false
    var errorMessage: String?
    
    init(
        settingsRepository: SettingsRepositoryProtocol = SettingsRepository()
    ) {
        self.settingsRepository = settingsRepository
    }
    
    var dailyGoal: Int {
        settings.dailyGoal
    }
    
   
    var cigarettePrice: String {
        let rupees = Double(settings.cigarettePricePaise) / 100
        return "₹\(Int(rupees))"
    }
    
    var defaultTrigger: String {
        settings.defaultTrigger?.title ?? "None"
    }
    
    var dailyReminder: Bool {
        settings.dailyReminderEnabled
    }
    
    var eveningSummary: Bool {
        settings.eveningSummaryEnabled
    }
    
    
    
    
    
    func loadSettings() async {
        
        do {
            settings = try await settingsRepository.getSettings()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateDailyGoal(_ value: Int) async {
        
        settings.dailyGoal = value
        
        await saveSettings()
    }
    
  
    func updateCigarettePrice(_ paise: Int) async {
        
        settings.cigarettePricePaise = paise
        
        await saveSettings()
    }
    
    func updateDefaultTrigger(
        _ trigger: CigaretteTriggerModel?
    ) async {
        
        settings.defaultTrigger = trigger
        
        await saveSettings()
    }
    
    func toggleDailyReminder() async {
        
        settings.dailyReminderEnabled.toggle()
        
        await saveSettings()
    }
    
    func toggleEveningSummary() async {
        
        settings.eveningSummaryEnabled.toggle()
        
        await saveSettings()
    }
    
    func deleteAll() async  {
        do {
            
            try await settingsRepository.deleteAllHistory()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    
    func exportData() {
        print("Export data")
    }
    
 
    
    func openPrivacyPolicy() {
        print("Privacy policy")
    }
    
    func openTerms() {
        print("Terms of service")
    }
    
    func rateApp() {
        print("Rate app")
    }
    
    func shareApp() {
        print("Share app")
    }
    
    func openSupport() {
        print("Support")
    }
    var supportURL: URL? {
         var components = URLComponents()

         components.scheme = "mailto"
         components.path = AppConstants.Support.email
         components.queryItems = [
             URLQueryItem(
                 name: "subject",
                 value: AppConstants.Support.subject
             ),
             URLQueryItem(
                 name: "body",
                 value: supportEmailBody
             )
         ]

         return components.url
     }
    private var supportEmailBody: String {
           """
           Hi,

           I need help with Cigarette Counter.

           Please describe your issue below:

           

           ------------------------------
           App Information
           ------------------------------

           App Version: \(appVersion)
           iOS Version: \(iOSVersion)
           """
       }
    private var appVersion: String {
           Bundle.main.object(
               forInfoDictionaryKey: "CFBundleShortVersionString"
           ) as? String ?? "Unknown"
       }

       private var iOSVersion: String {
           ProcessInfo.processInfo.operatingSystemVersionString
       }
    
    
    
    
    private func saveSettings() async {
        
        do {
            try await settingsRepository.saveSettings(settings)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
