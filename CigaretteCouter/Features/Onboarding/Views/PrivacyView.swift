//
//  PrivacyView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct PrivacyView: View {
    var viewModel: OnboardingViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 24) {
       
            
            VStack(spacing: 0) {
                
                // MARK: Main Content
                
          
                    VStack(alignment: .leading, spacing: 0) {
                        
                        // Header
                        header
                        
                        // Visual / Value Props
                        valueProps
                        
                        // Continue Button
//                        continueButton
//                            .padding(.horizontal, 24)
//                            .padding(.top, 24)
//                            .padding(.bottom, 24)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 64)
                    .padding(.bottom, 32)
          
            }
            Spacer()
            PrimaryButton(title: "CONTINUE", iconName: "arrow.right"){
                viewModel.nextStep()
            }
        }
        .padding(AppTheme.standardPadding)
    }
}

extension PrivacyView {
    
    private var header: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Your data, your control.")
                .font(
                    .system(
                        size: 38,
                        weight: .bold
                    )
                )
                .tracking(-0.56)
                .foregroundStyle(AppColors.primaryColor)
//                .lineSpacing(4)
//                .fixedSize(
//                    horizontal: false,
//                    vertical: true
//                )
//            
            Text(
                "Your smoking history belongs to you. Keep your information private and manage your data from Settings."
            )
            .font(
                .system(
                    size: 16,
                    weight: .regular
                )
            )
            .foregroundStyle(AppColors.tertiaryColor)
            .lineSpacing(4)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .padding(.top, 32)
        .padding(.bottom, 64)
    }
}
extension PrivacyView {
    
    private var valueProps: some View {
        
        VStack(spacing: 0) {
            
            // Lock icon
            
            Image(systemName: "lock.fill")
                .font(
                    .system(
                        size: 80,
                        weight: .ultraLight
                    )
                )
                .foregroundStyle(AppColors.primaryColor)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 32)
            
            // Top border
            
            //            Rectangle()
            //                .fill(borderColor)
            //                .frame(height: 1)
            Divider()
                .overlay(AppColors.tertiaryColor)
            
            // Rows
            
            infoRow(
                icon: "eye.slash",
                title: "PRIVATE"
            )
            
            infoRow(
                icon: "checkmark",
                title: "SIMPLE"
            )
            
            infoRow(
                icon: "square.3.layers.3d.down.right",
                title: "TRANSPARENT"
            )
        }
    }
    
    private func infoRow(
        icon: String,
        title: String
    ) -> some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 16) {
                
                Image(systemName: icon)
                    .font(
                        .system(
                            size: 20,
                            weight: .light
                        )
                    )
                    .foregroundStyle(AppColors.primaryColor)
                    .frame(
                        width: 24,
                        height: 24
                    )
                
                Text(title)
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .tracking(1.2)
                    .foregroundStyle(AppColors.primaryColor)
                
                Spacer()
            }
            .padding(.vertical, 16)
            
            Divider()
                .overlay(AppColors.tertiaryColor)
        }
    }
}
//extension PrivacyView {
//    
//    private var continueButton: some View {
//        
//        PrimaryButton(title: "Contineu", iconName: "arrow.right"){
//            viewModel.nextStep()
//        }
//    }
//}


