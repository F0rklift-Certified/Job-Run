//
//  SettingsView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("homeAddress") private var homeAddress = ""
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("e.g. 10 Smith St, Sydney NSW", text: $homeAddress)
                        .textContentType(.fullStreetAddress)
                } header: {
                    Text("Home / Starting Address")
                } footer: {
                    Text("Your starting point for route calculations. Leave blank to start from your first job of the day.")
                }

                Section("Appearance") {
                    Picker("Theme", selection: $appearanceMode) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("About") {
                    LabeledContent("Version", value: "1.0")
                    LabeledContent("App", value: "JobRun")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

enum AppearanceMode: String, CaseIterable, Identifiable {
    case system, light, dark

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: "System"
        case .light: "Light"
        case .dark: "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

#Preview {
    SettingsView()
}
