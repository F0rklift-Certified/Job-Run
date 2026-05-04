//
//  PlacesService.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import Foundation

struct PlacePrediction: Identifiable {
    let id: String
    let description: String
}

class PlacesService {
    static let shared = PlacesService()

    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
    }

    func autocomplete(query: String) async throws -> [PlacePrediction] {
        guard !apiKey.isEmpty else { return [] }
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

        var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json")!
        components.queryItems = [
            URLQueryItem(name: "input", value: query),
            URLQueryItem(name: "types", value: "address"),
            URLQueryItem(name: "key", value: apiKey)
        ]

        guard let url = components.url else { return [] }

        let (data, _) = try await URLSession.shared.data(from: url)

        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let predictions = json["predictions"] as? [[String: Any]] else {
            return []
        }

        return predictions.compactMap { prediction in
            guard let placeId = prediction["place_id"] as? String,
                  let description = prediction["description"] as? String else {
                return nil
            }
            return PlacePrediction(id: placeId, description: description)
        }
    }
}
