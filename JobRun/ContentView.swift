//
//  ContentView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CalendarView()
                .tabItem { Label("Jobs", systemImage: "calendar") }

            NavigationStack {
                DayRouteView(date: .now)
            }
            .tabItem { Label("Today", systemImage: "figure.run") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .tint(.green)
    }
}

#Preview {
    ContentView()
        .environment(MockDataService.makePreviewStore())
}
