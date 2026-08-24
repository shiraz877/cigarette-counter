//
//  SettingViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//



import SwiftUI
import Observation

@MainActor
@Observable
final class SettingsViewModel {

    private let dailyAverageKey = "dailyAverage"
    private let cigarettesPerPackKey = "cigarettesPerPack"
    private let packPriceKey = "packPrice"
    private let defaultTriggerKey = "defaultTrigger"
    private let dailyReminderKey = "dailyReminder"
    private let eveningSummaryKey = "eveningSummary"

    var dailyAverage: Int {
        didSet {
            UserDefaults.standard.set(
                dailyAverage,
                forKey: dailyAverageKey
            )
        }
    }

    var cigarettesPerPack: Int {
        didSet {
            UserDefaults.standard.set(
                cigarettesPerPack,
                forKey: cigarettesPerPackKey
            )
        }
    }

    var packPrice: String {
        didSet {
            UserDefaults.standard.set(
                packPrice,
                forKey: packPriceKey
            )
        }
    }

    var defaultTrigger: String {
        didSet {
            UserDefaults.standard.set(
                defaultTrigger,
                forKey: defaultTriggerKey
            )
        }
    }

    var dailyReminder: Bool {
        didSet {
            UserDefaults.standard.set(
                dailyReminder,
                forKey: dailyReminderKey
            )
        }
    }

    var eveningSummary: Bool {
        didSet {
            UserDefaults.standard.set(
                eveningSummary,
                forKey: eveningSummaryKey
            )
        }
    }

    init() {
        self.dailyAverage =
            UserDefaults.standard.object(
                forKey: dailyAverageKey
            ) as? Int ?? 0

        self.cigarettesPerPack =
            UserDefaults.standard.object(
                forKey: cigarettesPerPackKey
            ) as? Int ?? 0

        self.packPrice =
            UserDefaults.standard.string(
                forKey: packPriceKey
            ) ?? ""

        self.defaultTrigger =
            UserDefaults.standard.string(
                forKey: defaultTriggerKey
            ) ?? ""

        self.dailyReminder =
            UserDefaults.standard.object(
                forKey: dailyReminderKey
            ) as? Bool ?? false

        self.eveningSummary =
            UserDefaults.standard.object(
                forKey: eveningSummaryKey
            ) as? Bool ?? false
    }
}
