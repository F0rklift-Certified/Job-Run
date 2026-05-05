//
//  RouteViewModel.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

/// Manages route calculation state and exposes results/errors to the route UI.
@Observable
class RouteViewModel {
    /// The most recent route calculation result, or `nil` if no route has been calculated yet.
    var routeResult: RouteResult?
    /// Whether a route calculation is currently in progress.
    var isLoading = false
    /// A user-facing error message if the last route calculation failed.
    var errorMessage: String?

    /// Calculates an optimized driving route for the given jobs via `RouteService`.
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

    /// Reorders jobs based on the optimized route. When no home address is set, the first job is kept as the origin.
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
