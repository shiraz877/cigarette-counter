//
//  UserModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 19/08/26.
//


import Foundation

struct UserModel: Identifiable, Codable, Hashable {

 
    let id: String

   
    var displayName: String?
    var email: String
    let createdAt: Date
    var updatedAt: Date

    init(
        id: String,
        displayName: String? = nil,
        email: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
   
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.createdAt = createdAt
        self.updatedAt = updatedAt
   
    }
}

