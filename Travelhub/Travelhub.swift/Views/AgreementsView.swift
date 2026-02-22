import SwiftUI
import SwiftData

struct AgreementsView: View {
    let trip: Trip
    @Query var agreements: [Agreement]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedFilter = "Alle"
    @State private var showCreateSheet = false

    let filters = ["Alle", "Offen", "Beschlossen", "Erledigt"]

    var tripAgreements: [Agreement] {
        let all = agreements.filter { $0.tripId == trip.id }
        switch selectedFilter {
        case "Offen": return all.filter { $0.status == "offen" || $0.status == "inAbstimmung" }
        case "Beschlossen": return all.filter { $0.status == "beschlossen" }
        case "Erledigt": return all.filter { $0.status == "erledigt" }
        default: return all
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Filters
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters, id: \.self) { filter in
                        let count = countFor(filter: filter)
                        Button(action: { withAnimation { selectedFilter = filter } }) {
                            HStack(spacing: 4) {
                                Text(filter)
                                if count > 0 && filter != "Alle" {
                                    Text("\(count)")
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedFilter == filter ? .appPrimary : .white)
                                        .frame(minWidth: 18, minHeight: 18)
                                        .background(selectedFilter == filter ? Color.white : Color.white.opacity(0.3))
                                        .cornerRadius(9)
                                }
                            }
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedFilter == filter ? Color.appPrimary : Color(.systemGray6))
                            .foregroundColor(selectedFilter == filter ? .white : .primary)
                            .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }

            if tripAgreements.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 56))
                        .foregroundColor(.appPrimary.opacity(0.3))
                    Text("Keine Absprachen")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Erstelle eine Absprache, um\nEntscheidungen gemeinsam zu treffen")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(tripAgreements, id: \.id) { agreement in
                            NavigationLink(destination: AgreementDetailView(agreement: agreement, trip: trip)) {
                                AgreementCardView(agreement: agreement)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Absprachen")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showCreateSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.appPrimary)
                }
            }
        }
        .sheet(isPresented: $showCreateSheet) {
            CreateAgreementView(trip: trip)
        }
    }

    func countFor(filter: String) -> Int {
        let all = agreements.filter { $0.tripId == trip.id }
        switch filter {
        case "Offen": return all.filter { $0.status == "offen" || $0.status == "inAbstimmung" }.count
        case "Beschlossen": return all.filter { $0.status == "beschlossen" }.count
        case "Erledigt": return all.filter { $0.status == "erledigt" }.count
        default: return all.count
        }
    }
}

// MARK: - Agreement Card
struct AgreementCardView: View {
    let agreement: Agreement

    var statusColor: Color {
        switch agreement.status {
        case "offen": return .blue
        case "inAbstimmung": return .orange
        case "beschlossen": return .green
        case "erledigt": return .gray
        default: return .red
        }
    }

    var statusLabel: String {
        switch agreement.status {
        case "offen": return "Offen"
        case "inAbstimmung": return "In Abstimmung"
        case "beschlossen": return "Beschlossen"
        case "erledigt": return "Erledigt"
        default: return agreement.status
        }
    }

    var categoryIcon: String {
        switch agreement.category {
        case "Unterkunft": return "building.2.fill"
        case "Transport": return "car.fill"
        case "Aktivitäten": return "figure.hiking"
        case "Essen": return "fork.knife"
        case "Budget": return "banknote.fill"
        default: return "doc.text.fill"
        }
    }

    var priorityColor: Color {
        switch agreement.priority {
        case "hoch": return .red
        case "mittel": return .orange
        default: return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: categoryIcon)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(statusColor)
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 2) {
                    Text(agreement.title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(agreement.category)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Text(statusLabel)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .cornerRadius(8)
            }

            if !agreement.descriptionText.isEmpty {
                Text(agreement.descriptionText)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

            HStack {
                // Priority
                HStack(spacing: 4) {
                    Circle()
                        .fill(priorityColor)
                        .frame(width: 8, height: 8)
                    Text(agreement.priority.capitalized)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Votes
                if agreement.votesYes > 0 || agreement.votesNo > 0 {
                    HStack(spacing: 6) {
                        HStack(spacing: 2) {
                            Image(systemName: "hand.thumbsup.fill")
                                .font(.caption2)
                                .foregroundColor(.green)
                            Text("\(agreement.votesYes)")
                                .font(.caption2)
                        }
                        HStack(spacing: 2) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .font(.caption2)
                                .foregroundColor(.red)
                            Text("\(agreement.votesNo)")
                                .font(.caption2)
                        }
                    }
                }

                // Due date
                if agreement.hasDueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(agreement.dueDate.formatted(date: .abbreviated, time: .omitted))
                            .font(.caption2)
                    }
                    .foregroundColor(.gray)
                }

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Agreement Detail
struct AgreementDetailView: View {
    let agreement: Agreement
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @Query var members: [TripMember]

    var tripMembers: [TripMember] {
        members.filter { $0.tripId == trip.id && $0.isActive }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(agreement.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }

                    HStack(spacing: 12) {
                        Label(agreement.category, systemImage: categoryIcon)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.appPrimary.opacity(0.1))
                            .foregroundColor(.appPrimary)
                            .cornerRadius(8)

                        Label(agreement.priority.capitalized, systemImage: "flag.fill")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(priorityColor.opacity(0.1))
                            .foregroundColor(priorityColor)
                            .cornerRadius(8)
                    }

                    if !agreement.descriptionText.isEmpty {
                        Text(agreement.descriptionText)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)

                // Voting
                VStack(alignment: .leading, spacing: 12) {
                    Text("Abstimmung")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Button(action: {
                            agreement.votesYes += 1
                            agreement.status = "inAbstimmung"
                            try? modelContext.save()
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .font(.title2)
                                Text("Dafür")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("\(agreement.votesYes)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                        }

                        Button(action: {
                            agreement.votesNo += 1
                            agreement.status = "inAbstimmung"
                            try? modelContext.save()
                        }) {
                            VStack(spacing: 6) {
                                Image(systemName: "hand.thumbsdown.fill")
                                    .font(.title2)
                                Text("Dagegen")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Text("\(agreement.votesNo)")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                    }

                    if agreement.votesYes + agreement.votesNo > 0 {
                        let total = Double(agreement.votesYes + agreement.votesNo)
                        let yesPercent = Double(agreement.votesYes) / total

                        GeometryReader { geo in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: geo.size.width * yesPercent)
                                Rectangle()
                                    .fill(Color.red)
                            }
                            .frame(height: 6)
                            .cornerRadius(3)
                        }
                        .frame(height: 6)
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)

                // Status
                VStack(alignment: .leading, spacing: 12) {
                    Text("Status ändern")
                        .font(.headline)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(["offen", "inAbstimmung", "beschlossen", "erledigt"], id: \.self) { status in
                            Button(action: {
                                agreement.status = status
                                if status == "erledigt" { agreement.isResolved = true }
                                try? modelContext.save()
                            }) {
                                Text(statusName(status))
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(agreement.status == status ? statusColor(status) : Color(.systemGray6))
                                    .foregroundColor(agreement.status == status ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)

                // Assigned members
                VStack(alignment: .leading, spacing: 12) {
                    Text("Zugewiesen an")
                        .font(.headline)

                    if agreement.assignedTo.isEmpty {
                        Text("Noch niemand zugewiesen")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    ForEach(tripMembers, id: \.id) { member in
                        let isAssigned = agreement.assignedTo.contains(member.userName)
                        Button(action: {
                            if isAssigned {
                                agreement.assignedTo.removeAll { $0 == member.userName }
                            } else {
                                agreement.assignedTo.append(member.userName)
                            }
                            try? modelContext.save()
                        }) {
                            HStack(spacing: 10) {
                                UserAvatarView(name: member.userName, size: 32)
                                Text(member.userName)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isAssigned ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(isAssigned ? .appPrimary : .gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)

                // Info
                VStack(alignment: .leading, spacing: 8) {
                    Text("Details")
                        .font(.headline)
                    HStack {
                        Text("Erstellt von")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(agreement.createdBy)
                            .font(.caption)
                    }
                    Divider()
                    HStack {
                        Text("Erstellt am")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Spacer()
                        Text(agreement.createdDate.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                    }
                    if agreement.hasDueDate {
                        Divider()
                        HStack {
                            Text("Fällig bis")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text(agreement.dueDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(agreement.dueDate < Date() ? .red : .primary)
                        }
                    }
                }
                .padding()
                .background(Color.appCardBackground)
                .cornerRadius(12)

                // Delete
                Button(role: .destructive) {
                    modelContext.delete(agreement)
                    try? modelContext.save()
                } label: {
                    HStack {
                        Spacer()
                        Label("Absprache löschen", systemImage: "trash")
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }

    var categoryIcon: String {
        switch agreement.category {
        case "Unterkunft": return "building.2.fill"
        case "Transport": return "car.fill"
        case "Aktivitäten": return "figure.hiking"
        case "Essen": return "fork.knife"
        case "Budget": return "banknote.fill"
        default: return "doc.text.fill"
        }
    }

    var priorityColor: Color {
        switch agreement.priority {
        case "hoch": return .red
        case "mittel": return .orange
        default: return .green
        }
    }

    func statusName(_ s: String) -> String {
        switch s {
        case "offen": return "Offen"
        case "inAbstimmung": return "In Abstimmung"
        case "beschlossen": return "Beschlossen"
        case "erledigt": return "Erledigt"
        default: return s
        }
    }

    func statusColor(_ s: String) -> Color {
        switch s {
        case "offen": return .blue
        case "inAbstimmung": return .orange
        case "beschlossen": return .green
        case "erledigt": return .gray
        default: return .red
        }
    }
}

// MARK: - Create Agreement
struct CreateAgreementView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var descriptionText = ""
    @State private var category = "Sonstiges"
    @State private var priority = "mittel"
    @State private var hasDueDate = false
    @State private var dueDate = Date().addingTimeInterval(7 * 24 * 3600)

    let categories = ["Unterkunft", "Transport", "Aktivitäten", "Essen", "Budget", "Sonstiges"]
    let priorities = ["niedrig", "mittel", "hoch"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Absprache") {
                    TextField("Titel", text: $title)
                    TextField("Beschreibung (optional)", text: $descriptionText, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Kategorie & Priorität") {
                    Picker("Kategorie", selection: $category) {
                        ForEach(categories, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                    Picker("Priorität", selection: $priority) {
                        ForEach(priorities, id: \.self) { p in
                            HStack {
                                Circle()
                                    .fill(p == "hoch" ? .red : p == "mittel" ? .orange : .green)
                                    .frame(width: 8, height: 8)
                                Text(p.capitalized)
                            }
                            .tag(p)
                        }
                    }
                }

                Section {
                    Toggle("Fälligkeitsdatum", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Fällig bis", selection: $dueDate, displayedComponents: .date)
                    }
                }

                Section {
                    Button(action: createAgreement) {
                        HStack {
                            Spacer()
                            Text("Absprache erstellen")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                    .listRowBackground(title.isEmpty ? Color.gray.opacity(0.5) : Color.appPrimary)
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Neue Absprache")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func createAgreement() {
        let agreement = Agreement(tripId: trip.id, title: title, descriptionText: descriptionText, createdBy: "Du", category: category, priority: priority)
        if hasDueDate {
            agreement.hasDueDate = true
            agreement.dueDate = dueDate
        }
        modelContext.insert(agreement)
        try? modelContext.save()
        dismiss()
    }
}

