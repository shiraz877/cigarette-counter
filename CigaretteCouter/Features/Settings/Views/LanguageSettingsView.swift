//////
//////  LanguageSettingsView.swift
//////  CigaretteCouter
//////
//////  Created by Shiraz on 29/08/26.
//////
////
////import SwiftUI
////
////struct LanguageSettingsView: View {
////
////    @Environment(AppViewModel.self)
////    private var appViewModel
////
////    var body: some View {
////        List {
////
////            Section {
////
////                Picker(
////                    "settings.language",
////                    selection: Binding(
////                        get: {
////                            appViewModel.selectedLanguage
////                        },
////                        set: { language in
////                            appViewModel.setLanguage(language)
////                        }
////                    )
////                ) {
////                    ForEach(AppLanguage.allCases) { language in
////                        Text(language.displayName)
////                            .tag(language)
////                            .foregroundStyle(.white)
////                    }
////                }
////                .foregroundStyle(.white)
////
////            } header: {
////                Text("settings.language")
////                    .foregroundStyle(AppColors.primaryColor)
////            }
////        }
////        .navigationTitle("settings.language")
////        .background(Color.black)
////        .foregroundStyle(.white)
////    }
////}
//
//import SwiftUI
//
//struct LanguageSettingsView: View {
//
//    @Environment(AppViewModel.self)
//    private var appViewModel
//
//    var body: some View {
//        List {
//            Section {
//                Picker(
//                    "settings.language",
//                    selection: Binding(
//                        get: {
//                            appViewModel.selectedLanguage
//                        },
//                        set: { language in
//                            appViewModel.setLanguage(language)
//                        }
//                    )
//                ) {
//                    ForEach(AppLanguage.allCases) { language in
//                        Text(language.displayName)
//                            .foregroundStyle(.white)
//                            .tag(language)
//                    }
//                }
//                .foregroundStyle(.black)
//
//            } header: {
//                Text("settings.language")
//                    .foregroundStyle(AppColors.primaryColor)
//            }
//        }
//        // Remove the default List background
//        .scrollContentBackground(.hidden)
//
//        // Make the entire sheet black
//        .background(Color.black)
//
//        // Make List text white
//        .foregroundStyle(.white)
//
//        .navigationTitle("settings.language")
//        .navigationBarTitleDisplayMode(.inline)
//
//        // Make navigation bar dark
//        .toolbarColorScheme(.dark, for: .navigationBar)
//    }
//}
//

import SwiftUI

struct LanguageSettingsView: View {

    @Environment(AppViewModel.self)
    private var appViewModel

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
    }
}


