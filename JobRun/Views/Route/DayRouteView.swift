//
//  DayRouteView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct DayRouteView: View {
    @Environment(JobStore.self) private var jobStore
    @State private var routeVM = RouteViewModel()
    let date: Date

    private var dayJobs: [Job] {
        jobStore.jobs(for: date)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let result = routeVM.routeResult {
                    routeInfoCard(result)

                    RouteMapView(routeResult: result)
                        .frame(minWidth: 1, minHeight: 1)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)

                    openInMapsButton
                }

                if let error = routeVM.errorMessage {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.orange)
                        Text(error)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }

                stopsListSection
            }
            .padding(.vertical)
        }
        .navigationTitle(date.formatted(.dateTime.weekday(.wide).day().month(.abbreviated)))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if !dayJobs.isEmpty {
                await routeVM.calculateRoute(for: dayJobs)
            }
        }
        .overlay {
            if routeVM.isLoading {
                ZStack {
                    Color.black.opacity(0.1)
                    ProgressView("Calculating route...")
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private func routeInfoCard(_ result: RouteResult) -> some View {
        HStack(spacing: 20) {
            routeInfoItem(icon: "road.lanes", value: result.totalDistance, label: "Distance")

            Divider().frame(height: 50)

            routeInfoItem(icon: "clock", value: result.totalDuration, label: "Drive Time")

            Divider().frame(height: 50)

            routeInfoItem(icon: "mappin.and.ellipse", value: "\(dayJobs.count)", label: "Stops")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    private func routeInfoItem(icon: String, value: String, label: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var stopsListSection: some View {
        let displayJobs = routeVM.optimizedJobs(from: dayJobs)

        return VStack(alignment: .leading, spacing: 8) {
            Text(routeVM.routeResult != nil ? "Optimised Order" : "Jobs")
                .font(.headline)
                .padding(.horizontal)

            ForEach(Array(displayJobs.enumerated()), id: \.element.id) { index, job in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 28, height: 28)
                        Text("\(index + 1)")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(job.clientName)
                            .font(.subheadline.bold())
                        Text(job.address)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: job.status.icon)
                        .foregroundStyle(job.status.color)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)

                if index < displayJobs.count - 1 {
                    if let result = routeVM.routeResult, index < result.legs.count {
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(.blue.opacity(0.3))
                                .frame(width: 2, height: 20)
                                .padding(.leading, 13)

                            Text("\(result.legs[index].distance) · \(result.legs[index].duration)")
                                .font(.caption2)
                                .foregroundStyle(.blue)
                        }
                    } else {
                        HStack {
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(width: 2, height: 16)
                                .padding(.leading, 13)
                        }
                    }
                }
            }
        }
    }

    private var openInMapsButton: some View {
        Button {
            openInMaps()
        } label: {
            Label("Open Route in Maps", systemImage: "arrow.triangle.turn.up.right.diamond")
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.blue, in: RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }

    private func openInMaps() {
        let jobs = routeVM.optimizedJobs(from: dayJobs)
        let addresses = jobs.map {
            $0.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        }
        guard !addresses.isEmpty else { return }

        let home = RouteService.shared.homeAddress
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        var parts: [String] = []
        if !home.isEmpty { parts.append(home) }
        parts.append(contentsOf: addresses)
        if !home.isEmpty { parts.append(home) }

        let urlString = "https://www.google.com/maps/dir/" + parts.joined(separator: "/")
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    NavigationStack {
        DayRouteView(date: .now)
    }
    .environment(JobStore())
}
