//
//  StorageService.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

/// Handles persisting and loading jobs to/from UserDefaults via JSON encoding.
enum StorageService {
    private static let jobsKey = "savedJobs"

    /// Encodes the jobs array to JSON and writes it to UserDefaults.
    static func saveJobs(_ jobs: [Job]) {
        guard let data = try? JSONEncoder().encode(jobs) else { return }
        UserDefaults.standard.set(data, forKey: jobsKey)
    }

    /// Reads the saved JSON from UserDefaults and decodes it back into a `[Job]` array.
    static func loadJobs() -> [Job] {
        guard let data = UserDefaults.standard.data(forKey: jobsKey),
              let jobs = try? JSONDecoder().decode([Job].self, from: data) else {
            return []
        }
        return jobs
    }
}
