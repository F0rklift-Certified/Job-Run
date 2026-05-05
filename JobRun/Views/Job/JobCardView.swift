//
//  JobCardView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct JobCardView: View {
    let job: Job

    private var statusBadgeBackground: Color {
        switch job.status {
        case .pending: Color.orange.opacity(0.1)
        case .complete: Color.green.opacity(0.1)
        case .cancelled: Color(.systemGray6)
        }
    }

    private var statusBadgeForeground: Color {
        switch job.status {
        case .pending: Color.orange
        case .complete: Color.green
        case .cancelled: Color(.systemGray)
        }
    }

    private var statusBadgeBorder: Color {
        switch job.status {
        case .pending: Color.orange.opacity(0.3)
        case .complete: Color.green.opacity(0.3)
        case .cancelled: Color(.systemGray4)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(job.status.label.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.5)
                    .foregroundStyle(statusBadgeForeground)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(statusBadgeBackground, in: RoundedRectangle(cornerRadius: 4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(statusBadgeBorder, lineWidth: 1)
                    )
                Spacer()
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray3))
                    .rotationEffect(.degrees(90))
            }

            Text(job.clientName)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(job.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}

#Preview {
    let jobs = MockDataService.generateJobs()
    List {
        JobCardView(job: jobs[0])
        JobCardView(job: jobs[2])
        JobCardView(job: jobs[7])
    }
}
