//
//  LanguageSettingsView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 29/08/26.
//


import SwiftUI

struct LanguageSettingsView: View {

    @Environment(AppViewModel.self)
    private var appViewModel
    @Environment(\.dismiss)
    private var dismiss


    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {

                ForEach(AppLanguage.allCases) { language in

                    Button {
                        appViewModel.setLanguage(language)
                    } label: {
                        HStack {
                            Text(language.displayName)
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.white)

                            Spacer()

                            if appViewModel.selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(AppColors.primaryColor)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)

                    if language != AppLanguage.allCases.last {
                        Divider()
                            .overlay(AppColors.primaryColor.opacity(0.3))
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
        .background(Color.black)
        .navigationTitle("settings.language")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
//                            .background(
//                                Circle()
//                                    .fill(.white)
//                            )
//                            .shadow(
//                                color: .black.opacity(0.2),
//                                radius: 4,
//                                y: 2
//                            )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close")
            }
        }
    }
}


