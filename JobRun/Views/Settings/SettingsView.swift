//
//  SettingsView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("homeAddress") private var homeAddress = ""

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

                Section("About") {
                    LabeledContent("Version", value: "1.0")
                    LabeledContent("App", value: "JobRun")
                }
            }
            .navigationTitle("Settings")
        }
    }
}
