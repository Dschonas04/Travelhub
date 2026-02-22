import SwiftUI
import SwiftData

struct TripsListView: View {
    @Query var trips: [Trip]
    @Environment(\.modelContext) private var modelContext
    @State private var showCreateTrip = false
    @State private var showJoinTrip = false
    @State private var searchText = ""
    @State private var selectedFilter = 0 // 0=Aktuelle, 1=Vergangene

    var filteredTrips: [Trip] {
        var result: [Trip]
        if selectedFilter == 0 {
            result = trips.filter { $0.isActive && $0.endDate >= Date() }
                .sorted { $0.startDate < $1.startDate }
        } else {
            result = trips.filter { !$0.isActive || $0.endDate < Date() }
                .sorted { $0.startDate > $1.startDate }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.destination.localizedCaseInsensitiveContains(searchText)
            }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Tabs
                HStack(spacing: 0) {
                    ForEach(Array(["Aktuelle Reisen", "Vergangene"].enumerated()), id: \.offset) { index, label in
                        Button(action: {
                            withAnimation { selectedFilter = index }
                        }) {
                            VStack(spacing: 6) {
                                Text(label)
                                    .font(.subheadline)
                                    .fontWeight(selectedFilter == index ? .semibold : .regular)
                                    .foregroundColor(selectedFilter == index ? .appPrimary : .gray)

                                Rectangle()
                                    .fill(selectedFilter == index ? Color.appPrimary : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Search Bar
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search...", text: $searchText)
                            .font(.subheadline)
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    Button("Go!") {}
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.vertical, 12)

                // Trips
                if filteredTrips.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "suitcase.rolling")
                            .font(.system(size: 56))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("Keine Reisen vorhanden")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Erstelle eine neue Reise oder tritt einer bei")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.7))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredTrips, id: \.id) { trip in
                                NavigationLink(destination: TripDetailView(trip: trip)) {
                                    TripCardView(trip: trip)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                }

                Spacer(minLength: 0)

                // Bottom action buttons
                VStack(spacing: 10) {
                    Button(action: { showCreateTrip = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Neue Reise anlegen")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }

                    Button(action: { showJoinTrip = true }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                            Text("Einer Reise beitreten")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.appPrimary)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle("Aktuelle Reisen")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showCreateTrip) {
                CreateTripView()
            }
            .alert("Reise beitreten", isPresented: $showJoinTrip) {
                TextField("Einladungscode", text: .constant(""))
                Button("Beitreten", role: .cancel) {}
                Button("Abbrechen", role: .destructive) {}
            } message: {
                Text("Gib den Einladungscode ein, um einer Reise beizutreten.")
            }
        }
    }
}

#Preview {
    TripsListView()
        .modelContainer(for: [Trip.self], inMemory: true)
}
