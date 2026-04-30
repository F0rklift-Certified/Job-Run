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
