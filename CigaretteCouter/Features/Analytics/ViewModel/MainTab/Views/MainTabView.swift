//
//  MainTabView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//



import SwiftUI


// MARK: - Main Tab View

@MainActor
struct MainTabView: View {
    
    @Environment(AppViewModel.self)
    private var appViewModel
    

    
    var body: some View {
        @Bindable var appViewModel = appViewModel
        
        VStack{
            
            topAppBar
            
            Divider().overlay(AppColors.primaryColor)
            
            Spacer()
            
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
            .tint(AppColors.primaryColor)
            
        }
        .mainBackgroundColor()
        
    }
}
private var topAppBar: some View {
    HStack {
        Button(action: {}) {
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 20))
                .foregroundColor(.white)
        }
        
        Spacer()
        
        Text("INVENTORY")
            .font(.system(size: 20, weight: .black))
            .tracking(1.0)
            .foregroundColor(.white)
        
        Spacer()
        
        Button(action: {}) {
            Image(systemName: "person.circle")
                .font(.system(size: 22))
                .foregroundColor(.white)
        }
    }
    .padding(AppTheme.standardPadding)
    
    
}


#Preview {
    MainTabView()
        .environment(AppViewModel())
}






 

