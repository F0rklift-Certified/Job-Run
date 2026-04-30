import Foundation
import CoreLocation

struct RouteLeg {
    let distance: String
    let duration: String
}

struct RouteResult {
    let optimizedOrder: [Int]
    let polylineCoordinates: [CLLocationCoordinate2D]
    let stopCoordinates: [CLLocationCoordinate2D]
    let totalDistance: String
    let totalDuration: String
    let legs: [RouteLeg]
}

enum RouteError: LocalizedError {
    case noAPIKey
    case noJobs
    case invalidURL
    case noRouteFound
    case apiError(String)

    var errorDescription: String? {
        switch self {
        case .noAPIKey: "Google Maps API key not configured in Secrets.xcconfig"
        case .noJobs: "No jobs to route"
        case .invalidURL: "Invalid request"
        case .noRouteFound: "No route found between locations"
        case .apiError(let msg): msg
        }
    }
}

class RouteService {
    static let shared = RouteService()

    var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
    }

    var homeAddress: String {
        UserDefaults.standard.string(forKey: "homeAddress") ?? ""
    }

    func calculateOptimizedRoute(jobs: [Job]) async throws -> RouteResult {
        guard !apiKey.isEmpty else { throw RouteError.noAPIKey }
        guard !jobs.isEmpty else { throw RouteError.noJobs }

        let addresses = jobs.map { $0.address }
        let origin = homeAddress.isEmpty ? addresses[0] : homeAddress
        let destination = homeAddress.isEmpty ? addresses[addresses.count - 1] : homeAddress

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/directions/json")!
        var queryItems = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "key", value: apiKey)
        ]

        let waypointAddresses: [String]
        if homeAddress.isEmpty {
            waypointAddresses = addresses.count > 2 ? Array(addresses[1 ..< addresses.count - 1]) : []
        } else {
            waypointAddresses = addresses
        }

        if !waypointAddresses.isEmpty {
            let waypointStr = "optimize:true|" + waypointAddresses.joined(separator: "|")
            queryItems.append(URLQueryItem(name: "waypoints", value: waypointStr))
        }

        components.queryItems = queryItems

        guard let url = components.url else { throw RouteError.invalidURL }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw RouteError.noRouteFound
        }

        let status = json["status"] as? String ?? ""
        guard status == "OK" else {
            throw RouteError.apiError("API returned: \(status)")
        }

        guard let routes = json["routes"] as? [[String: Any]],
              let route = routes.first else {
            throw RouteError.noRouteFound
        }

        let waypointOrder = route["waypoint_order"] as? [Int] ?? []

        let overviewPolyline = route["overview_polyline"] as? [String: Any]
        let encoded = overviewPolyline?["points"] as? String ?? ""
        let coordinates = Self.decodePolyline(encoded)

        let legsJson = route["legs"] as? [[String: Any]] ?? []
        var totalDistMeters = 0
        var totalDurSeconds = 0
        var legs: [RouteLeg] = []
        var stops: [CLLocationCoordinate2D] = []

        for (i, leg) in legsJson.enumerated() {
            let dist = leg["distance"] as? [String: Any]
            let dur = leg["duration"] as? [String: Any]
            totalDistMeters += dist?["value"] as? Int ?? 0
            totalDurSeconds += dur?["value"] as? Int ?? 0
            legs.append(RouteLeg(
                distance: dist?["text"] as? String ?? "",
                duration: dur?["text"] as? String ?? ""
            ))

            if i == 0, let startLoc = leg["start_location"] as? [String: Any] {
                let lat = startLoc["lat"] as? Double ?? 0
                let lng = startLoc["lng"] as? Double ?? 0
                stops.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
            if let endLoc = leg["end_location"] as? [String: Any] {
                let lat = endLoc["lat"] as? Double ?? 0
                let lng = endLoc["lng"] as? Double ?? 0
                stops.append(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
        }

        return RouteResult(
            optimizedOrder: waypointOrder,
            polylineCoordinates: coordinates,
            stopCoordinates: stops,
            totalDistance: Self.formatDistance(totalDistMeters),
            totalDuration: Self.formatDuration(totalDurSeconds),
            legs: legs
        )
    }

    static func decodePolyline(_ encoded: String) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        let chars = Array(encoded.utf8)
        var index = 0
        var lat = 0
        var lng = 0

        while index < chars.count {
            var shift = 0
            var result = 0
            var byte: Int
            repeat {
                byte = Int(chars[index]) - 63
                index += 1
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20 && index < chars.count

            lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1)

            shift = 0
            result = 0
            repeat {
                byte = Int(chars[index]) - 63
                index += 1
                result |= (byte & 0x1F) << shift
                shift += 5
            } while byte >= 0x20 && index < chars.count

            lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1)

            coordinates.append(CLLocationCoordinate2D(
                latitude: Double(lat) / 1e5,
                longitude: Double(lng) / 1e5
            ))
        }

        return coordinates
    }

    private static func formatDistance(_ meters: Int) -> String {
        meters >= 1000 ? String(format: "%.1f km", Double(meters) / 1000.0) : "\(meters) m"
    }

    private static func formatDuration(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return h > 0 ? "\(h)h \(m)min" : "\(m) min"
    }
}
