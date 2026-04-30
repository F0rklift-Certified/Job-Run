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
            guard jobs.count > 2 else { return jobs }
            let middle = Array(jobs[1 ..< jobs.count - 1])
            var optimized = [jobs[0]]
            for idx in result.optimizedOrder {
                if idx < middle.count {
                    optimized.append(middle[idx])
                }
            }
            optimized.append(jobs[jobs.count - 1])
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
