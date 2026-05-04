//
//  CalendarView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

enum CalendarMode: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

struct CalendarView: View {
    @Environment(JobStore.self) private var jobStore
    @State private var mode: CalendarMode = .month
    @State private var selectedDate = Date()
    @State private var showingAddJob = false

    private var selectedDayJobs: [Job] {
        jobStore.jobs(for: selectedDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("View", selection: $mode) {
                    ForEach(CalendarMode.allCases, id: \.self) { m in
                        Text(m.rawValue).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)

                switch mode {
                case .month:
                    MonthGridView(selectedDate: $selectedDate)
                case .week:
                    WeekStripView(selectedDate: $selectedDate)
                case .day:
                    DayHeaderView(selectedDate: $selectedDate)
                }

                Divider()

                if selectedDayJobs.isEmpty {
                    ContentUnavailableView {
                        Label("No Jobs", systemImage: "briefcase")
                    } description: {
                        Text("No jobs scheduled for this day")
                    } actions: {
                        Button("Add Job") { showingAddJob = true }
                    }
                } else {
                    jobsList
                }
            }
            .navigationTitle("JobRun")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddJob = true } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Today") {
                        withAnimation { selectedDate = Date() }
                    }
                }
            }
            .sheet(isPresented: $showingAddJob) {
                NavigationStack {
                    JobFormView(prefillDate: selectedDate)
                }
            }
        }
    }

    private var jobsList: some View {
        List {
            if selectedDayJobs.count >= 2 {
                NavigationLink {
                    DayRouteView(date: selectedDate)
                } label: {
                    Label("View Optimised Route", systemImage: "map")
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
            }

            ForEach(selectedDayJobs) { job in
                NavigationLink {
                    JobFormView(existingJob: job)
                } label: {
                    JobCardView(job: job)
                }
            }
            .onDelete { indexSet in
                for i in indexSet {
                    jobStore.deleteJob(selectedDayJobs[i])
                }
            }
        }
        .listStyle(.plain)
    }
}

struct DayHeaderView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current

    var body: some View {
        HStack {
            Button { changeDay(by: -1) } label: {
                Image(systemName: "chevron.left")
            }
            Spacer()
            VStack {
                Text(selectedDate, format: .dateTime.weekday(.wide))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(selectedDate, format: .dateTime.day().month(.wide).year())
                    .font(.headline)
            }
            Spacer()
            Button { changeDay(by: 1) } label: {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    private func changeDay(by value: Int) {
        if let newDate = calendar.date(byAdding: .day, value: value, to: selectedDate) {
            withAnimation { selectedDate = newDate }
        }
    }
}
#Preview("Calendar") {
    CalendarView()
        .environment(JobStore())
}

#Preview("Day Header") {
    DayHeaderView(selectedDate: .constant(.now))
}

