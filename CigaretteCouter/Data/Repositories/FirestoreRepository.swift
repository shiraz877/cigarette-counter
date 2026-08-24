////
////  FirestoreRepository.swift
////  CigaretteCouter
////
////  Created by Shiraz on 17/08/26.
////
//
//import FirebaseFirestore
//
//final class FirestoreRepository{
//    private let db: Firestore
//    
//    init(db: Firestore = FirebaseManager.shared.firestore){
//        self.db = db
//    }
//    
//    func test() async throws{
//        let data: [String: Any] = [
//            "test": "connected successfully"
//        ]
//        try await db.collection("test").document("connect").setData(data)
//    }
//}
//
