//
//  CalendarView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct CalendarView: View {
    @Environment(JobStore.self) private var jobStore
    @State private var selectedDate = Date()
    @State private var showingAddJob = false
    @State private var showingDatePicker = false

    private var selectedDayJobs: [Job] {
        jobStore.jobs(for: selectedDate).sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection

                    if showingDatePicker {
                        inlineCalendarPicker
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    WeekStripView(selectedDate: $selectedDate)
                        .background(Color(.systemBackground))
                    Divider()
                        .overlay(Color(.systemGray5))
                    contentSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .bottomTrailing) {
                addFAB
            }
            .sheet(isPresented: $showingAddJob) {
                NavigationStack {
                    JobFormView(prefillDate: selectedDate)
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(selectedDate, format: .dateTime.month(.wide).year())
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(1.2)
                Text("Job Run")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            Spacer()
            Button {
                withAnimation(.spring(response: 0.3)) {
                    showingDatePicker.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text("CALENDAR")
                        .tracking(0.5)
                }
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
                .shadow(color: .green.opacity(0.3), radius: 4, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemBackground))
    }

    // MARK: - Content

    @ViewBuilder
    private var contentSection: some View {
        if selectedDayJobs.isEmpty {
            emptyState
        } else {
            timelineSection
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Jobs", systemImage: "briefcase")
        } description: {
            Text("No jobs scheduled for this day")
        } actions: {
            Button("Add Job") { showingAddJob = true }
        }
        .padding(.top, 40)
    }

    private var timelineSection: some View {
        VStack(spacing: 0) {
            if selectedDayJobs.count >= 2 {
                NavigationLink {
                    DayRouteView(date: selectedDate)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "map.fill")
                        Text("View Optimised Route")
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.green)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color(.systemBackground))
                }
                Divider()
                    .padding(.leading, 20)
            }

            TimelineJobsView(jobs: selectedDayJobs)
                .padding(.bottom, 100)
        }
    }

    // MARK: - Inline Calendar Picker

    private var inlineCalendarPicker: some View {
        VStack(spacing: 0) {
            DatePicker(
                "Select Date",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(.green)
            .padding(.horizontal)

            Button {
                withAnimation(.spring(response: 0.3)) {
                    selectedDate = Date()
                    showingDatePicker = false
                }
            } label: {
                Text("Go to Today")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.green, in: RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .padding(.bottom, 12)
        }
        .background(Color(.systemBackground))
    }

    // MARK: - FAB

    private var addFAB: some View {
        Button {
            showingAddJob = true
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.green, in: RoundedRectangle(cornerRadius: 16))
                .shadow(color: .green.opacity(0.4), radius: 8, y: 4)
        }
        .padding(.trailing, 24)
        .padding(.bottom, 32)
    }
}

// MARK: - Timeline

struct TimelineJobsView: View {
    let jobs: [Job]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(jobs) { job in
                NavigationLink {
                    JobFormView(existingJob: job)
                } label: {
                    TimelineRow(job: job)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TimelineRow: View {
    let job: Job

    var body: some View {
        JobCardView(job: job)
    }
}
#Preview("Calendar") {
    CalendarView()
        .environment(MockDataService.makePreviewStore())
}

