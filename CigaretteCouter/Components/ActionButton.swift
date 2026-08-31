//
//  ActionButton.swift
//  CigaretteCouter
//
//  Created by Shiraz on 21/08/26.
//

import SwiftUI

struct AccountButton: View {
    
    enum ButtonStyle {
        case apple
        case google
        case email
    }
    
    let title: String
    let style: ButtonStyle
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            HStack(spacing: 12) {
                
                if style == .apple {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 26))
                }
                
                if style == .google {

                    Image("googleIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                
                Text(title)
                    .font(.system(size: 16))
            }
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay {
                if style == .email {
                    Capsule()
                        .stroke(
                            AppColors.tertiaryColor,
                            lineWidth: 1
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private var backgroundColor: Color {
        
        switch style {
        case .apple:
            return AppColors.primaryColor
            
        case .google:
            return AppColors.tertiaryColor.opacity(0.5)

            
            
        case .email:
            return .clear
        }
    }
    
    private var foregroundColor: Color {
        
        switch style {
        case .apple:
            return AppColors.neutralColor
            
        case .google, .email:
            return AppColors.primaryColor
        }
    }
}
