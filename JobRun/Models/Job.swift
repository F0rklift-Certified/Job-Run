import Foundation
import SwiftUI

enum JobStatus: String, Codable, CaseIterable, Identifiable {
    case pending
    case complete
    case cancelled

    var id: String { rawValue }

    var label: String {
        switch self {
        case .pending: "Pending"
        case .complete: "Complete"
        case .cancelled: "Cancelled"
        }
    }

    var color: Color {
        switch self {
        case .pending: .orange
        case .complete: .green
        case .cancelled: .red
        }
    }

    var icon: String {
        switch self {
        case .pending: "clock"
        case .complete: "checkmark.circle.fill"
        case .cancelled: "xmark.circle.fill"
        }
    }
}

struct Job: Identifiable, Codable, Equatable {
    let id: UUID
    var clientName: String
    var address: String
    var date: Date
    var notes: String
    var status: JobStatus

    init(
        id: UUID = UUID(),
        clientName: String,
        address: String,
        date: Date,
        notes: String = "",
        status: JobStatus = .pending
    ) {
        self.id = id
        self.clientName = clientName
        self.address = address
        self.date = date
        self.notes = notes
        self.status = status
    }
}
