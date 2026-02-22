import SwiftUI

struct PacklistItem: Identifiable {
    let id = UUID()
    var name: String
    var isChecked: Bool = false
}

struct PacklisteView: View {
    let trip: Trip
    @State private var items: [PacklistItem] = [
        PacklistItem(name: "Strandtuch"),
        PacklistItem(name: "Luftmatratze"),
        PacklistItem(name: "Sonnencreme"),
        PacklistItem(name: "Autan"),
        PacklistItem(name: "Badesachen"),
        PacklistItem(name: "FlipFlops"),
        PacklistItem(name: "Gesellschaftsspiele"),
        PacklistItem(name: "Bargeld"),
        PacklistItem(name: "Sonnenbrille"),
    ]
    @State private var newItemName = ""
    @State private var showAddItem = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach($items) { $item in
                        HStack(spacing: 14) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    item.isChecked.toggle()
                                }
                            }) {
                                Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                    .font(.title3)
                                    .foregroundColor(item.isChecked ? .appPrimary : .gray)
                            }

                            Text(item.name)
                                .font(.body)
                                .strikethrough(item.isChecked, color: .gray)
                                .foregroundColor(item.isChecked ? .gray : .appText)

                            Spacer()
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
                    }

                    // Add item button
                    Button(action: { showAddItem = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("weiteres Item hinzufuegen")
                        }
                        .font(.subheadline)
                        .foregroundColor(.appPrimary)
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Packliste")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Neues Item", isPresented: $showAddItem) {
            TextField("Bezeichnung", text: $newItemName)
            Button("Hinzufuegen") {
                if !newItemName.isEmpty {
                    items.append(PacklistItem(name: newItemName))
                    newItemName = ""
                }
            }
            Button("Abbrechen", role: .cancel) {
                newItemName = ""
            }
        }
    }
}

#Preview {
    let trip = Trip(title: "Mallorca", startDate: Date(), endDate: Date(), destination: "Mallorca")
    NavigationStack {
        PacklisteView(trip: trip)
    }
}
