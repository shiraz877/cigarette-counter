//
//  ReadyView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI

@MainActor
struct ReadyView: View {
    var viewModel: OnboardingViewModel
    var onComplete: () -> Void
    

    
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
            
            
            
            VStack(spacing: 0) {
                
                
                
                // MARK: Main Content
                
                
                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    Text("Ready?")
                        .font(
                            .system(
                                size: 72,
                                weight: .bold,
                                design: .default
                            )
                        )
                        .tracking(-2.88)
                        .foregroundStyle(AppColors.primaryColor)
                        .fixedSize(
                            horizontal: false,
                            vertical: true
                        )
                    
                    Text(
                        "Start with your first cigarette and let the numbers tell the story."
                    )
                    .font(
                        .system(
                            size: 16,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(AppColors.tertiaryColor)
                    .lineSpacing(4)
                    .padding(.leading, 16)
                    .overlay(alignment: .leading) {
                        
                        Rectangle()
                            .fill(AppColors.secondaryColor)
                            .frame(width: 1)
                    }
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
                    Spacer()
                }
            }
            
            Spacer()
            PrimaryButton(title: "START TRACKING") {
                onComplete()
            }
        }
        .padding(AppTheme.standardPadding)
        
        
    }
    
}







