import SwiftUI
import SwiftData

struct CreateTripView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(7 * 24 * 3600)
    @State private var budget = ""
    @State private var description = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Reisedetails") {
                    TextField("Reisename", text: $title)
                    TextField("Reiseziel", text: $destination)
                    TextField("Beschreibung", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("Zeitraum") {
                    DatePicker("Startdatum", selection: $startDate, displayedComponents: .date)
                    DatePicker("Enddatum", selection: $endDate, displayedComponents: .date)
                }

                Section("Budget") {
                    HStack {
                        Text("\u{20AC}")
                        TextField("Betrag", text: $budget)
                            .keyboardType(.decimalPad)
                    }
                }

                Section {
                    Button(action: createTrip) {
                        Text("Reise erstellen")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.appPrimary)
                    }
                    .disabled(title.isEmpty || destination.isEmpty)
                }
            }
            .navigationTitle("Neue Reise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func createTrip() {
        let trip = Trip(
            title: title,
            startDate: startDate,
            endDate: endDate,
            destination: destination
        )
        trip.tripDescription = description
        trip.budget = Double(budget) ?? 0
        trip.organizer = "Max Mustermann"
        trip.members = ["Max Mustermann"]
        modelContext.insert(trip)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    CreateTripView()
        .modelContainer(for: Trip.self, inMemory: true)
}
