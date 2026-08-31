//
//  SettingActionRowView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 21/08/26.
//

import SwiftUI

struct SettingsActionRowView: View {

    let title: LocalizedStringKey
    let icon: String
    var isDestructive = false

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack {

                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(
                        isDestructive
                        ? Color(hex: "#FFB4AB")

                        : AppColors.primaryColor
                    )

                Spacer()

                Image(systemName: icon)
                    .font(.system(size: 19, weight: .light))
                    .foregroundStyle(
                        isDestructive
                        ? Color(hex: "#FFB4AB")
                        : AppColors.tertiaryColor
                    )
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
