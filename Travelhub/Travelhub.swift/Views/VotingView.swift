import SwiftUI
import SwiftData

// MARK: - Activity model for voting
struct VotingActivity: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var imageSystemName: String
    var ratings: [String: Int] // userName -> rating (1-5)
    
    var averageRating: Double {
        guard !ratings.isEmpty else { return 0 }
        return Double(ratings.values.reduce(0, +)) / Double(ratings.count)
    }
}

// MARK: - Voting Overview (Ideensammlung & Abstimmung)
struct VotingOverviewView: View {
    let trip: Trip
    @State private var activities: [VotingActivity] = [
        VotingActivity(name: "Drachenhoehlen", description: "Besuch der beruhmten Drachenhoehlen", imageSystemName: "mountain.2.fill",
                       ratings: ["Lars": 2, "Tim": 4, "Sophie": 2, "Anna": 4, "Max": 3]),
        VotingActivity(name: "Strandtag", description: "Entspannter Tag am Strand", imageSystemName: "sun.max.fill",
                       ratings: ["Lars": 5, "Tim": 4, "Sophie": 5, "Anna": 4, "Max": 5]),
        VotingActivity(name: "Sightseeing Palma", description: "Stadtbesichtigung Palma de Mallorca", imageSystemName: "building.columns.fill",
                       ratings: ["Lars": 3, "Tim": 3, "Sophie": 4, "Anna": 2, "Max": 3]),
        VotingActivity(name: "Shopping", description: "Shopping Tour", imageSystemName: "bag.fill",
                       ratings: ["Lars": 2, "Tim": 1, "Sophie": 4, "Anna": 3, "Max": 2]),
        VotingActivity(name: "Boot mieten", description: "Boot mieten und die Kueste erkunden", imageSystemName: "sailboat.fill",
                       ratings: ["Lars": 4, "Tim": 3, "Sophie": 3, "Anna": 4, "Max": 3]),
    ]
    @State private var showAddActivity = false
    @State private var selectedActivityForVoting: VotingActivity?
    @State private var selectedActivityForResult: VotingActivity?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Eigene Abstimmungen Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Eigene Abstimmungen")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    Text("Aktivitaeten")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    ForEach(activities) { activity in
                        Button(action: { selectedActivityForVoting = activity }) {
                            HStack {
                                Image(systemName: activity.imageSystemName)
                                    .font(.system(size: 20))
                                    .foregroundColor(.appPrimary)
                                    .frame(width: 36, height: 36)
                                    .background(Color.appPrimary.opacity(0.1))
                                    .cornerRadius(8)

                                Text(activity.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.appText)

                                Spacer()

                                StaticStarRatingView(rating: activity.averageRating, size: 14)

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
                        .padding(.horizontal)
                    }

                    Button(action: { showAddActivity = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("weitere Abstimmung hinzufuegen")
                        }
                        .font(.subheadline)
                        .foregroundColor(.appPrimary)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }

                Divider()
                    .padding(.horizontal)

                // Auswertungen Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Auswertungen")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    Text("Aktivitaeten")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)

                    ForEach(activities.sorted(by: { $0.averageRating > $1.averageRating })) { activity in
                        Button(action: { selectedActivityForResult = activity }) {
                            HStack {
                                Text(activity.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.appText)

                                Spacer()

                                StaticStarRatingView(rating: activity.averageRating, size: 14)
                            }
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color.appBackground)
        .navigationTitle("Ideensammlung & Abstimmung")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddActivity) {
            AddActivityView { newActivity in
                activities.append(newActivity)
            }
        }
        .sheet(item: $selectedActivityForVoting) { activity in
            NavigationStack {
                VoteActivityView(activity: activity) { updatedActivity in
                    if let idx = activities.firstIndex(where: { $0.id == updatedActivity.id }) {
                        activities[idx] = updatedActivity
                    }
                }
            }
        }
        .sheet(item: $selectedActivityForResult) { activity in
            NavigationStack {
                ActivityResultView(activity: activity)
            }
        }
    }
}

// MARK: - Vote Activity View (Star Rating)
struct VoteActivityView: View {
    @State var activity: VotingActivity
    var onSave: (VotingActivity) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var myRating: Int = 0

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: activity.imageSystemName)
                .font(.system(size: 60))
                .foregroundColor(.appPrimary)

            Text(activity.name)
                .font(.title)
                .fontWeight(.bold)

            Text("Bitte gebe dein Voting fuer die \(activity.name) ab")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            StarRatingView(rating: $myRating, size: 40)
                .padding(.top, 8)

            Spacer()

            Button(action: {
                activity.ratings["Du"] = myRating
                onSave(activity)
                dismiss()
            }) {
                Text("Abstimmen")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(myRating > 0 ? Color.appPrimary : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(myRating == 0)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationTitle(activity.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Zurueck") { dismiss() }
            }
        }
    }
}

// MARK: - Activity Result View
struct ActivityResultView: View {
    let activity: VotingActivity
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: activity.imageSystemName)
                    .font(.system(size: 48))
                    .foregroundColor(.appPrimary)
                    .padding(.top, 20)

                Text(activity.name)
                    .font(.title2)
                    .fontWeight(.bold)

                // Individual ratings
                VStack(spacing: 12) {
                    ForEach(activity.ratings.sorted(by: { $0.key < $1.key }), id: \.key) { name, rating in
                        HStack {
                            UserAvatarView(name: name, size: 36)
                            Text(name)
                                .font(.body)
                                .fontWeight(.medium)
                            Spacer()
                            StaticStarRatingView(rating: Double(rating), size: 16)
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)

                // Gesamtergebnis
                VStack(spacing: 8) {
                    Text("Gesamtergebnis")
                        .font(.headline)
                    StaticStarRatingView(rating: activity.averageRating, size: 24)
                    Text(String(format: "%.1f / 5", activity.averageRating))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.appPrimary)
                }
                .padding()
                .background(Color.appPrimary.opacity(0.1))
                .cornerRadius(14)
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(Color.appBackground)
        .navigationTitle("Auswertung")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Zurueck") { dismiss() }
            }
        }
    }
}

// MARK: - Add Activity View
struct AddActivityView: View {
    var onAdd: (VotingActivity) -> Void
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Weitere Abstimmung hinzufuegen")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Bezeichnung")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Bezeichnung", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Beschreibung")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("Beschreibung", text: $description, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    // Foto placeholder
                    VStack {
                        Text("Foto hinzufuegen")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 40))
                            .foregroundColor(.gray.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 24)

                Spacer()

                HStack(spacing: 12) {
                    Button("Abbrechen") { dismiss() }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.appText)
                        .cornerRadius(12)

                    Button("Hinzufuegen") {
                        let activity = VotingActivity(
                            name: name,
                            description: description,
                            imageSystemName: "star.fill",
                            ratings: [:]
                        )
                        onAdd(activity)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(name.isEmpty ? Color.gray : Color.appPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .disabled(name.isEmpty)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }
}

// Keep compatibility for the old VotingView used in old MainTabView
struct VotingView: View {
    @Query var trips: [Trip]

    var body: some View {
        NavigationStack {
            if let trip = trips.first(where: { $0.isActive }) {
                VotingOverviewView(trip: trip)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "hand.raised.circle")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("Keine aktive Reise")
                        .font(.headline)
                    Text("Erstelle eine Reise, um Abstimmungen zu starten")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

// MARK: - PollVotes compatibility
extension PollVotes {
    func voters(for option: String) -> [String]? { map[option] }
    var totalCount: Int { map.values.reduce(0) { $0 + $1.count } }
}

#Preview {
    let trip = Trip(title: "Mallorca 06/2026", startDate: Date(), endDate: Date().addingTimeInterval(7*24*3600), destination: "Mallorca")
    NavigationStack {
        VotingOverviewView(trip: trip)
    }
}

