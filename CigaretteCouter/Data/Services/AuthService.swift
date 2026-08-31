//
//  AuthService.swift
//  CigaretteCouter
//
//  Created by Shiraz on 20/08/26.
//


import Foundation
import FirebaseAuth
import FirebaseCore


protocol AuthServiceProtocol: Sendable {

    func getCurrentUser() async -> UserModel?

    func signIn(
        email: String,
        password: String,
    
    ) async throws -> UserModel

    func signUp(
        email: String,
        password: String,
        displayName: String
    ) async throws -> UserModel

    func sendPasswordReset(
        email: String
    ) async throws

    func signOut() throws

    func signInWithGoogle(
        idToken: String,
        accessToken: String
    ) async throws -> UserModel
    func signInWithApple(
        idToken: String,
        rawNonce: String,
        fullName: PersonNameComponents?
    ) async throws -> UserModel
}



import Foundation
import FirebaseAuth

final class AuthService: AuthServiceProtocol, @unchecked Sendable {

    static let shared = AuthService()

    private init() {}

    private var auth: Auth {
        precondition(
            FirebaseApp.app() != nil,
            "Firebase must be configured before AuthService is used."
        )

        return Auth.auth()
    }

    func getCurrentUser() async -> UserModel? {

        guard let firebaseUser = auth.currentUser else {
            return nil
        }

        return UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? ""
           
    
        )
    }

    func signIn(
        email: String,
        password: String
    ) async throws -> UserModel {

        let result = try await auth.signIn(
            withEmail: email,
            password: password
        )

        let firebaseUser = result.user

        return UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? ""
        )
    }

    func signUp(
        email: String,
        password: String,
        displayName: String
        
      
    ) async throws -> UserModel {

        let result = try await auth.createUser(
            withEmail: email,
            password: password,
           
        )

        let firebaseUser = result.user

        return UserModel(
            id: firebaseUser.uid,
            displayName: displayName,
            email: firebaseUser.email ?? ""
            
        )
    }

    func signOut() throws {
        try auth.signOut()
    }
    
    func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

}

extension AuthService {

    func signInWithGoogle(
        idToken: String,
        accessToken: String
    ) async throws -> UserModel {

        let credential =
            GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

        let result =
            try await auth.signIn(with: credential)

        let firebaseUser = result.user

        return UserModel(
            id: firebaseUser.uid,
            displayName: firebaseUser.displayName,
            email: firebaseUser.email ?? ""
        )
    }
   

    func signInWithApple(
        idToken: String,
        rawNonce: String,
        fullName: PersonNameComponents?
    ) async throws -> UserModel {

        let credential =
            OAuthProvider.appleCredential(
                withIDToken: idToken,
                rawNonce: rawNonce,
                fullName: fullName
            )

        let result =
            try await Auth.auth().signIn(
                with: credential
            )

        let firebaseUser = result.user

        let displayName =
            makeDisplayName(
                fullName: fullName,
                firebaseUser: firebaseUser
            )

        return UserModel(
            id: firebaseUser.uid,
            displayName: displayName,
            email: firebaseUser.email ?? ""
        )
    }
    
}
private func makeDisplayName(
    fullName: PersonNameComponents?,
    firebaseUser: FirebaseAuth.User
) -> String {

    if let fullName {

        let formatter =
            PersonNameComponentsFormatter()

        let name =
            formatter.string(from: fullName)
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        if !name.isEmpty {
            return name
        }
    }

    if let displayName =
        firebaseUser.displayName,
        !displayName.isEmpty {

        return displayName
    }

    return "User"
}
