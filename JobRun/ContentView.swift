import SwiftUI

struct ContentView: View {
    @State private var jobStore = JobStore()

    var body: some View {
        TabView {
            CalendarView()
                .tabItem { Label("Jobs", systemImage: "calendar") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .environment(jobStore)
    }
}

#Preview {
    ContentView()
}
