//
//  JobCardView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct JobCardView: View {
    let job: Job

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: job.status.icon)
                .foregroundStyle(job.status.color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(job.clientName)
                    .font(.headline)

                Text(job.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack {
                    Text(job.status.label)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(job.status.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(job.status.color.opacity(0.15), in: Capsule())
                }
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        JobCardView(job: Job(clientName: "John Smith", address: "123 Main St, Sydney NSW", date: .now))
        JobCardView(job: Job(clientName: "Jane Doe", address: "456 George St, Sydney NSW", date: .now, status: .complete))
        JobCardView(job: Job(clientName: "Bob Wilson", address: "789 Pitt St, Sydney NSW", date: .now, status: .cancelled))
    }
}
