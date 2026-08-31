//
//  AppViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI
import Observation

@Observable
@MainActor
final class AppViewModel {

    // MARK: - Onboarding

    var hasCompletedOnboarding: Bool

    // MARK: - Navigation

    var selectedTab: MainTab = .home

    // MARK: - Language

    var selectedLanguage: AppLanguage {
        didSet {
            UserPreferences.shared.appLanguage = selectedLanguage
        }
    }

    // MARK: - Authentication

    private(set) var isAuthenticated = false
    private(set) var currentUser: UserModel?

    var currentUserName: String? {
        currentUser?.displayName
    }

    var currentUserEmail: String? {
        currentUser?.email
    }

    // MARK: - Dependencies

    private let authRepository: AuthRepositoryProtocol
    
//    var showToast = false
//    var toastMessage = ""
    var showToast = false
    var toastMessage = ""

    private var toastTask: Task<Void, Never>?

    func showToastMessage(_ message: String) {
        // Cancel previous toast timer
        toastTask?.cancel()

        toastMessage = message

        withAnimation(.easeInOut(duration: 0.25)) {
            showToast = true
        }

        toastTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(2))

            guard !Task.isCancelled else { return }

            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.25)) {
                    self?.showToast = false
                }
            }
        }
    }

    // MARK: - Init

    init(
        authRepository: AuthRepositoryProtocol = AuthRepository()
    ) {
        self.authRepository = authRepository

        self.hasCompletedOnboarding =
            UserPreferences.shared.hasCompletedOnboarding

        self.selectedLanguage =
            UserPreferences.shared.appLanguage
    }

    // MARK: - Language

    func setLanguage(_ language: AppLanguage) {
        selectedLanguage = language
    }

    // MARK: - Onboarding

    func completeOnboarding() {
        UserPreferences.shared.hasCompletedOnboarding = true
        hasCompletedOnboarding = true
    }

    // MARK: - Authentication

    func setAuthenticatedUser(
        _ user: UserModel
    ) {
        currentUser = user
        isAuthenticated = true
    }

    // MARK: - Restore Authentication

    func restoreAuthentication() async {
        do {
            guard let user = try await authRepository.getCurrentUser()
            else {
                clearAuthenticationState()
                return
            }

            setAuthenticatedUser(user)

        } catch {
            clearAuthenticationState()

            print(
                "Failed to restore authentication:",
                error.localizedDescription
            )
        }
    }

    // MARK: - Sign Out

    func signOut() async {
        do {
            try await authRepository.signOut()

            clearAuthenticationState()
            selectedTab = .home
//            toastMessage = "Logged out successfully"
//            showToast = true
            showToastMessage("Logged out successfully")

        } catch {
            print(
                "Failed to sign out:",
                error.localizedDescription
            )
            showToastMessage("Unable to log out")
        }
    }

    // MARK: - Private

    private func clearAuthenticationState() {
        currentUser = nil
        isAuthenticated = false
    }

    // MARK: - Main Tab

    enum MainTab: Int, CaseIterable, Identifiable {

        case home
        case analytics
        case settings

        var id: Int {
            rawValue
        }

        var title: LocalizedStringKey {
            switch self {
            case .home:
                return "tab.home"

            case .analytics:
                return "tab.analytics"

            case .settings:
                return "tab.settings"
            }
        }

        var iconName: String {
            switch self {
            case .home:
                return "house.fill"

            case .analytics:
                return "chart.bar.xaxis"

            case .settings:
                return "gearshape.fill"
            }
        }
    }



}
