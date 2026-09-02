//
//  CigaretteCouterApp.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

@main
struct CigaretteCouterApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    @State private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {

                Group {
                    if appViewModel.hasCompletedOnboarding {
                        MainTabView()
                    } else {
                        OnboardingView()
                    }
                }

                // MARK: - Toast
                if appViewModel.showToast {
                    VStack {
                        Spacer()

                        Text(appViewModel.toastMessage)
                            .font(
                                .system(
                                    size: 14,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(

                                Color.green.opacity(0.8)
                            )
                            .clipShape(Capsule())
                            .shadow(
                                radius: 8,
                                y: 4
                            )
                            .padding(.bottom, 30)
                    }
                    .frame(maxWidth: .infinity)
                    .transition(
                        .move(edge: .bottom)
                            .combined(with: .opacity)
                    )
                    .zIndex(100)
                }
            }
            .animation(
                .easeInOut(duration: 0.25),
                value: appViewModel.showToast
            )
            .environment(appViewModel)
            .environment(
                \.locale,
                appViewModel.selectedLanguage.locale
            )
            .environment(
                \.layoutDirection,
                appViewModel.selectedLanguage.layoutDirection
            )
            .task {
                await appViewModel.restoreAuthentication()
            }
        }
    }
}
