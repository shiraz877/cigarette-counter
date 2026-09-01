////
////  SettingRowView.swift
////  CigaretteCouter
////
////  Created by Shiraz on 21/08/26.
////
//
//import SwiftUI
//
//struct SettingsRowView: View {
//    let title: String
//    let value: String?
//    let showChevron: Bool
//    let trailingView: AnyView?
//    let action: () -> Void
//    
//    // Normal value row
//    init(
//        title: String,
//        value: String? = nil,
//        showChevron: Bool = false,
//        action: @escaping () -> Void
//    ) {
//        self.title = title
//        self.value = value
//        self.showChevron = showChevron
//        self.trailingView = nil
//        self.action = action
//    }
//    
//    // Custom trailing view row
//    init<TrailingContent: View>(
//        title: String,
//        @ViewBuilder trailingView: () -> TrailingContent,
//        action: @escaping () -> Void
//    ) {
//        self.title = title
//        self.value = nil
//        self.showChevron = false
//        self.trailingView = AnyView(trailingView())
//        self.action = action
//    }
//    
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 16) {
//                
//                Text(title)
//                    .font(.system(size: 16))
//                    .foregroundStyle(AppColors.primaryColor)
//                
//                Spacer()
//                
//                if let trailingView {
//                    trailingView
//                } else if let value {
//                    HStack(spacing: 8) {
//                        
//                        Text(value)
//                            .font(.system(size: 16))
//                            .foregroundStyle(AppColors.tertiaryColor)
//                        
//                        if showChevron {
//                            Image(systemName: "chevron.right")
//                                .font(
//                                    .system(
//                                        size: 13,
//                                        weight: .medium
//                                    )
//                                )
//                                .foregroundStyle(AppColors.tertiaryColor)
//                        }
//                    }
//                }
//            }
//            .padding(.vertical, 16)
//            .contentShape(Rectangle())
//        }
//        .buttonStyle(.plain)
//    }
//}
//
//struct StatusBadge: View {
//    
//    let title: String
//    let isOn: Bool
//    
//    var body: some View {
//        
//        Text(title)
//            .font(
//                .system(
//                    size: 12,
//                    weight: .semibold
//                )
//            )
//            .tracking(1)
//            .foregroundStyle(
//                isOn
//                ? AppColors.neutralColor
//                : AppColors.tertiaryColor
//            )
//            .padding(.horizontal, 12)
//            .padding(.vertical, 4)
//            .background(
//                isOn
//                ? Color.white
//                :
////                    Color.surfaceContainerLow
//                AppColors.secondaryColor
//            )
//            .clipShape(Capsule())
//            .overlay {
//                if !isOn {
//                    Capsule()
//                        .stroke(
//                            AppColors.secondaryColor,
////                            Color.outline,
//                            lineWidth: 1
//                        )
//                }
//            }
//    }
//}

import SwiftUI

struct SettingsRowView: View {
//    let title: String
    let title: LocalizedStringKey
    let value: String?
    let showChevron: Bool
    let trailingIcon: String?
    let trailingView: AnyView?
    let action: () -> Void

    // Normal value row
    init(
        title: LocalizedStringKey,
        value: String? = nil,
        showChevron: Bool = false,
        trailingIcon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.value = value
        self.showChevron = showChevron
        self.trailingIcon = trailingIcon
        self.trailingView = nil
        self.action = action
    }

    // Custom trailing view row
    init<TrailingContent: View>(
        title: LocalizedStringKey,
        @ViewBuilder trailingView: () -> TrailingContent,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.value = nil
        self.showChevron = false
        self.trailingIcon = nil
        self.trailingView = AnyView(trailingView())
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {

                Text(title)
                    .font(.system(size: 16))
                    .foregroundStyle(AppColors.primaryColor)

                Spacer()

                if let trailingView {
                    trailingView

                } else if let value {
                    HStack(spacing: 10) {

                        Text(value)
                            .font(.system(size: 16))
                            .foregroundStyle(AppColors.tertiaryColor)

                        if let trailingIcon {
                            Image(systemName: trailingIcon)
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(
                                    AppColors.tertiaryColor
                                )

                        } else if showChevron {
                            Image(systemName: "chevron.right")
                                .font(
                                    .system(
                                        size: 13,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(
                                    AppColors.tertiaryColor
                                )
                        }
                    }
                }
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

//struct StatusBadge: View {
//    let title: String
//    let isOn: Bool
//
//    var body: some View {
//        Text(title)
//            .font(
//                .system(
//                    size: 12,
//                    weight: .semibold
//                )
//            )
//            .tracking(1)
//            .foregroundStyle(
//                isOn
//                ? AppColors.neutralColor
//                : AppColors.tertiaryColor
//            )
//            .padding(.horizontal, 12)
//            .padding(.vertical, 4)
//            .background(
//                isOn
//                ? Color.white
//                : AppColors.secondaryColor
//            )
//            .clipShape(Capsule())
//            .overlay {
//                if !isOn {
//                    Capsule()
//                        .stroke(
//                            AppColors.secondaryColor,
//                            lineWidth: 1
//                        )
//                }
//            }
//    }
//}

