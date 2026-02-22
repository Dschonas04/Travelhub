import SwiftUI
import SwiftData

struct TripMenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let destination: TripMenuDestination
}

enum TripMenuDestination {
    case ideensammlung
    case packliste
    case hotel
    case fotos
    case budget
    case tipps
    case chat
    case absprachen
    case gruppe
}

struct TripDetailView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss

    let menuItems: [TripMenuItem] = [
        TripMenuItem(title: "Gruppenverwaltung", icon: "person.3.fill", color: .indigo, destination: .gruppe),
        TripMenuItem(title: "Chat", icon: "bubble.left.and.bubble.right.fill", color: .blue, destination: .chat),
        TripMenuItem(title: "Absprachen", icon: "checkmark.seal.fill", color: .teal, destination: .absprachen),
        TripMenuItem(title: "Ideensammlung & Abstimmung", icon: "hand.thumbsup.fill", color: .orange, destination: .ideensammlung),
        TripMenuItem(title: "Budgetplanung", icon: "banknote.fill", color: .mint, destination: .budget),
        TripMenuItem(title: "Packliste", icon: "checklist", color: .green, destination: .packliste),
        TripMenuItem(title: "Hotel", icon: "building.2.fill", color: .purple, destination: .hotel),
        TripMenuItem(title: "Fotos teilen", icon: "photo.on.rectangle.angled", color: .pink, destination: .fotos),
        TripMenuItem(title: "Tipps zum Reiseziel", icon: "lightbulb.fill", color: .yellow, destination: .tipps),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Trip Header
                ZStack {
                    LinearGradient(
                        colors: [.appPrimary, .appSecondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 160)

                    VStack(spacing: 10) {
                        Image(systemName: "airplane.departure")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text(trip.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(trip.destination)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.85))

                        HStack(spacing: 20) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .font(.caption)
                                Text(trip.startDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                            }
                            HStack(spacing: 6) {
                                Image(systemName: "person.2.fill")
                                    .font(.caption)
                                Text("\(trip.members.count) Teilnehmer")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.white.opacity(0.8))
                    }
                }

                // Menu Items
                VStack(spacing: 10) {
                    ForEach(menuItems) { item in
                        NavigationLink(destination: destinationView(for: item.destination)) {
                            HStack(spacing: 14) {
                                Image(systemName: item.icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                                    .frame(width: 40, height: 40)
                                    .background(item.color)
                                    .cornerRadius(10)

                                Text(item.title)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.appText)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .background(Color.appBackground)
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    func destinationView(for dest: TripMenuDestination) -> some View {
        switch dest {
        case .ideensammlung:
            VotingOverviewView(trip: trip)
        case .packliste:
            PacklisteView(trip: trip)
        case .hotel:
            HotelView(trip: trip)
        case .fotos:
            PhotoSharingView(trip: trip)
        case .budget:
            BudgetView(specificTrip: trip)
        case .tipps:
            TravelTipsView(trip: trip)
        case .chat:
            ChatView(trip: trip)
        case .absprachen:
            AgreementsView(trip: trip)
        case .gruppe:
            GroupManagementView(trip: trip)
        }
    }
}

#Preview {
    let trip = Trip(title: "Mallorca 06/2026", startDate: Date(), endDate: Date().addingTimeInterval(7*24*3600), destination: "Mallorca")
    NavigationStack {
        TripDetailView(trip: trip)
    }
}
