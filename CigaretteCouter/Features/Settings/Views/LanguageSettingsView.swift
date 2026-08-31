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

    var body: some View {
        List {

            Section {

                Picker(
                    "settings.language",
                    selection: Binding(
                        get: {
                            appViewModel.selectedLanguage
                        },
                        set: { language in
                            appViewModel.setLanguage(language)
                        }
                    )
                ) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.displayName)
                            .tag(language)
                    }
                }

            } header: {
                Text("settings.language")
            }
        }
        .navigationTitle("settings.language")
    }
}
