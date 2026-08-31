//
//  AccountViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 27/08/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class AccountViewModel {

    // MARK: - State

    var isLoading = false
    var errorMessage: String?

    // MARK: - Dependencies

    @ObservationIgnored
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Init

    init(
        authRepository: AuthRepositoryProtocol = AuthRepository()
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Google Sign In

    func signInWithGoogle() async -> UserModel? {

        guard !isLoading else {
            return nil
        }

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let user =
                try await authRepository.signInWithGoogle()

            return user

        } catch {

            errorMessage =
                error.localizedDescription

            return nil
        }
    }
    func signInWithApple() async -> UserModel? {

          isLoading = true
          errorMessage = nil

          defer {
              isLoading = false
          }

          do {
              return try await authRepository.signInWithApple()

          } catch {

              errorMessage = error.localizedDescription
              return nil
          }
      }

}
