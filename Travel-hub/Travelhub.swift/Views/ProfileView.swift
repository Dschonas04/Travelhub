import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @State private var userName = "Max Mustermann"
    @State private var userEmail = "max@mustermann.com"
    @State private var isEditingProfile = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {
                            UserAvatarView(name: userName, size: 80)
                            Circle()
                                .fill(Color.green)
                                .frame(width: 20, height: 20)
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        }

                        Text(userName)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.appCardBackground)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)

                    // Settings
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Einstellungen")
                            .font(.headline)
                            .padding(.horizontal)

                        VStack(spacing: 0) {
                            settingsRow(icon: "bell.fill", label: "Benachrichtigungen", trailing: AnyView(Toggle("", isOn: .constant(true)).labelsHidden()))
                            Divider().padding(.leading, 48)
                            settingsRow(icon: "moon.fill", label: "Dunkelmodus", trailing: AnyView(Toggle("", isOn: .constant(false)).labelsHidden()))
                            Divider().padding(.leading, 48)
                            settingsRow(icon: "globe", label: "Sprache", trailing: AnyView(Text("Deutsch").font(.caption).foregroundColor(.gray)))
                            Divider().padding(.leading, 48)
                            settingsRow(icon: "lock.fill", label: "Datenschutz", trailing: AnyView(Image(systemName: "chevron.right").foregroundColor(.gray)))
                        }
                        .background(Color.appCardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }

                    // Edit Profile
                    Button(action: { isEditingProfile = true }) {
                        HStack {
                            Image(systemName: "pencil.circle")
                            Text("Profil bearbeiten")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary.opacity(0.1))
                        .foregroundColor(.appPrimary)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    // Logout
                    Button(role: .destructive, action: {
                        withAnimation {
                            isLoggedIn = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Abmelden")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.vertical)
            }
            .background(Color.appBackground)
            .navigationTitle("Einstellungen")
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(userName: $userName, userEmail: $userEmail, userBio: .constant(""))
            }
        }
    }

    func settingsRow(icon: String, label: String, trailing: AnyView) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)
                .frame(width: 24)
            Text(label)
                .font(.body)
                .foregroundColor(.appText)
            Spacer()
            trailing
        }
        .padding()
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var userName: String
    @Binding var userEmail: String
    @Binding var userBio: String

    var body: some View {
        NavigationStack {
            Form {
                Section("Persoenliche Informationen") {
                    TextField("Name", text: $userName)
                    TextField("Email", text: $userEmail)
                        .keyboardType(.emailAddress)
                }
                Section {
                    Button(action: { dismiss() }) {
                        Text("Speichern")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.appPrimary)
                    }
                }
            }
            .navigationTitle("Profil bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ProfileView(isLoggedIn: .constant(true))
}
