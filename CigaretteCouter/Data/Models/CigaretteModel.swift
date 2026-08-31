//
//  CigaretteModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//

import Foundation


struct CigaretteModel: Identifiable, Codable, Hashable {
    
    let id: String
    let smokedAt: Date
    let createdAt: Date
    let trigger: CigaretteTriggerModel?
    
    init(
        id: String = UUID().uuidString,
        smokedAt: Date = Date(),
        createdAt: Date = Date(),
        trigger: CigaretteTriggerModel? = nil,
        
    ) {
        self.id = id
        self.smokedAt = smokedAt
        self.createdAt = createdAt
        self.trigger = trigger
        
    }
}

