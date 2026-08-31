//
//  UserSettingModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//




import Foundation

struct UserSettingModel: Codable, Hashable {

   
    var dailyGoal: Int

    var cigarettePricePaise: Int
    var defaultTrigger: CigaretteTriggerModel?
    var dailyReminderEnabled: Bool
    var eveningSummaryEnabled: Bool
    
    init(
        dailyGoal: Int = 0,

        cigarettePricePaise: Int = 1200,
        defaultTrigger: CigaretteTriggerModel? = nil,
        dailyReminderEnabled: Bool = false,
        eveningSummaryEnabled: Bool = false,
    ) {
        self.dailyGoal = dailyGoal

        self.cigarettePricePaise = cigarettePricePaise
        self.defaultTrigger = defaultTrigger
        self.dailyReminderEnabled = dailyReminderEnabled
        self.eveningSummaryEnabled = eveningSummaryEnabled
        
    }
}
