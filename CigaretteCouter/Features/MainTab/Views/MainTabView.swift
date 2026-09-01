//
//  MainTabView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI

@MainActor
struct MainTabView: View {

    @Environment(AppViewModel.self)
    private var appViewModel

    @State private var showAccountSheet = false

    var body: some View {

        @Bindable var appViewModel = appViewModel

        VStack {

            topAppBar

            Divider()
                .overlay(AppColors.primaryColor)

            TabView(selection: $appViewModel.selectedTab) {

                Tab(
                    AppViewModel.MainTab.home.title,
                    systemImage: AppViewModel.MainTab.home.iconName,
                    value: AppViewModel.MainTab.home
                ) {
                    HomeView()
                }

                Tab(
                    AppViewModel.MainTab.analytics.title,
                    systemImage: AppViewModel.MainTab.analytics.iconName,
                    value: AppViewModel.MainTab.analytics
                ) {
                    AnalyticsView()
                }

                Tab(
                    AppViewModel.MainTab.settings.title,
                    systemImage: AppViewModel.MainTab.settings.iconName,
                    value: AppViewModel.MainTab.settings
                ) {
                    SettingsView()
                }
            }
            .tint(AppColors.neutralColor)
//            .tint(.red)
        }
        .mainBackgroundColor()
        .sheet(isPresented: $showAccountSheet) {
            AccountView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var topAppBar: some View {

        HStack {

            Text("PUFF COUNTER")
                .font(
                    .system(
                        size: 20,
                        weight: .black
                    )
                )
                .tracking(1.0)
                .foregroundStyle(
                    AppColors.primaryColor
                )

            Spacer()

            Button {
                showAccountSheet = true
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 22))
                    .foregroundStyle(AppColors.primaryColor)
            }
        }
        .padding(AppTheme.standardPadding)
    }
}

//#Preview {
//    MainTabView()
//        .environment(AppViewModel())
//}
