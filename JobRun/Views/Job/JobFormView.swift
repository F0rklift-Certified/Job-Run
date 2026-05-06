//
//  JobFormView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct JobFormView: View {
    @Environment(JobStore.self) private var jobStore
    @Environment(\.dismiss) private var dismiss

    var existingJob: Job?
    var prefillDate: Date?

    @State private var clientName = ""
    @State private var address = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var status: JobStatus = .pending
    @State private var suggestions: [PlacePrediction] = []
    @State private var searchTask: Task<Void, Never>?
    @State private var showSuggestions = false
    @State private var suppressAutocomplete = false

    private var isEditing: Bool { existingJob != nil }

    private var isValid: Bool {
        !clientName.trimmingCharacters(in: .whitespaces).isEmpty
            && !address.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        Form {
            Section("Client Details") {
                TextField("Client Name", text: $clientName)
                    .textContentType(.name)

                TextField("Address", text: $address)
                    .textContentType(.fullStreetAddress)
                    .autocorrectionDisabled()
                    .onChange(of: address) { _, newValue in
                        searchTask?.cancel()
                        guard !suppressAutocomplete else {
                            suppressAutocomplete = false
                            return
                        }
                        guard !newValue.trimmingCharacters(in: .whitespaces).isEmpty else {
                            suggestions = []
                            showSuggestions = false
                            return
                        }
                        searchTask = Task {
                            try? await Task.sleep(for: .milliseconds(300))
                            guard !Task.isCancelled else { return }
                            let results = (try? await PlacesService.shared.autocomplete(query: newValue)) ?? []
                            guard !Task.isCancelled else { return }
                            suggestions = results
                            showSuggestions = !results.isEmpty
                        }
                    }

                if showSuggestions {
                    ForEach(suggestions) { suggestion in
                        Button {
                            suppressAutocomplete = true
                            address = suggestion.description
                            suggestions = []
                            showSuggestions = false
                        } label: {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundStyle(.secondary)
                                Text(suggestion.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
            }

            Section("Schedule") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Section("Notes") {
                TextField("Notes (optional)", text: $notes, axis: .vertical)
                    .lineLimit(3 ... 6)
            }

            if isEditing {
                Section("Status") {
                    HStack(spacing: 12) {
                        ForEach(JobStatus.allCases) { s in
                            Button {
                                status = s
                            } label: {
                                VStack(spacing: 4) {
                                    Image(systemName: s.icon)
                                        .font(.title3)
                                    Text(s.label)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    status == s ? s.color.opacity(0.2) : Color(.systemGray6),
                                    in: RoundedRectangle(cornerRadius: 10)
                                )
                                .foregroundStyle(status == s ? s.color : .secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section {
                    Button("Delete Job", role: .destructive) {
                        if let job = existingJob {
                            jobStore.deleteJob(job)
                        }
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Job" : "New Job")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(isEditing)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if !isEditing {
                    Button("Cancel") { dismiss() }
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button(isEditing ? "Save" : "Add") {
                    saveJob()
                }
                .disabled(!isValid)
            }
        }
        .onAppear {
            if let job = existingJob {
                clientName = job.clientName
                suppressAutocomplete = true
                address = job.address
                date = job.date
                notes = job.notes
                status = job.status
            } else if let prefillDate {
                date = prefillDate
            }
        }
    }

    private func saveJob() {
        let trimmedName = clientName.trimmingCharacters(in: .whitespaces)
        let trimmedAddress = address.trimmingCharacters(in: .whitespaces)

        if var job = existingJob {
            job.clientName = trimmedName
            job.address = trimmedAddress
            job.date = date
            job.notes = notes
            job.status = status
            jobStore.updateJob(job)
        } else {
            let job = Job(
                clientName: trimmedName,
                address: trimmedAddress,
                date: date,
                notes: notes
            )
            jobStore.addJob(job)
        }
        dismiss()
    }
}

#Preview("New Job") {
    NavigationStack {
        JobFormView()
    }
    .environment(MockDataService.makePreviewStore())
}

#Preview("Edit Job") {
    NavigationStack {
        JobFormView(existingJob: MockDataService.generateJobs().first!)
    }
    .environment(MockDataService.makePreviewStore())
}
