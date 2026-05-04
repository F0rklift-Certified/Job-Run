//
//  RouteMapView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import MapKit
import SwiftUI

struct RouteMapView: View {
    let routeResult: RouteResult

    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position) {
            if !routeResult.polylineCoordinates.isEmpty {
                MapPolyline(coordinates: routeResult.polylineCoordinates)
                    .stroke(.blue, lineWidth: 4)
            }

            ForEach(Array(routeResult.stopCoordinates.enumerated()), id: \.offset) { index, coord in
                Annotation("Stop \(index + 1)", coordinate: coord) {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
        }
    }
}

#Preview {
    RouteMapView(routeResult: RouteResult(
        optimizedOrder: [0, 1],
        polylineCoordinates: [
            .init(latitude: -33.8688, longitude: 151.2093),
            .init(latitude: -33.8708, longitude: 151.2073)
        ],
        stopCoordinates: [
            .init(latitude: -33.8688, longitude: 151.2093),
            .init(latitude: -33.8708, longitude: 151.2073)
        ],
        totalDistance: "5.2 km",
        totalDuration: "12 min",
        legs: [RouteLeg(distance: "5.2 km", duration: "12 min")]
    ))
    .frame(height: 300)
}
