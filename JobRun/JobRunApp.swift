//
//  JobRunApp.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

@main
struct JobRunApp: App {
    @State private var jobStore: JobStore

    init() {
        let store = JobStore()
        #if DEBUG
        store.jobs = MockDataService.generateJobs()
        UserDefaults.standard.set("100 George St, Sydney NSW 2000", forKey: "homeAddress")
        #endif
        _jobStore = State(initialValue: store)
    }

    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(jobStore)
                .preferredColorScheme(appearanceMode.colorScheme)
        }
    }
}
