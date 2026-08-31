//
//  EmailAuthViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 22/08/26.
//



import Foundation
import Observation

@MainActor
@Observable
final class EmailAuthViewModel {

    // MARK: - State

    var isLoading = false
    var errorMessage: String?
    var passwordResetMessage: String?

    // MARK: - Dependencies

    @ObservationIgnored
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Init

    init(
        authRepository: AuthRepositoryProtocol = AuthRepository()
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Sign Up

    func signUp(
        fullName: String,
        email: String,
        password: String
    ) async -> UserModel? {

        errorMessage = nil
        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let user = try await authRepository.signUp(
                email: email,
                password: password,
                displayName: fullName
            )

            return user

        } catch {

            errorMessage = error.localizedDescription
            return nil
        }
    }

    // MARK: - Sign In

    func signIn(
        email: String,
        password: String
    ) async -> UserModel? {

        errorMessage = nil
        isLoading = true

        defer {
            isLoading = false
        }

        do {

            let user = try await authRepository.signIn(
                email: email,
                password: password
            )

            return user

        } catch {

            errorMessage = error.localizedDescription
            return nil
        }
    }

    // MARK: - Forgot Password

    func sendPasswordReset(
        email: String
    ) async -> Bool {

        errorMessage = nil
        passwordResetMessage = nil
        isLoading = true

        defer {
            isLoading = false
        }

        do {

            try await authRepository.sendPasswordReset(
                email: email
            )

            passwordResetMessage =
                "Password reset link has been sent to your email."

            return true

        } catch {

            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: - Clear Error

    func clearError() {
        errorMessage = nil
    }
}
