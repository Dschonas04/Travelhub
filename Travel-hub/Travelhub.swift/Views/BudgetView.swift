import SwiftUI
import SwiftData

struct BudgetView: View {
    var specificTrip: Trip? = nil
    @Query var expenses: [BudgetExpense]
    @Query var trips: [Trip]
    @Query var members: [TripMember]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTripId: String?
    @State private var showAddExpense = false
    @State private var selectedTab = 0

    var currentTrip: Trip? {
        if let specificTrip { return specificTrip }
        guard let selectedTripId else { return trips.first }
        return trips.first { $0.id == selectedTripId }
    }

    var currentTripId: String? {
        currentTrip?.id
    }

    var tripExpenses: [BudgetExpense] {
        guard let id = currentTripId else { return [] }
        return expenses.filter { $0.tripId == id }.sorted { $0.date > $1.date }
    }

    var tripMembers: [TripMember] {
        guard let id = currentTripId else { return [] }
        return members.filter { $0.tripId == id && $0.isActive }
    }

    var totalSpent: Double {
        tripExpenses.reduce(0) { $0 + $1.amount }
    }

    var budget: Double {
        currentTrip?.budget ?? 0
    }

    // Category breakdown
    var categoryBreakdown: [(String, String, Double, Color)] {
        let cats = BudgetCategoryStyle.ordered
        return cats.compactMap { item in
            let amount = tripExpenses.filter { $0.category == item.key }.reduce(0) { $0 + $1.amount }
            return amount > 0 ? (item.key, item.label, amount, item.color) : nil
        }
    }

    // Per person
    var perPersonSpending: [(String, Double)] {
        var spending: [String: Double] = [:]
        for e in tripExpenses { spending[e.paidBy, default: 0] += e.amount }
        return spending.sorted { $0.value > $1.value }.map { ($0.key, $0.value) }
    }

    // Settlement calculation
    var settlements: [(String, String, Double)] {
        var balances: [String: Double] = [:]
        for expense in tripExpenses {
            let people = expense.splitWith.isEmpty ? [expense.paidBy] : expense.splitWith
            let share = expense.amount / Double(max(people.count, 1))
            balances[expense.paidBy, default: 0] += expense.amount
            for person in people {
                balances[person, default: 0] -= share
            }
        }

        var debtors = balances.filter { $0.value < -0.01 }.map { ($0.key, -$0.value) }.sorted { $0.1 > $1.1 }
        var creditors = balances.filter { $0.value > 0.01 }.map { ($0.key, $0.value) }.sorted { $0.1 > $1.1 }
        var result: [(String, String, Double)] = []
        var i = 0, j = 0
        while i < debtors.count && j < creditors.count {
            let amount = min(debtors[i].1, creditors[j].1)
            if amount > 0.01 {
                result.append((debtors[i].0, creditors[j].0, amount))
            }
            debtors[i].1 -= amount
            creditors[j].1 -= amount
            if debtors[i].1 < 0.01 { i += 1 }
            if creditors[j].1 < 0.01 { j += 1 }
        }
        return result
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Trip picker (only when standalone)
                if specificTrip == nil && trips.count > 1 {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(trips, id: \.id) { trip in
                                Button(action: { selectedTripId = trip.id }) {
                                    Text(trip.title)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .padding(.horizontal, 14)
                                        .padding(.vertical, 8)
                                        .background(currentTripId == trip.id ? Color.appPrimary : Color(.systemGray6))
                                        .foregroundColor(currentTripId == trip.id ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }

                if currentTrip == nil {
                    VStack(spacing: 12) {
                        Image(systemName: "banknote.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("Wähle eine Reise")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Tab selector
                    HStack(spacing: 0) {
                        ForEach(["Übersicht", "Ausgaben", "Ausgleich"].indices, id: \.self) { index in
                            let titles = ["Übersicht", "Ausgaben", "Ausgleich"]
                            Button(action: { withAnimation { selectedTab = index } }) {
                                VStack(spacing: 6) {
                                    Text(titles[index])
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(selectedTab == index ? .appPrimary : .gray)
                                    Rectangle()
                                        .fill(selectedTab == index ? Color.appPrimary : Color.clear)
                                        .frame(height: 2)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal)

                    TabView(selection: $selectedTab) {
                        overviewTab.tag(0)
                        expensesTab.tag(1)
                        settlementTab.tag(2)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                }
            }
            .navigationTitle("Budgetplanung")
            .toolbar {
                if currentTrip != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddExpense = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddExpense) {
                if let trip = currentTrip {
                    AddExpenseView(trip: trip, members: tripMembers)
                }
            }
        }
    }

    // MARK: - Overview Tab
    var overviewTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Summary cards
                HStack(spacing: 12) {
                    BudgetCard(title: "Gesamtbudget", amount: budget, color: .appPrimary, icon: "banknote.fill")
                    BudgetCard(title: "Ausgegeben", amount: totalSpent, color: .orange, icon: "cart.fill")
                }
                HStack(spacing: 12) {
                    BudgetCard(title: "Verbleibend", amount: max(budget - totalSpent, 0), color: totalSpent > budget ? .red : .green, icon: "wallet.bifold.fill")
                    BudgetCard(title: "Ausgaben", amount: Double(tripExpenses.count), color: .purple, icon: "list.bullet", isCount: true)
                }

                // Budget progress
                if budget > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Budgetauslastung")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(Int(min(totalSpent / budget * 100, 999)))%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(totalSpent > budget ? .red : .appPrimary)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(.systemGray6))
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(totalSpent > budget ? Color.red : Color.appPrimary)
                                    .frame(width: geo.size.width * min(totalSpent / max(budget, 1), 1.0))
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }

                // Category chart
                if !categoryBreakdown.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Kategorien")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ForEach(categoryBreakdown, id: \.0) { _, label, amount, color in
                            HStack(spacing: 10) {
                                Text(label)
                                    .font(.caption)
                                    .frame(width: 80, alignment: .leading)

                                GeometryReader { geo in
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(color)
                                        .drawingGroup(opaque: false, colorMode: .linear)
                                        .frame(width: geo.size.width * (amount / max(totalSpent, 1)))
                                }
                                .frame(height: 14)

                                Text("\u{20AC}\(amount, specifier: "%.0f")")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .frame(width: 50, alignment: .trailing)
                            }
                        }
                    }
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }

                // Per person
                if !perPersonSpending.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pro Person bezahlt")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ForEach(perPersonSpending, id: \.0) { name, amount in
                            HStack(spacing: 10) {
                                UserAvatarView(name: name, size: 32)
                                Text(name)
                                    .font(.subheadline)
                                Spacer()
                                Text("\u{20AC}\(amount, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }

    // MARK: - Expenses Tab
    var expensesTab: some View {
        ScrollView {
            if tripExpenses.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.gray.opacity(0.3))
                    Text("Keine Ausgaben")
                        .font(.headline)
                    Text("Füge deine erste Ausgabe hinzu")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(tripExpenses, id: \.id) { expense in
                        EnhancedExpenseRow(expense: expense) {
                            modelContext.delete(expense)
                            try? modelContext.save()
                        }
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Settlement Tab
    var settlementTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                if settlements.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.green.opacity(0.5))
                        Text("Alles ausgeglichen!")
                            .font(.headline)
                        Text("Es gibt keine offenen Schulden")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Schuldenausgleich")
                            .font(.headline)
                        Text("Folgende Zahlungen sind nötig:")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(settlements.indices, id: \.self) { idx in
                        let s = settlements[idx]
                        HStack(spacing: 12) {
                            UserAvatarView(name: s.0, size: 40)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(s.0)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                HStack(spacing: 4) {
                                    Text("zahlt an")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(s.1)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                            }

                            Spacer()

                            Text("\u{20AC}\(s.2, specifier: "%.2f")")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .background(Color.appCardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                    }

                    // Per person balance
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Einzelne Bilanzen")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        ForEach(perPersonSpending, id: \.0) { name, paid in
                            let fairShare = totalSpent / Double(max(perPersonSpending.count, 1))
                            let balance = paid - fairShare
                            HStack {
                                UserAvatarView(name: name, size: 28)
                                Text(name)
                                    .font(.caption)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("\u{20AC}\(paid, specifier: "%.2f") bezahlt")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                    Text(balance >= 0 ? "+\u{20AC}\(balance, specifier: "%.2f")" : "-\u{20AC}\(abs(balance), specifier: "%.2f")")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(balance >= 0 ? .green : .red)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
    }
}

// MARK: - Budget Card
struct BudgetCard: View {
    let title: String
    let amount: Double
    let color: Color
    let icon: String
    var isCount: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(color)
                Spacer()
            }
            Text(isCount ? "\(Int(amount))" : "\u{20AC}\(amount, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Enhanced Expense Row
struct EnhancedExpenseRow: View {
    let expense: BudgetExpense
    let onDelete: () -> Void

    var categoryColor: Color { BudgetCategoryStyle.color(for: expense.category) }
    var categoryIcon: String { BudgetCategoryStyle.icon(for: expense.category) }
    var categoryLabel: String { BudgetCategoryStyle.label(for: expense.category) }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: categoryIcon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(categoryColor)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 3) {
                Text(expense.expenseDescription)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack(spacing: 8) {
                    Text("Bezahlt von \(expense.paidBy)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    if !expense.splitWith.isEmpty {
                        Text("\u{00F7} \(expense.splitWith.count)")
                            .font(.caption2)
                            .foregroundColor(categoryColor)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(categoryColor.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\u{20AC}\(expense.amount, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .contextMenu {
            Button(role: .destructive, action: onDelete) {
                Label("Löschen", systemImage: "trash")
            }
        }
    }
}

// MARK: - Add Expense View (Enhanced)
struct AddExpenseView: View {
    let trip: Trip
    var members: [TripMember] = []
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var description_ = ""
    @State private var amount = ""
    @State private var category = "General"
    @State private var paidBy = "Du"
    @State private var splitMethod = "equal"
    @State private var splitMembers: Set<String> = []

    let categories = [
        ("Food", "Essen", "fork.knife"),
        ("Transport", "Transport", "car.fill"),
        ("Accommodation", "Unterkunft", "house.fill"),
        ("Activities", "Aktivitäten", "star.fill"),
        ("General", "Sonstiges", "creditcard.fill")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Ausgabe") {
                    TextField("Beschreibung", text: $description_)
                    HStack {
                        Text("\u{20AC}")
                            .fontWeight(.semibold)
                        TextField("Betrag", text: $amount)
                            .keyboardType(.decimalPad)
                    }
                }

                Section("Kategorie") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 8) {
                        ForEach(categories, id: \.0) { key, label, icon in
                            Button(action: { category = key }) {
                                VStack(spacing: 4) {
                                    Image(systemName: icon)
                                        .font(.system(size: 18))
                                    Text(label)
                                        .font(.caption2)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(category == key ? Color.appPrimary : Color(.systemGray6))
                                .foregroundColor(category == key ? .white : .primary)
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Bezahlt von") {
                    TextField("Name", text: $paidBy)
                }

                Section("Aufteilen") {
                    Picker("Methode", selection: $splitMethod) {
                        Text("Gleichmäßig").tag("equal")
                        Text("Benutzerdefiniert").tag("custom")
                    }
                    .pickerStyle(.segmented)

                    if !members.isEmpty {
                        ForEach(members, id: \.id) { member in
                            HStack {
                                Text(member.userName)
                                Spacer()
                                if splitMembers.contains(member.userName) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.appPrimary)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if splitMembers.contains(member.userName) {
                                    splitMembers.remove(member.userName)
                                } else {
                                    splitMembers.insert(member.userName)
                                }
                            }
                        }
                    }
                }

                Section {
                    Button(action: addExpense) {
                        HStack {
                            Spacer()
                            Text("Ausgabe hinzufügen")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(description_.isEmpty || amount.isEmpty ? Color.gray.opacity(0.5) : Color.appPrimary)
                    .disabled(description_.isEmpty || amount.isEmpty)
                }
            }
            .navigationTitle("Neue Ausgabe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func addExpense() {
        let expense = BudgetExpense(
            tripId: trip.id,
            expenseDescription: description_,
            amount: Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0,
            paidBy: paidBy,
            category: category,
            splitWith: Array(splitMembers)
        )
        modelContext.insert(expense)
        try? modelContext.save()
        dismiss()
    }
}

