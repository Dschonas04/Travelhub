import SwiftUI

struct TripCardView: View {
    let trip: Trip

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return "\(trip.destination) \(formatter.string(from: trip.startDate))"
    }

    var body: some View {
        HStack(spacing: 14) {
            // Trip icon
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.appPrimary.opacity(0.7), .appSecondary.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: tripIcon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(trip.title)
                    .font(.headline)
                    .foregroundColor(.appText)
                    .lineLimit(1)

                Text(dateString)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if !trip.members.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption2)
                        Text("\(trip.members.count) Teilnehmer")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }

    var tripIcon: String {
        let dest = trip.destination.lowercased()
        if dest.contains("strand") || dest.contains("mallorca") || dest.contains("beach") {
            return "sun.max.fill"
        } else if dest.contains("berg") || dest.contains("anton") || dest.contains("ski") {
            return "mountain.2.fill"
        } else {
            return "airplane"
        }
    }
}
