import SwiftUI

struct TravelTipsView: View {
    let trip: Trip

    let tips = [
        ("sun.max.fill", "Sonnenschutz", "Vergiss nicht, Sonnencreme mit hohem LSF einzupacken."),
        ("drop.fill", "Wasser trinken", "Trinke mindestens 2 Liter Wasser pro Tag bei Hitze."),
        ("creditcard.fill", "Bargeld", "Habe immer etwas Bargeld dabei, nicht alle Geschaefte akzeptieren Karten."),
        ("cross.case.fill", "Reiseapotheke", "Packe eine kleine Reiseapotheke mit den wichtigsten Medikamenten ein."),
        ("globe", "Sprache", "Einige Grundkenntnisse in Spanisch koennen hilfreich sein."),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(tips, id: \.1) { icon, title, description in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundColor(.appPrimary)
                            .frame(width: 40, height: 40)
                            .background(Color.appPrimary.opacity(0.1))
                            .cornerRadius(10)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.headline)
                                .foregroundColor(.appText)
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }
                    .padding()
                    .background(Color.appCardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
        }
        .background(Color.appBackground)
        .navigationTitle("Tipps zum Reiseziel")
        .navigationBarTitleDisplayMode(.inline)
    }
}
