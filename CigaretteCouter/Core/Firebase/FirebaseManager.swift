//
//  FirebaseManager.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import FirebaseCore
import FirebaseFirestore

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    private(set) var isConfigured = false
    
    private init() {}
    
    func configure() {
        guard !isConfigured else {
            return
        }
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        isConfigured = true
    }
    
    var firestore: Firestore {
        precondition(
            isConfigured,
            "FirebaseManager.configure() must be called before accessing Firestore."
        )
        
        return Firestore.firestore()
    }
}
