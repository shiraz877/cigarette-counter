//
//  SecondaryButton.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//




import SwiftUI

struct SecondaryButton: View {
    let title: String
    var iconName: String? = nil
    var isLoading: Bool = false
    var isBorder: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(isBorder ? AppColors.primaryColor : AppColors.neutralColor)
                } else {
                    Text(title.uppercased())
                        .font(.system(size: 16, weight: .bold))
                        .tracking(1.2)
                    
                    if let icon = iconName {
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
            .foregroundStyle(isBorder ? AppColors.primaryColor : AppColors.neutralColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background {
                // Solid fill for primary style, transparent background for border style
                if !isBorder {
                    Rectangle()
                        .fill(AppColors.primaryColor)
                }
            }
            .overlay {
                // Stroke outline for bordered style
                if isBorder {
                  Rectangle()
                        .stroke(AppColors.primaryColor, lineWidth: 1.5)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}
