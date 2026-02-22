import SwiftUI

struct TravelTipsView: View {
    let trip: Trip
    var accentColor: Color = .appPrimary

    @State private var selectedCategory: TipCategory? = nil
    @State private var searchText: String = ""
    @State private var favorites: Set<String> = [] // store by tip title for stability

    // MARK: - Categories
    enum TipCategory: String, CaseIterable, Identifiable {
        case weather = "Klima & Sonne"
        case health = "Gesundheit"
        case money = "Geld & Zahlungen"
        case safety = "Sicherheit"
        case culture = "Kultur & Sprache"
        case packing = "Packen & Ausrüstung"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .weather: return "sun.max.fill"
            case .health: return "cross.case.fill"
            case .money: return "creditcard.fill"
            case .safety: return "shield.fill"
            case .culture: return "globe"
            case .packing: return "bag.fill"
            }
        }

        var color: Color {
            switch self {
            case .weather: return .budgetOrange
            case .health: return .budgetGreen
            case .money: return .budgetBlue
            case .safety: return .budgetRed
            case .culture: return .budgetPurple
            case .packing: return .appPrimary
            }
        }
    }

    // MARK: - Tip Model
    struct Tip: Identifiable, Hashable {
        var title: String
        var detail: String
        var category: TipCategory
        var id: String { title } // stable identity across recomputation
    }

    // MARK: - Trip context
    var tripDays: Int {
        let cal = Calendar.current
        let start = cal.startOfDay(for: trip.startDate)
        let end = cal.startOfDay(for: trip.endDate)
        let comps = cal.dateComponents([.day], from: start, to: end)
        return max((comps.day ?? 0) + 1, 1)
    }

    var month: Int { Calendar.current.component(.month, from: trip.startDate) }
    var isSummer: Bool { (6...8).contains(month) }
    var isWinter: Bool { month == 12 || month <= 2 }

    var dest: String { trip.destination.lowercased() }
    var isBeach: Bool { dest.contains("strand") || dest.contains("beach") || dest.contains("mallorca") || dest.contains("ibiza") }
    var isMountain: Bool { dest.contains("berg") || dest.contains("ski") || dest.contains("anton") }
    var isCity: Bool { dest.contains("barcelona") || dest.contains("paris") || dest.contains("berlin") || dest.contains("stadt") }

    // MARK: - Tips
    var baseTips: [Tip] {
        [
            Tip(title: "Sonnenschutz", detail: "Vergiss nicht, Sonnencreme mit hohem LSF einzupacken.", category: .weather),
            Tip(title: "Wasser trinken", detail: "Trinke mindestens 2 Liter Wasser pro Tag bei Hitze.", category: .health),
            Tip(title: "Bargeld & Karte", detail: "Habe etwas Bargeld dabei – nicht alle Geschäfte akzeptieren Karten.", category: .money),
            Tip(title: "Reiseapotheke", detail: "Packe eine kleine Reiseapotheke mit den wichtigsten Medikamenten ein.", category: .health),
            Tip(title: "Sprachbasics", detail: "Lerne ein paar Grundbegriffe der Landessprache – das hilft überall.", category: .culture),
            Tip(title: "Sicherheitskopien", detail: "Speichere Ausweiskopien (digital/ausgedruckt) getrennt vom Original.", category: .safety),
            Tip(title: "Packwürfel nutzen", detail: "Mit Packwürfeln bleibt der Koffer organisiert und du findest schneller alles.", category: .packing),
        ]
    }

    var destinationTips: [Tip] {
        var t: [Tip] = []
        if isBeach {
            t += [
                Tip(title: "After Sun", detail: "Beruhigt die Haut nach langen Tagen in der Sonne.", category: .health),
                Tip(title: "Wasserfeste Hülle", detail: "Schütze dein Handy am Strand (Sand/Wasser).", category: .packing),
                Tip(title: "Siesta-Zeiten", detail: "In Südeuropa sind Geschäfte nachmittags oft geschlossen.", category: .culture),
            ]
        }
        if isMountain {
            t += [
                Tip(title: "Zwiebelprinzip", detail: "Mehrere Kleidungsschichten statt einer dicken – flexibler bei Wetterumschwüngen.", category: .packing),
                Tip(title: "Wanderschuhe einlaufen", detail: "Blasen vermeiden – Schuhe vor der Reise tragen.", category: .health),
                Tip(title: "Wetterumschwung", detail: "In den Bergen kann es schnell umschlagen – Regenjacke einpacken.", category: .weather),
            ]
        }
        if isCity {
            t += [
                Tip(title: "Bequeme Schuhe", detail: "Städte erkundet man zu Fuß – bequeme Schuhe sind Gold wert.", category: .packing),
                Tip(title: "ÖPNV-Apps", detail: "Lade lokale ÖPNV-/City-Apps für Tickets & Routen.", category: .money),
                Tip(title: "Taschendiebe", detail: "Wertsachen nah am Körper tragen – besonders in touristischen Zonen.", category: .safety),
            ]
        }
        return t
    }

    var seasonTips: [Tip] {
        var t: [Tip] = []
        if isSummer {
            t += [
                Tip(title: "Mittagshitze meiden", detail: "Plane Aktivitäten morgens/abends und mach mittags Pause.", category: .weather),
                Tip(title: "Mückenschutz", detail: "In warmen Regionen Mückenspray nicht vergessen.", category: .health),
            ]
        }
        if isWinter {
            t += [
                Tip(title: "Wärmeschichten", detail: "Thermo-Unterwäsche, Mütze & Handschuhe einplanen.", category: .packing),
                Tip(title: "Kürzere Tage", detail: "Beachte die kürzere Tageslichtzeit bei deiner Planung.", category: .weather),
            ]
        }
        return t
    }

    var durationTips: [Tip] {
        var t: [Tip] = []
        if tripDays >= 7 {
            t += [
                Tip(title: "Wäsche planen", detail: "Für längere Reisen: Waschmöglichkeit oder Handwaschmittel einplanen.", category: .packing),
                Tip(title: "eSIM/Prepaid", detail: "Längere Aufenthalte: eSIM/Prepaid vor Ort kann günstiger sein.", category: .money),
            ]
        }
        return t
    }

    var allTips: [Tip] {
        // Merge and deduplicate by title
        let combined = baseTips + destinationTips + seasonTips + durationTips
        var seen = Set<String>()
        var result: [Tip] = []
        for tip in combined {
            if !seen.contains(tip.title) {
                seen.insert(tip.title)
                result.append(tip)
            }
        }
        return result
    }

    var filteredTips: [Tip] {
        let byCategory = selectedCategory == nil ? allTips : allTips.filter { $0.category == selectedCategory }
        if searchText.isEmpty { return byCategory }
        return byCategory.filter { tip in
            tip.title.localizedCaseInsensitiveContains(searchText) || tip.detail.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Category filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterPill(title: "Alle", icon: "line.3.horizontal.decrease.circle", color: accentColor, isSelected: selectedCategory == nil) {
                            withAnimation { selectedCategory = nil }
                        }
                        ForEach(TipCategory.allCases) { cat in
                            filterPill(title: cat.rawValue, icon: cat.icon, color: cat.color, isSelected: selectedCategory == cat) {
                                withAnimation { selectedCategory = (selectedCategory == cat ? nil : cat) }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                if filteredTips.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 56))
                            .foregroundColor(accentColor.opacity(0.35))
                        Text("Keine passenden Tipps")
                            .font(.headline)
                        Text("Passe Filter oder Suche an")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, minHeight: 220)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTips, id: \.id) { tip in
                            tipCard(tip)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 12)
        }
        .background(Color.appBackground)
        .navigationTitle("Tipps zum Reiseziel")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Tipps durchsuchen…")
        .tint(accentColor)
    }

    // MARK: - Subviews
    func filterPill(title: String, icon: String, color: Color, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
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

    func tipCard(_ tip: Tip) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tip.category.color.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: tip.category.icon)
                        .foregroundColor(tip.category.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appText)
                    Text(tip.detail)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                VStack(spacing: 8) {
                    Button(action: { toggleFavorite(tip) }) {
                        Image(systemName: isFavorite(tip) ? "star.fill" : "star")
                            .foregroundColor(isFavorite(tip) ? tip.category.color : .gray)
                    }
                    ShareLink(item: "\(tip.title) – \(tip.detail)") {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(tip.category.color.opacity(0.15), lineWidth: 1)
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    // MARK: - Actions
    func toggleFavorite(_ tip: Tip) {
        if isFavorite(tip) {
            favorites.remove(tip.id)
        } else {
            favorites.insert(tip.id)
        }
    }

    func isFavorite(_ tip: Tip) -> Bool { favorites.contains(tip.id) }
}
#Preview {
    let trip = Trip(title: "Mallorca 06/2026", startDate: Date(), endDate: Date().addingTimeInterval(7*24*3600), destination: "Mallorca")
    NavigationStack {
        TravelTipsView(trip: trip)
    }
}

