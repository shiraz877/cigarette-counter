//
//  WelcomeView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

@MainActor
struct WelcomeView: View {
    var viewModel: OnboardingViewModel
    var body: some View {
        VStack( spacing: 24) {
            
            VStack(alignment: .leading){
                
                
                Text("3")
                    .font(.system(size: 104, weight: .medium))
                    .foregroundStyle(AppColors.primaryColor)
                
                Spacer()
                
                
                Text("Know how much you smoke.")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(AppColors.primaryColor)
                    .lineSpacing(2)
                
                Text("A simple way to track every cigarette and nunderstand your smoking habits.")
                    .font(.system(size: 23, weight: .regular))
                    .foregroundStyle(AppColors.tertiaryColor)
                    .lineSpacing(8)
                    .padding(.top, 24)
                
                Spacer()
                
                
            }
            
            PrimaryButton(title: "GET STARTED", iconName: "arrow.right"){
                viewModel.nextStep()
            }
            
        }
        .padding(AppTheme.standardPadding)
        
    }
}


