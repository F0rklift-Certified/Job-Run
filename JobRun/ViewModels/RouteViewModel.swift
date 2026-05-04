//
//  RouteViewModel.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

@Observable
class RouteViewModel {
    var routeResult: RouteResult?
    var isLoading = false
    var errorMessage: String?

    func calculateRoute(for jobs: [Job]) async {
        guard !jobs.isEmpty else {
            errorMessage = "No jobs to route"
            return
        }

        isLoading = true
        errorMessage = nil
        routeResult = nil

        do {
            let result = try await RouteService.shared.calculateOptimizedRoute(jobs: jobs)
            routeResult = result
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func optimizedJobs(from jobs: [Job]) -> [Job] {
        guard let result = routeResult, !result.optimizedOrder.isEmpty else { return jobs }

        let homeAddress = RouteService.shared.homeAddress
        if homeAddress.isEmpty {
            guard jobs.count > 1 else { return jobs }
            let remaining = Array(jobs[1...])
            var optimized = [jobs[0]]
            for idx in result.optimizedOrder {
                if idx < remaining.count {
                    optimized.append(remaining[idx])
                }
            }
            return optimized
        } else {
            var optimized: [Job] = []
            for idx in result.optimizedOrder {
                if idx < jobs.count {
                    optimized.append(jobs[idx])
                }
            }
            return optimized.isEmpty ? jobs : optimized
        }
    }
}
