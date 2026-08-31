//
//  AuthRepository.swift
//  CigaretteCouter
//
//  Created by Shiraz on 22/08/26.
//


import Foundation

protocol AuthRepositoryProtocol: Sendable {

    func signUp(
        email: String,
        password: String,
        displayName: String
    ) async throws -> UserModel

    func signIn(
        email: String,
        password: String
    ) async throws -> UserModel

    func sendPasswordReset(
        email: String
    ) async throws

    func signOut() async throws

    func getCurrentUser() async throws -> UserModel?
    
  

        func signInWithGoogle() async throws -> UserModel
    func signInWithApple() async throws -> UserModel
 
}

final class AuthRepository: AuthRepositoryProtocol, @unchecked Sendable {

    private let authService: AuthServiceProtocol
    private let googleSignInService:
        GoogleSignInServiceProtocol
    private let appleSignInService:
          AppleSignInServiceProtocol

    init(
        authService: AuthServiceProtocol = AuthService.shared,
        googleSignInService:
            GoogleSignInServiceProtocol =
                GoogleSignInService(),
        appleSignInService:
                 AppleSignInServiceProtocol =
                 AppleSignInService()
    ) {
        self.authService = authService
        self.googleSignInService =
             googleSignInService
        self.appleSignInService =
                  appleSignInService
    }

    // MARK: - Sign Up

    func signUp(
        email: String,
        password: String,
        displayName: String
    ) async throws -> UserModel {

        try await authService.signUp(
            email: email,
            password: password,
            displayName: displayName
            
        )
    }

    // MARK: - Sign In

    func signIn(
        email: String,
        password: String
    ) async throws -> UserModel {

        try await authService.signIn(
            email: email,
            password: password
        )
    }
    func signInWithGoogle() async throws -> UserModel {

        let result =
            try await googleSignInService.signIn()

        return try await authService.signInWithGoogle(
            idToken: result.idToken,
            accessToken: result.accessToken
        )
    }

    // MARK: - Password Reset

    func sendPasswordReset(
        email: String
    ) async throws {

        try await authService.sendPasswordReset(
            email: email
        )
    }

    // MARK: - Sign Out

    func signOut() async throws {

        try authService.signOut()
    }

    // MARK: - Current User

    func getCurrentUser() async throws -> UserModel? {

        try await authService.getCurrentUser()
    }
    func signInWithApple()
           async throws -> UserModel {

           let result =
               try await appleSignInService.signIn()

           return try await authService.signInWithApple(
               idToken: result.idToken,
               rawNonce: result.rawNonce,
               fullName: result.fullName
           )
       }
}
