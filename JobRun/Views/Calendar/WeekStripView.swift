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
        VStack(spacing: 8) {
            HStack {
                Button { changeWeek(by: -1) } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(weekRangeText)
                    .font(.headline)
                Spacer()
                Button { changeWeek(by: 1) } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)

            HStack(spacing: 4) {
                ForEach(weekDates, id: \.self) { date in
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)

                    VStack(spacing: 4) {
                        Text(date, format: .dateTime.weekday(.abbreviated))
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text("\(calendar.component(.day, from: date))")
                            .font(.system(.callout, weight: calendar.isDateInToday(date) ? .bold : .regular))
                            .foregroundStyle(isSelected ? .white : .primary)

                        if jobStore.hasJobs(on: date) {
                            Circle()
                                .fill(isSelected ? .white : .blue)
                                .frame(width: 4, height: 4)
                        } else {
                            Circle().fill(.clear).frame(width: 4, height: 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(isSelected ? Color.blue : Color.clear)
                    )
                    .onTapGesture { selectedDate = date }
                }
            }
            .padding(.horizontal)
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
