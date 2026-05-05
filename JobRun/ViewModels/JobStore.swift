//
//  JobStore.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

/// Central data store for all jobs. Automatically persists changes to UserDefaults via `StorageService`.
@Observable
class JobStore {
    /// The full list of jobs; automatically saved to disk whenever modified.
    var jobs: [Job] = [] {
        didSet { StorageService.saveJobs(jobs) }
    }

    /// Loads previously saved jobs from disk on initialization.
    init() {
        jobs = StorageService.loadJobs()
    }

    /// Appends a new job to the store.
    func addJob(_ job: Job) {
        jobs.append(job)
    }

    /// Replaces an existing job (matched by ID) with the updated version.
    func updateJob(_ job: Job) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index] = job
        }
    }

    /// Removes the specified job from the store.
    func deleteJob(_ job: Job) {
        jobs.removeAll { $0.id == job.id }
    }

    /// Returns all jobs scheduled for the given date, sorted chronologically.
    func jobs(for date: Date) -> [Job] {
        jobs.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date < $1.date }
    }

    /// Returns `true` if at least one job is scheduled on the given date.
    func hasJobs(on date: Date) -> Bool {
        jobs.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    /// Returns the number of jobs scheduled on the given date.
    func jobCount(on date: Date) -> Int {
        jobs.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
    }
}
