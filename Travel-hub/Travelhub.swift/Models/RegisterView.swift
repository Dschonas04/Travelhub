import SwiftUI

struct RegisterView: View {
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var acceptedTerms = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(.tint)

                    Text("Registrieren")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 32)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        TextField("Deine E-Mailadresse", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Passwort")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        SecureField("Dein Passwort", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)

                // AGB Checkbox
                HStack(alignment: .top, spacing: 10) {
                    Button(action: { acceptedTerms.toggle() }) {
                        Image(systemName: acceptedTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(acceptedTerms ? .accentColor : .gray)
                            .font(.title3)
                    }

                    Text("Ich akzeptiere die AGBs sowie die Datenschutzbestimmungen")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Button(action: {
                    withAnimation {
                        isLoggedIn = true
                    }
                }) {
                    Text("Fortfahren")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(acceptedTerms ? Color.accentColor : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(!acceptedTerms)
                .padding(.horizontal, 24)
                .padding(.top, 24)

                Spacer()

                HStack(spacing: 4) {
                    Text("Du hast einen Account?")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Button("Hier anmelden") {
                        dismiss()
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appPrimary)
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    RegisterView(isLoggedIn: .constant(false))
}

