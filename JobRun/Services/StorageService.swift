//
//  StorageService.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

enum StorageService {
    private static let jobsKey = "savedJobs"

    static func saveJobs(_ jobs: [Job]) {
        guard let data = try? JSONEncoder().encode(jobs) else { return }
        UserDefaults.standard.set(data, forKey: jobsKey)
    }

    static func loadJobs() -> [Job] {
        guard let data = UserDefaults.standard.data(forKey: jobsKey),
              let jobs = try? JSONDecoder().decode([Job].self, from: data) else {
            return []
        }
        return jobs
    }
}
