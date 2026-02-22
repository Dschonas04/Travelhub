import SwiftUI
import SwiftData

struct GroupManagementView: View {
    let trip: Trip
    @Query var members: [TripMember]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var showInviteSheet = false
    @State private var showRoleInfo = false

    let availableRoles: [(String, String, String)] = [
        ("Organisator", "crown.fill", "Plant und koordiniert die Reise"),
        ("Finanzer", "banknote.fill", "Verwaltet Budget und Ausgaben"),
        ("Navigator", "map.fill", "Kümmert sich um Routen & Transport"),
        ("Fotograf", "camera.fill", "Dokumentiert die Reise"),
        ("Koch", "fork.knife", "Organisiert Verpflegung"),
        ("Teilnehmer", "person.fill", "Standard-Rolle"),
    ]

    var tripMembers: [TripMember] {
        members.filter { $0.tripId == trip.id && $0.isActive }
    }

    var body: some View {
        List {
            // Group Header
            Section {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.appPrimary, .appSecondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 72, height: 72)
                        Image(systemName: "airplane")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    Text(trip.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    Text(trip.destination)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("\(tripMembers.count) Mitglieder")
                        .font(.caption)
                        .foregroundColor(.appPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.appPrimary.opacity(0.1))
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            // Members
            Section("Mitglieder & Rollen") {
                ForEach(tripMembers, id: \.id) { member in
                    MemberRoleRow(member: member, availableRoles: availableRoles) { newRole in
                        member.role = newRole
                        try? modelContext.save()
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        tripMembers[index].isActive = false
                    }
                    try? modelContext.save()
                }
            }

            // Invite
            Section {
                Button(action: { showInviteSheet = true }) {
                    HStack(spacing: 10) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.appPrimary)
                            .cornerRadius(8)
                        Text("Mitglied einladen")
                            .foregroundColor(.appPrimary)
                            .fontWeight(.medium)
                    }
                }
            }

            // Available Roles
            Section {
                DisclosureGroup("Verfügbare Rollen") {
                    ForEach(availableRoles, id: \.0) { role, icon, desc in
                        HStack(spacing: 12) {
                            Image(systemName: icon)
                                .font(.system(size: 16))
                                .foregroundColor(.appPrimary)
                                .frame(width: 32, height: 32)
                                .background(Color.appPrimary.opacity(0.1))
                                .cornerRadius(8)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(role)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text(desc)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            // Leave group
            Section {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        Text("Gruppe verlassen")
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Gruppenverwaltung")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Fertig") { dismiss() }
            }
        }
        .sheet(isPresented: $showInviteSheet) {
            InviteMemberView(trip: trip)
        }
    }
}

// MARK: - Member Row with Role Picker
struct MemberRoleRow: View {
    let member: TripMember
    let availableRoles: [(String, String, String)]
    let onRoleChange: (String) -> Void

    @State private var showRolePicker = false

    var roleIcon: String {
        availableRoles.first { $0.0 == member.role }?.1 ?? "person.fill"
    }

    var roleColor: Color {
        switch member.role {
        case "Organisator": return .orange
        case "Finanzer": return .green
        case "Navigator": return .blue
        case "Fotograf": return .purple
        case "Koch": return .red
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            UserAvatarView(name: member.userName, size: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(member.userName)
                    .font(.body)
                    .fontWeight(.medium)

                Button(action: { showRolePicker = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: roleIcon)
                            .font(.caption2)
                        Text(member.role)
                            .font(.caption)
                    }
                    .foregroundColor(roleColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(roleColor.opacity(0.1))
                    .cornerRadius(8)
                }
            }

            Spacer()

            if member.role == "Organisator" {
                Image(systemName: "crown.fill")
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .confirmationDialog("Rolle zuweisen", isPresented: $showRolePicker) {
            ForEach(availableRoles, id: \.0) { role, _, _ in
                Button(action: { onRoleChange(role) }) {
                    Text(role == member.role ? "\(role) \u{2713}" : role)
                }
            }
            Button("Abbrechen", role: .cancel) { }
        }
    }
}

// MARK: - Invite Member Sheet
struct InviteMemberView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var email = ""
    @State private var selectedRole = "Teilnehmer"

    let roles = ["Teilnehmer", "Organisator", "Finanzer", "Navigator", "Fotograf", "Koch"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Neues Mitglied") {
                    TextField("Name", text: $name)
                    TextField("E-Mail (optional)", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section("Rolle zuweisen") {
                    Picker("Rolle", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role).tag(role)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section {
                    Button(action: inviteMember) {
                        HStack {
                            Spacer()
                            Text("Einladen")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .background(name.isEmpty ? Color.gray : Color.appPrimary)
                        .cornerRadius(8)
                    }
                    .disabled(name.isEmpty)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Mitglied einladen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }

    private func inviteMember() {
        let member = TripMember(tripId: trip.id, userName: name, userEmail: email, role: selectedRole)
        modelContext.insert(member)
        try? modelContext.save()
        dismiss()
    }
}

