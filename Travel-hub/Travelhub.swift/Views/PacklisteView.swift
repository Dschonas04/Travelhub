import SwiftUI

// MARK: - Categories
enum PackCategory: String, CaseIterable, Identifiable {
    case dokumente = "Dokumente"
    case kleidung = "Kleidung"
    case strand = "Strand"
    case gesundheit = "Gesundheit"
    case technik = "Technik"
    case sonstiges = "Sonstiges"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .dokumente: return "doc.text.fill"
        case .kleidung: return "tshirt.fill"
        case .strand: return "sun.max.fill"
        case .gesundheit: return "cross.case.fill"
        case .technik: return "bolt.fill"
        case .sonstiges: return "bag.fill"
        }
    }

    var color: Color {
        switch self {
        case .dokumente: return .blue
        case .kleidung: return .purple
        case .strand: return .budgetOrange
        case .gesundheit: return .budgetGreen
        case .technik: return .budgetBlue
        case .sonstiges: return .appPrimary
        }
    }
}

// MARK: - Model
struct PacklistItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var isChecked: Bool = false
    var category: PackCategory = .sonstiges
    var quantity: Int = 1
}

// MARK: - View
struct PacklisteView: View {
    let trip: Trip

    @State private var items: [PacklistItem] = [
        PacklistItem(name: "Reisepass/Personalausweis", category: .dokumente),
        PacklistItem(name: "Krankenkarte", category: .dokumente),
        PacklistItem(name: "Bargeld", category: .dokumente),
        PacklistItem(name: "Sonnencreme", category: .gesundheit),
        PacklistItem(name: "Badesachen", category: .strand),
        PacklistItem(name: "Strandtuch", category: .strand),
        PacklistItem(name: "FlipFlops", category: .kleidung),
        PacklistItem(name: "Sonnenbrille", category: .strand),
        PacklistItem(name: "Ladegeräte", category: .technik),
    ]

    @State private var newItemName = ""
    @State private var newItemCategory: PackCategory = .sonstiges
    @State private var newItemQuantity: Int = 1
    @State private var showAddItem = false
    @State private var selectedCategory: PackCategory? = nil
    @State private var sortUncheckedFirst = true

    // MARK: - Smart Suggestions
    var tripDays: Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: trip.startDate)
        let end = cal.startOfDay(for: trip.endDate)
        let comps = cal.dateComponents([.day], from: start, to: end)
        return max((comps.day ?? 0) + 1, 1)
    }

    var destinationHints: [PacklistItem] {
        let dest = trip.destination.lowercased()
        var result: [PacklistItem] = []

        // Strand/Meer
        if dest.contains("strand") || dest.contains("beach") || dest.contains("mallorca") || dest.contains("ibiza") {
            result += [
                PacklistItem(name: "After Sun", category: .gesundheit),
                PacklistItem(name: "Wasserfeste Handyhülle", category: .technik),
                PacklistItem(name: "Hut/Kappe", category: .kleidung),
            ]
        }
        // Berge/Ski/Wandern
        if dest.contains("berg") || dest.contains("ski") || dest.contains("anton") {
            result += [
                PacklistItem(name: "Wanderschuhe", category: .kleidung),
                PacklistItem(name: "Regenjacke", category: .kleidung),
                PacklistItem(name: "Mütze", category: .kleidung),
            ]
        }
        // Stadt
        if dest.contains("barcelona") || dest.contains("paris") || dest.contains("berlin") || dest.contains("stadt") {
            result += [
                PacklistItem(name: "Bequeme Schuhe", category: .kleidung),
                PacklistItem(name: "Powerbank", category: .technik),
                PacklistItem(name: "ÖPNV-/City-Karte", category: .dokumente),
            ]
        }

        // Dauer-basierte Hinweise
        result += [
            PacklistItem(name: "Unterwäsche", category: .kleidung, quantity: max(tripDays, 1)),
            PacklistItem(name: "Socken", category: .kleidung, quantity: max(tripDays, 1)),
            PacklistItem(name: "T-Shirts", category: .kleidung, quantity: max(tripDays - 1, 1)),
        ]

        // Basis
        result += [
            PacklistItem(name: "Zahnbürste & Zahnpasta", category: .gesundheit),
            PacklistItem(name: "Duschgel/Shampoo (Reisegröße)", category: .gesundheit),
            PacklistItem(name: "Adapter/Steckdosenleiste", category: .technik),
        ]

        // Filter bereits vorhandene Items
        let existing = Set(items.map { $0.name.lowercased() })
        return result.filter { !existing.contains($0.name.lowercased()) }
    }

    // MARK: - Derived
    var progress: Double {
        guard !items.isEmpty else { return 0 }
        let checked = items.filter { $0.isChecked }.count
        return Double(checked) / Double(items.count)
    }

    var filteredItems: [PacklistItem] {
        let base = selectedCategory == nil ? items : items.filter { $0.category == selectedCategory }
        if sortUncheckedFirst {
            return base.sorted { ($0.isChecked ? 1 : 0, $0.name) < ($1.isChecked ? 1 : 0, $1.name) }
        } else {
            return base.sorted { $0.name < $1.name }
        }
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    // Progress
                    progressHeader

                    // Category filter pills
                    categoryFilterPills

                    // Smart suggestions
                    if !destinationHints.isEmpty {
                        smartSuggestions
                    }

                    // Items
                    VStack(spacing: 8) {
                        ForEach(filteredItems, id: \.id) { item in
                            packRow(item)
                        }

                        // Add item button
                        Button(action: { showAddItem = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("weiteres Item hinzufügen")
                            }
                            .font(.subheadline)
                            .foregroundColor(.appPrimary)
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Packliste")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Menu {
                    Button("Offene zuerst sortieren: \(sortUncheckedFirst ? "An" : "Aus")") {
                        withAnimation { sortUncheckedFirst.toggle() }
                    }
                    Button("Alle abhaken") { withAnimation { items.indices.forEach { items[$0].isChecked = true } } }
                    Button("Alle zurücksetzen") { withAnimation { items.indices.forEach { items[$0].isChecked = false } } }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .alert("Neues Item", isPresented: $showAddItem) {
            TextField("Bezeichnung", text: $newItemName)
            Picker("Kategorie", selection: $newItemCategory) {
                ForEach(PackCategory.allCases) { cat in
                    Text(cat.rawValue).tag(cat)
                }
            }
            Stepper("Menge: \(newItemQuantity)", value: $newItemQuantity, in: 1...20)
            Button("Hinzufügen") {
                addItem(name: newItemName, category: newItemCategory, quantity: newItemQuantity)
                resetNewItem()
            }
            Button("Abbrechen", role: .cancel) {
                resetNewItem()
            }
        }
    }

    // MARK: - Subviews
    var progressHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Fortschritt")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("\(items.filter { $0.isChecked }.count)/\(items.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray6))
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.appPrimary)
                        .frame(width: geo.size.width * progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    var categoryFilterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                pill(title: "Alle", icon: "line.3.horizontal.decrease.circle", isSelected: selectedCategory == nil) {
                    withAnimation { selectedCategory = nil }
                }
                ForEach(PackCategory.allCases) { cat in
                    pill(title: cat.rawValue, icon: cat.icon, color: cat.color, isSelected: selectedCategory == cat) {
                        withAnimation { selectedCategory = (selectedCategory == cat ? nil : cat) }
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }

    var smartSuggestions: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Empfehlungen für \(trip.destination)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Alle hinzufügen") { addAllSuggestions() }
                    .font(.caption)
                    .foregroundColor(.appPrimary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(destinationHints, id: \.self) { hint in
                        Button(action: { addSuggestion(hint) }) {
                            HStack(spacing: 6) {
                                Image(systemName: hint.category.icon)
                                    .font(.caption)
                                Text(hint.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(hint.category.color.opacity(0.12))
                            .foregroundColor(hint.category.color)
                            .cornerRadius(12)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    func pill(title: String, icon: String, color: Color = .appPrimary, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : Color.white.opacity(0.9))
            .foregroundColor(isSelected ? .white : .appText)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }

    func packRow(_ item: PacklistItem) -> some View {
        HStack(spacing: 14) {
            Button(action: { toggle(item) }) {
                Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(item.isChecked ? .appPrimary : .gray)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(item.name)
                        .font(.body)
                        .strikethrough(item.isChecked, color: .gray)
                        .foregroundColor(item.isChecked ? .gray : .appText)
                    if item.quantity > 1 {
                        Text("x\(item.quantity)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.appPrimary.opacity(0.1))
                            .foregroundColor(.appPrimary)
                            .cornerRadius(6)
                    }
                }
                Text(item.category.rawValue)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }

            Spacer()

            // Category chip
            Text(item.category.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(item.category.color.opacity(0.12))
                .foregroundColor(item.category.color)
                .cornerRadius(8)
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.03), radius: 3, x: 0, y: 1)
        .contextMenu {
            Button("Menge +1") { increment(item) }
            Button("Menge -1") { decrement(item) }
            Divider()
            Button(role: .destructive) { remove(item) } label: {
                Label("Löschen", systemImage: "trash")
            }
        }
    }

    // MARK: - Actions
    func toggle(_ item: PacklistItem) {
        if let idx = items.firstIndex(of: item) {
            items[idx].isChecked.toggle()
        }
    }

    func increment(_ item: PacklistItem) {
        if let idx = items.firstIndex(of: item) {
            items[idx].quantity += 1
        }
    }

    func decrement(_ item: PacklistItem) {
        if let idx = items.firstIndex(of: item), items[idx].quantity > 1 {
            items[idx].quantity -= 1
        }
    }

    func remove(_ item: PacklistItem) {
        items.removeAll { $0.id == item.id }
    }

    func addItem(name: String, category: PackCategory, quantity: Int) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if let idx = items.firstIndex(where: { $0.name.caseInsensitiveCompare(trimmed) == .orderedSame }) {
            items[idx].quantity = max(items[idx].quantity, quantity)
        } else {
            items.append(PacklistItem(name: trimmed, category: category, quantity: quantity))
        }
    }

    func resetNewItem() {
        newItemName = ""
        newItemCategory = .sonstiges
        newItemQuantity = 1
    }

    func addSuggestion(_ hint: PacklistItem) {
        addItem(name: hint.name, category: hint.category, quantity: hint.quantity)
    }

    func addAllSuggestions() {
        destinationHints.forEach { addSuggestion($0) }
    }
}

#Preview {
    let trip = Trip(title: "Mallorca", startDate: Date(), endDate: Date().addingTimeInterval(5 * 24 * 3600), destination: "Mallorca Strand")
    NavigationStack {
        PacklisteView(trip: trip)
    }
}
