//
//  PrimaryButton.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    var iconName: String? = nil
    var isLoading: Bool = false
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack{
                if isLoading{
                    ProgressView()
                }
                else{
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .tracking(1.2)
                    if let icon = iconName{
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .semibold))

                    }
                }
            }
            .foregroundStyle(AppColors.secondaryColor)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(AppColors.primaryColor)
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
}


