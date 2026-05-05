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

    private var selectedDayJobs: [Job] {
        jobStore.jobs(for: selectedDate).sorted { $0.date < $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    WeekStripView(selectedDate: $selectedDate)
                        .background(Color.white)
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
                Text("Calendar")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
            }
            Spacer()
            Button {
                withAnimation(.spring(response: 0.3)) { selectedDate = Date() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text("TODAY")
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
        .background(Color.white)
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
                    .background(Color.white)
                }
                Divider()
                    .padding(.leading, 20)
            }

            TimelineJobsView(jobs: selectedDayJobs)
                .padding(.bottom, 100)
        }
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
    let store = JobStore()
    let today = Date()
    store.jobs = [
        Job(
            clientName: "Sarah Mitchell",
            address: "42 Oxford Street, Sydney NSW 2000",
            date: today,
            notes: "Front and backyard mowing",
            status: .pending
        ),
        Job(
            clientName: "James Chen",
            address: "15 Bondi Road, Bondi NSW 2026",
            date: today,
            notes: "Hedge trimming and garden cleanup",
            status: .complete
        ),
        Job(
            clientName: "Emily Watson",
            address: "88 King Street, Newtown NSW 2042",
            date: today,
            notes: "Pressure wash driveway",
            status: .pending
        ),
        Job(
            clientName: "David Park",
            address: "7 Marine Parade, Manly NSW 2095",
            date: today,
            notes: "Pool area cleanup",
            status: .cancelled
        ),
    ]
    return CalendarView()
        .environment(store)
}

