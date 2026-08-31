//
//  SettingView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI
import Observation

struct SettingsView: View {
    
    @State private var showDeleteAlert = false
    @State private var viewModel = SettingsViewModel()
    @State private var editingSetting: SettingEditor?
    @Environment(AppViewModel.self)
    private var appViewModel
    @Environment(\.openURL) private var openURL
    @State private var showLogoutToast = false
    

    enum SettingEditor: Identifiable {
        case cigarettePrice
        case language

        var id: Self { self }
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 48) {
                
                // MARK: Title
                
                Text("Settings")
                    .font(
                        .system(
                            size: 52,
                            weight: .bold
                        )
                    )
                    .tracking(-2)
                    .foregroundStyle(.white)
                    .padding(.top, 32)
                
                // MARK: Tracking
                
                settingsSection(title: "tracking_title") {
                    

                    SettingsRowView(
                        title: "Cigarette price",
                        value: viewModel.cigarettePrice,
                        trailingIcon: "pencil"
                    ) {
                        editingSetting = .cigarettePrice
                    }
                    
//                    SettingsRowView(
//                        title: "Cigarette price",
//                        value: viewModel.cigarettePrice
//                    ) {
//                        editingSetting = .cigarettePrice
//                    }
                    Divider().overlay(AppColors.primaryColor)
                    

                    
                }
                
                
               
                
                
                // MARK: Privacy
                
                settingsSection(title: "PRIVACY") {
                    
                    SettingsActionRowView(
                        title: "Privacy Policy",
                        icon: "arrow.forward"
                    ) {
                        openURL(AppConstants.URLs.privacyPolicy)
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                    
                    SettingsActionRowView(
                        title: "Terms of Service",
                        icon: "arrow.forward"
                    ) {
                        openURL(AppConstants.URLs.termsOfUse)

                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                }
                
                // MARK: App
                
                settingsSection(title: "APP") {
                    SettingsActionRowView(
                        title: "Language",
                        icon: "globe"
                    ) {
                        editingSetting = .language
                    }

                    Divider()
                        .overlay(AppColors.primaryColor)
                    
                    SettingsActionRowView(
                        title: "Rate us",
                        icon: "star"
                    ) {
                        viewModel.rateApp()
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                    
                    SettingsActionRowView(
                        title: "Share",
                        icon: "square.and.arrow.up"
                    ) {
                        viewModel.shareApp()
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                    
                    SettingsActionRowView(
                        title: "Support",
                        icon: "questionmark"
                    ) {
                        viewModel.openSupport()
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                }
                
                settingsSection(title: "DATA") {
        
                    SettingsActionRowView(
                        title: "Log Out",
                        icon: "rectangle.portrait.and.arrow.right",
                        isDestructive: true
                    ) {
                   logOut()
                   
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                    SettingsActionRowView(
                        title: "Delete all history",
                        icon: "trash",
                        isDestructive: true
                    ) {
                        showDeleteAlert = true
                    }
                    Divider().overlay(AppColors.primaryColor)
                    
                }
                
          
                
                
                
                
                
                // Bottom spacing
                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 672)
            .frame(maxWidth: .infinity)
        }
        
        .task {
            await viewModel.loadSettings()
        }
        .mainBackgroundColor()
        .scrollBounceBehavior(.basedOnSize)
        .alert(
            "Delete all history?",
            isPresented: $showDeleteAlert
        ) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteAll()
                }
                
            }
            
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
                .foregroundStyle(AppColors.neutralColor)
            
        }
        .sheet(item: $editingSetting) { setting in
            
            NavigationStack {
                
                switch setting {

                    
                    
                case .cigarettePrice:
                    
                    CigarettePriceView(
                        initialPricePaise: viewModel.settings.cigarettePricePaise
                    ) { paise in
                    
                        await viewModel.updateCigarettePrice(paise)
                    }
                case .language:
                    LanguageSettingsView()
                    

                }
            }
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            
        }
    }
    
}

// MARK: - Section
extension SettingsView {
    
    @ViewBuilder
    func settingsSection<Content: View>(
//        title: String,
        title: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.5)
                .foregroundStyle(AppColors.tertiaryColor)
            
            VStack(spacing: 0) {
                content()
            }
        }
    }

    private func logOut() {
        Task {
            await appViewModel.signOut()


        }
    }
}











