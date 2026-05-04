//
//  WeekStripView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct WeekStripView: View {
    @Environment(JobStore.self) private var jobStore
    @Binding var selectedDate: Date

    private let calendar = Calendar.current

    private var weekDates: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return [] }
        return (0 ..< 7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekInterval.start) }
    }

    var body: some View {
        VStack(spacing: 0) {
            weekNavHeader
            dayStrip
                .padding(.bottom, 16)
        }
    }

    private var weekNavHeader: some View {
        HStack {
            Button { changeWeek(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
            }
            Spacer()
            Text(weekRangeText)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            Spacer()
            Button { changeWeek(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }

    private var dayStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                    let isToday = calendar.isDateInToday(date)

                    Button {
                        withAnimation(.spring(response: 0.25)) { selectedDate = date }
                    } label: {
                        VStack(spacing: 6) {
                            Text(date, format: .dateTime.weekday(.abbreviated))
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(isSelected ? Color.white.opacity(0.9) : Color.secondary)
                                .textCase(.uppercase)

                            Text("\(calendar.component(.day, from: date))")
                                .font(.system(size: 22, weight: isToday || isSelected ? .heavy : .regular))
                                .foregroundStyle(isSelected ? Color.white : Color.primary)

                            Circle()
                                .fill(
                                    isSelected
                                        ? Color.white.opacity(0.6)
                                        : (jobStore.hasJobs(on: date) ? Color.green : Color.clear)
                                )
                                .frame(width: 5, height: 5)
                        }
                        .frame(width: 44, height: 72)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isSelected ? Color.green : Color.white)
                            if !isSelected {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray5), lineWidth: 1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var weekRangeText: String {
        guard let first = weekDates.first, let last = weekDates.last else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return "\(formatter.string(from: first)) – \(formatter.string(from: last))"
    }

    private func changeWeek(by value: Int) {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: selectedDate) {
            withAnimation { selectedDate = newDate }
        }
    }
}
