//
//  JobStore.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

@Observable
class JobStore {
    var jobs: [Job] = [] {
        didSet { StorageService.saveJobs(jobs) }
    }

    init() {
        jobs = StorageService.loadJobs()
    }

    func addJob(_ job: Job) {
        jobs.append(job)
    }

    func updateJob(_ job: Job) {
        if let index = jobs.firstIndex(where: { $0.id == job.id }) {
            jobs[index] = job
        }
    }

    func deleteJob(_ job: Job) {
        jobs.removeAll { $0.id == job.id }
    }

    func jobs(for date: Date) -> [Job] {
        jobs.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
            .sorted { $0.date < $1.date }
    }

    func hasJobs(on date: Date) -> Bool {
        jobs.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func jobCount(on date: Date) -> Int {
        jobs.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
    }
}
