//
//  MockDataService.swift
//  JobRun
//
//  Created by NB on 5/5/2026.
//

import Foundation
import CoreLocation

/// Provides sample job data for SwiftUI previews and development testing.
enum MockDataService {
    static let homeAddress = "25 Wentworth Ave, Darlinghurst NSW 2010"

    /// Creates an array of mock jobs spread across several days around today.
    static func generateJobs() -> [Job] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        let dayAfter = calendar.date(byAdding: .day, value: 2, to: today)!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let threeDaysOut = calendar.date(byAdding: .day, value: 3, to: today)!
        let fourDaysOut = calendar.date(byAdding: .day, value: 4, to: today)!
        let fiveDaysOut = calendar.date(byAdding: .day, value: 5, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!

        return [
            // MARK: - Today
            Job(
                clientName: "Sarah Johnson",
                address: "12 Harbour St, Sydney NSW 2000",
                date: today,
                notes: "Front and backyard mowing",
                status: .pending
            ),
            Job(
                clientName: "Mike Chen",
                address: "45 King St, Newtown NSW 2042",
                date: today,
                notes: "Hedge trimming and garden cleanup",
                status: .pending
            ),
            Job(
                clientName: "Emma Wilson",
                address: "7 Beach Rd, Bondi NSW 2026",
                date: today,
                notes: "Weekly lawn maintenance",
                status: .pending
            ),
            Job(
                clientName: "Priya Sharma",
                address: "30 Pitt St, Sydney NSW 2000",
                date: today,
                notes: "Weed removal and fertiliser application",
                status: .complete
            ),
            Job(
                clientName: "Liam Foster",
                address: "8 Bronte Rd, Bronte NSW 2024",
                date: today,
                notes: "Install new garden edging along driveway",
                status: .pending
            ),

            // MARK: - Tomorrow
            Job(
                clientName: "David Park",
                address: "88 Victoria Ave, Chatswood NSW 2067",
                date: tomorrow,
                notes: "Tree pruning — needs ladder",
                status: .pending
            ),
            Job(
                clientName: "Lisa Nguyen",
                address: "23 George St, Parramatta NSW 2150",
                date: tomorrow,
                notes: "Full garden redesign consultation",
                status: .pending
            ),
            Job(
                clientName: "Hannah Brooks",
                address: "15 Military Rd, Mosman NSW 2088",
                date: tomorrow,
                notes: "Leaf blowing and gutter clearance",
                status: .pending
            ),
            Job(
                clientName: "Oscar Ramirez",
                address: "42 Enmore Rd, Enmore NSW 2042",
                date: tomorrow,
                notes: "Retaining wall garden bed planting",
                status: .pending
            ),

            // MARK: - Day After Tomorrow
            Job(
                clientName: "James Taylor",
                address: "5 Ocean Pde, Coogee NSW 2034",
                date: dayAfter,
                notes: "Pressure washing driveway and patio",
                status: .pending
            ),
            Job(
                clientName: "Sophia Lee",
                address: "99 Willoughby Rd, Crows Nest NSW 2065",
                date: dayAfter,
                notes: "Lawn dethatching and aeration",
                status: .pending
            ),
            Job(
                clientName: "Ben Ackerman",
                address: "17 Avoca St, Randwick NSW 2031",
                date: dayAfter,
                notes: "Remove dead tree stump in backyard",
                status: .pending
            ),

            // MARK: - 3 Days Out
            Job(
                clientName: "Olivia Martinez",
                address: "62 Crown St, Surry Hills NSW 2010",
                date: threeDaysOut,
                notes: "Balcony planter installation",
                status: .pending
            ),
            Job(
                clientName: "Daniel Kim",
                address: "200 Campbell Pde, Bondi Beach NSW 2026",
                date: threeDaysOut,
                notes: "Irrigation system install — front yard",
                status: .pending
            ),

            // MARK: - 4 Days Out
            Job(
                clientName: "Grace Murphy",
                address: "55 Glebe Point Rd, Glebe NSW 2037",
                date: fourDaysOut,
                notes: "Monthly maintenance — mow, edge, blow",
                status: .pending
            ),
            Job(
                clientName: "Nathan Wright",
                address: "3 Macquarie St, Sydney NSW 2000",
                date: fourDaysOut,
                notes: "Rooftop garden weeding and pruning",
                status: .pending
            ),
            Job(
                clientName: "Chloe Adams",
                address: "28 Norton St, Leichhardt NSW 2040",
                date: fourDaysOut,
                notes: "Hedge shaping — front and side",
                status: .pending
            ),

            // MARK: - 5 Days Out
            Job(
                clientName: "Jack Sullivan",
                address: "14 Bayswater Rd, Potts Point NSW 2011",
                date: fiveDaysOut,
                notes: "Courtyard clean-up and new mulch layer",
                status: .pending
            ),
            Job(
                clientName: "Aisha Patel",
                address: "77 Victoria Rd, Drummoyne NSW 2047",
                date: fiveDaysOut,
                notes: "Turf replacement — 40 sqm backyard",
                status: .pending
            ),

            // MARK: - Yesterday
            Job(
                clientName: "Rachel Green",
                address: "110 Pacific Hwy, North Sydney NSW 2060",
                date: yesterday,
                notes: "Sprinkler system repair",
                status: .complete
            ),
            Job(
                clientName: "Tom Bradley",
                address: "34 Anzac Pde, Kensington NSW 2033",
                date: yesterday,
                notes: "Client unreachable",
                status: .cancelled
            ),
            Job(
                clientName: "Megan Clarke",
                address: "9 Blues Point Rd, McMahons Point NSW 2060",
                date: yesterday,
                notes: "Garden bed mulching and weeding",
                status: .complete
            ),

            // MARK: - 2 Days Ago
            Job(
                clientName: "Chris O'Brien",
                address: "19 Darling Dr, Darling Harbour NSW 2000",
                date: twoDaysAgo,
                notes: "Mulching and soil treatment",
                status: .complete
            ),
            Job(
                clientName: "Yuki Tanaka",
                address: "52 Bourke St, Redfern NSW 2016",
                date: twoDaysAgo,
                notes: "Backyard clean-up after storm damage",
                status: .complete
            ),

            // MARK: - 3 Days Ago
            Job(
                clientName: "Patrick Dunn",
                address: "6 Spit Rd, Mosman NSW 2088",
                date: threeDaysAgo,
                notes: "Seasonal pruning — roses and natives",
                status: .complete
            ),
            Job(
                clientName: "Zara Mitchell",
                address: "41 Oxford St, Paddington NSW 2021",
                date: threeDaysAgo,
                notes: "Cancelled — rain forecast",
                status: .cancelled
            ),
        ]
    }

    /// Returns a mock `RouteResult` for today's jobs (Sarah → Mike → Emma).
    static func generateRouteResult() -> RouteResult {
        RouteResult(
            optimizedOrder: [0, 1],
            polylineCoordinates: [
                CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2020),
                CLLocationCoordinate2D(latitude: -33.8750, longitude: 151.1950),
                CLLocationCoordinate2D(latitude: -33.8977, longitude: 151.1790),
                CLLocationCoordinate2D(latitude: -33.8950, longitude: 151.2100),
                CLLocationCoordinate2D(latitude: -33.8915, longitude: 151.2767)
            ],
            stopCoordinates: [
                CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2020),
                CLLocationCoordinate2D(latitude: -33.8977, longitude: 151.1790),
                CLLocationCoordinate2D(latitude: -33.8915, longitude: 151.2767)
            ],
            totalDistance: "18.5 km",
            totalDuration: "32 min",
            legs: [
                RouteLeg(distance: "8.1 km", duration: "15 min"),
                RouteLeg(distance: "10.4 km", duration: "17 min")
            ]
        )
    }

    /// Returns a `JobStore` pre-populated with mock jobs, ready for use in previews.
    static func makePreviewStore() -> JobStore {
        UserDefaults.standard.set(homeAddress, forKey: "homeAddress")
        let store = JobStore()
        store.jobs = generateJobs()
        return store
    }
}
