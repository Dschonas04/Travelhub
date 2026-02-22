import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var showRegistration = false
    @State private var showForgotPassword = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 12) {
                    Image(systemName: "airplane.circle.fill")
                        .resizable()
                        .frame(width: 72, height: 72)
                        .foregroundStyle(.linearGradient(
                            colors: [.appPrimary, .appSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))

                    Text("TravelTogether")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.appText)
                }
                .padding(.bottom, 40)

                Text("Anmelden")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)

                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        TextField("beispiel@gmail.com", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Passwort")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        SecureField("\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}\u{2022}", text: $password)
                            .textContentType(.password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)

                HStack {
                    Spacer()
                    Button("Passwort vergessen?") {
                        showForgotPassword = true
                    }
                    .font(.caption)
                    .foregroundColor(.appPrimary)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isLoggedIn = true
                    }
                }) {
                    Text("Sign in")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                Spacer()

                HStack(spacing: 4) {
                    Text("Kein Account?")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Button("Registrieren") {
                        showRegistration = true
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appPrimary)
                }
                .padding(.bottom, 32)
            }
            .background(Color(.systemBackground))
            .sheet(isPresented: $showRegistration) {
                RegisterView(isLoggedIn: $isLoggedIn)
            }
            .alert("Passwort vergessen", isPresented: $showForgotPassword) {
                Button("OK", role: .cancel) {}
            }
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
