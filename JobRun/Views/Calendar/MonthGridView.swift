//
//  MonthGridView.swift
//  JobRun
//
//  Created by NB on 28/4/2026.
//

import SwiftUI

struct MonthGridView: View {
    @Environment(JobStore.self) private var jobStore
    @Binding var selectedDate: Date

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    private var monthDates: [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingSpaces = (firstWeekday - calendar.firstWeekday + 7) % 7

        var dates: [Date?] = Array(repeating: nil, count: leadingSpaces)
        for day in range {
            dates.append(calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth))
        }

        return dates
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button { changeMonth(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(selectedDate, format: .dateTime.month(.wide).year())
                    .font(.headline)
                Spacer()
                Button { changeMonth(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                ForEach(Array(monthDates.enumerated()), id: \.offset) { _, date in
                    if let date {
                        DayCellView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            jobCount: jobStore.jobCount(on: date)
                        )
                        .onTapGesture { selectedDate = date }
                    } else {
                        Text("")
                            .frame(height: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: selectedDate) {
            withAnimation { selectedDate = newDate }
        }
    }
}

struct DayCellView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let jobCount: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(.body, weight: isToday ? .bold : .regular))
                .foregroundStyle(isSelected ? .white : isToday ? .blue : .primary)

            if jobCount > 0 {
                HStack(spacing: 2) {
                    ForEach(0 ..< min(jobCount, 3), id: \.self) { _ in
                        Circle()
                            .fill(isSelected ? .white : .blue)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue : Color.clear)
        )
    }
}

#Preview("Month Grid") {
    MonthGridView(selectedDate: .constant(.now))
        .environment(JobStore())
}

#Preview("Day Cell") {
    HStack {
        DayCellView(date: .now, isSelected: false, isToday: true, jobCount: 2)
        DayCellView(date: .now, isSelected: true, isToday: false, jobCount: 1)
        DayCellView(date: .now, isSelected: false, isToday: false, jobCount: 0)
    }
    .padding()
}
