import SwiftUI
import MapKit
import SwiftData

// MARK: - Destination Model
struct TravelDestination: Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String
    let country: String
    let coordinate: CLLocationCoordinate2D
    let category: DestinationCategory
    let description: String
    let rating: Double
    let imageSystemName: String
    let priceLevel: Int // 1-3 (€, €€, €€€)
    let highlights: [String]

    static func == (lhs: TravelDestination, rhs: TravelDestination) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var priceLevelString: String {
        String(repeating: "€", count: priceLevel)
    }
}

enum DestinationCategory: String, CaseIterable {
    case strand = "Strand"
    case stadt = "Stadt"
    case berge = "Berge"
    case kultur = "Kultur"
    case abenteuer = "Abenteuer"
    case insel = "Insel"

    var icon: String {
        switch self {
        case .strand: return "sun.max.fill"
        case .stadt: return "building.2.fill"
        case .berge: return "mountain.2.fill"
        case .kultur: return "theatermasks.fill"
        case .abenteuer: return "figure.hiking"
        case .insel: return "water.waves"
        }
    }

    var color: Color {
        switch self {
        case .strand: return .orange
        case .stadt: return .purple
        case .berge: return .green
        case .kultur: return .pink
        case .abenteuer: return .red
        case .insel: return .cyan
        }
    }
}

// MARK: - Sample Data
extension TravelDestination {
    static let sampleDestinations: [TravelDestination] = [
        // Spanien
        TravelDestination(name: "Mallorca", country: "Spanien", coordinate: CLLocationCoordinate2D(latitude: 39.6953, longitude: 3.0176), category: .strand, description: "Traumhafte Strände, malerische Buchten und lebendige Kultur auf der beliebtesten Baleareninsel.", rating: 4.5, imageSystemName: "sun.max.fill", priceLevel: 2, highlights: ["Drachenhöhlen", "Palma Altstadt", "Cap Formentor", "Serra de Tramuntana"]),
        TravelDestination(name: "Barcelona", country: "Spanien", coordinate: CLLocationCoordinate2D(latitude: 41.3874, longitude: 2.1686), category: .stadt, description: "Gaudís Meisterwerke, mediterrane Küche und Strandleben in Kataloniens Hauptstadt.", rating: 4.7, imageSystemName: "building.2.fill", priceLevel: 2, highlights: ["Sagrada Familia", "Park Güell", "La Rambla", "Barceloneta Strand"]),
        TravelDestination(name: "Ibiza", country: "Spanien", coordinate: CLLocationCoordinate2D(latitude: 38.9067, longitude: 1.4206), category: .insel, description: "Weltberühmte Clubs, versteckte Buchten und wunderschöne Sonnenuntergänge.", rating: 4.3, imageSystemName: "water.waves", priceLevel: 3, highlights: ["Altstadt Dalt Vila", "Cala Comte", "Es Vedrà", "Hippiemärkte"]),

        // Italien
        TravelDestination(name: "Rom", country: "Italien", coordinate: CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964), category: .kultur, description: "Die ewige Stadt – antike Ruinen, Vatikan und die beste Pasta der Welt.", rating: 4.8, imageSystemName: "theatermasks.fill", priceLevel: 2, highlights: ["Kolosseum", "Vatikan", "Trevi-Brunnen", "Pantheon"]),
        TravelDestination(name: "Amalfiküste", country: "Italien", coordinate: CLLocationCoordinate2D(latitude: 40.6340, longitude: 14.6027), category: .strand, description: "Dramatische Klippen, pastellfarbene Dörfer und kristallklares Wasser.", rating: 4.6, imageSystemName: "sun.max.fill", priceLevel: 3, highlights: ["Positano", "Ravello", "Capri Bootstour", "Limoncello Verkostung"]),
        TravelDestination(name: "Sardinien", country: "Italien", coordinate: CLLocationCoordinate2D(latitude: 40.1209, longitude: 9.0129), category: .insel, description: "Karibik-Feeling im Mittelmeer mit türkisfarbenem Wasser und wilder Natur.", rating: 4.4, imageSystemName: "water.waves", priceLevel: 2, highlights: ["Costa Smeralda", "Cala Luna", "Grotta di Nettuno", "Nuraghen"]),

        // Frankreich
        TravelDestination(name: "Paris", country: "Frankreich", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), category: .stadt, description: "Die Stadt der Liebe – Eiffelturm, Louvre und die schönsten Boulevards Europas.", rating: 4.6, imageSystemName: "building.2.fill", priceLevel: 3, highlights: ["Eiffelturm", "Louvre", "Montmartre", "Champs-Élysées"]),
        TravelDestination(name: "Nizza", country: "Frankreich", coordinate: CLLocationCoordinate2D(latitude: 43.7102, longitude: 7.2620), category: .strand, description: "Glamour an der Côte d'Azur mit Promenade, Altstadt und azurblauem Meer.", rating: 4.3, imageSystemName: "sun.max.fill", priceLevel: 3, highlights: ["Promenade des Anglais", "Altstadt", "Colline du Château", "Matisse Museum"]),

        // Griechenland
        TravelDestination(name: "Santorini", country: "Griechenland", coordinate: CLLocationCoordinate2D(latitude: 36.3932, longitude: 25.4615), category: .insel, description: "Ikonische weiß-blaue Architektur und die schönsten Sonnenuntergänge der Ägäis.", rating: 4.7, imageSystemName: "water.waves", priceLevel: 3, highlights: ["Oia Sonnenuntergang", "Red Beach", "Akrotiri", "Weinverkostung"]),
        TravelDestination(name: "Kreta", country: "Griechenland", coordinate: CLLocationCoordinate2D(latitude: 35.2401, longitude: 24.8093), category: .abenteuer, description: "Griechenlands größte Insel mit Schluchten, Stränden und antiker Geschichte.", rating: 4.5, imageSystemName: "figure.hiking", priceLevel: 1, highlights: ["Samaria-Schlucht", "Elafonisi Strand", "Knossos", "Balos Lagune"]),
        TravelDestination(name: "Athen", country: "Griechenland", coordinate: CLLocationCoordinate2D(latitude: 37.9838, longitude: 23.7275), category: .kultur, description: "Wiege der Demokratie – Akropolis, lebendige Viertel und griechische Gastfreundschaft.", rating: 4.4, imageSystemName: "theatermasks.fill", priceLevel: 1, highlights: ["Akropolis", "Plaka", "Monastiraki", "Syntagma-Platz"]),

        // Österreich
        TravelDestination(name: "St. Anton", country: "Österreich", coordinate: CLLocationCoordinate2D(latitude: 47.1275, longitude: 10.2683), category: .berge, description: "Weltklasse-Skigebiet und Wanderparadies in den Tiroler Alpen.", rating: 4.5, imageSystemName: "mountain.2.fill", priceLevel: 2, highlights: ["Skifahren", "Après-Ski", "Verwalltal Wanderung", "Bergpanorama"]),
        TravelDestination(name: "Wien", country: "Österreich", coordinate: CLLocationCoordinate2D(latitude: 48.2082, longitude: 16.3738), category: .kultur, description: "Kaiserstadt mit Prachtbauten, Kaffeehauskultur und musikalischer Tradition.", rating: 4.6, imageSystemName: "theatermasks.fill", priceLevel: 2, highlights: ["Schloss Schönbrunn", "Stephansdom", "Naschmarkt", "Hofburg"]),

        // Deutschland
        TravelDestination(name: "Berlin", country: "Deutschland", coordinate: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050), category: .stadt, description: "Pulsierende Hauptstadt mit Geschichte, Kunst, Clubs und multikulturellen Vierteln.", rating: 4.4, imageSystemName: "building.2.fill", priceLevel: 1, highlights: ["Brandenburger Tor", "East Side Gallery", "Museumsinsel", "Kreuzberg"]),
        TravelDestination(name: "München", country: "Deutschland", coordinate: CLLocationCoordinate2D(latitude: 48.1351, longitude: 11.5820), category: .kultur, description: "Bayerische Gemütlichkeit, Biergärten, Alpen-Nähe und erstklassige Museen.", rating: 4.3, imageSystemName: "theatermasks.fill", priceLevel: 2, highlights: ["Marienplatz", "Englischer Garten", "Oktoberfest", "Schloss Nymphenburg"]),

        // Kroatien
        TravelDestination(name: "Dubrovnik", country: "Kroatien", coordinate: CLLocationCoordinate2D(latitude: 42.6507, longitude: 18.0944), category: .kultur, description: "Die Perle der Adria – mittelalterliche Stadtmauern und kristallklares Meer.", rating: 4.5, imageSystemName: "theatermasks.fill", priceLevel: 2, highlights: ["Stadtmauer", "Lokrum Insel", "Stradun", "Game of Thrones Drehorte"]),
        TravelDestination(name: "Split", country: "Kroatien", coordinate: CLLocationCoordinate2D(latitude: 43.5081, longitude: 16.4402), category: .strand, description: "Antiker Diokletianpalast trifft auf moderne Strandkultur an der dalmatinischen Küste.", rating: 4.3, imageSystemName: "sun.max.fill", priceLevel: 1, highlights: ["Diokletianpalast", "Marjan Hügel", "Bačvice Strand", "Hvar Tagesausflug"]),

        // Portugal
        TravelDestination(name: "Lissabon", country: "Portugal", coordinate: CLLocationCoordinate2D(latitude: 38.7223, longitude: -9.1393), category: .stadt, description: "Hügelige Stadt am Tejo mit Fado-Musik, Pastéis de Nata und bunt gekachelten Fassaden.", rating: 4.5, imageSystemName: "building.2.fill", priceLevel: 1, highlights: ["Alfama", "Belém Tower", "Tram 28", "Pastéis de Belém"]),
        TravelDestination(name: "Algarve", country: "Portugal", coordinate: CLLocationCoordinate2D(latitude: 37.0179, longitude: -7.9307), category: .strand, description: "Spektakuläre Felsformationen, goldene Strände und ganzjährig mildes Klima.", rating: 4.4, imageSystemName: "sun.max.fill", priceLevel: 1, highlights: ["Benagil Höhle", "Praia da Marinha", "Lagos", "Silves Burg"]),
    ]
}

// MARK: - SearchHub View
struct SearchHubView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 45.0, longitude: 10.0),
            span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        )
    )
    @State private var searchText = ""
    @State private var selectedDestination: TravelDestination?
    @State private var selectedCategory: DestinationCategory?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var showList = false
    @State private var showCreateTrip = false

    let destinations = TravelDestination.sampleDestinations

    var filteredDestinations: [TravelDestination] {
        // Start with all destinations
        let base: [TravelDestination] = destinations

        // Apply category filter explicitly
        let categoryFiltered: [TravelDestination]
        if let cat = selectedCategory {
            categoryFiltered = base.filter { (item: TravelDestination) -> Bool in
                return item.category == cat
            }
        } else {
            categoryFiltered = base
        }

        // Apply text search filter explicitly
        let finalFiltered: [TravelDestination]
        let query: String = searchText
        if !query.isEmpty {
            finalFiltered = categoryFiltered.filter { (item: TravelDestination) -> Bool in
                let nameMatch = item.name.localizedCaseInsensitiveContains(query)
                let countryMatch = item.country.localizedCaseInsensitiveContains(query)
                let categoryMatch = item.category.rawValue.localizedCaseInsensitiveContains(query)
                return nameMatch || countryMatch || categoryMatch
            }
        } else {
            finalFiltered = categoryFiltered
        }

        return finalFiltered
    }

    var nearbyDestinations: [TravelDestination] {
        guard let region = visibleRegion else { return filteredDestinations }

        // Precompute bounds to help the type-checker
        let halfLatDelta = region.span.latitudeDelta / 2
        let halfLonDelta = region.span.longitudeDelta / 2
        let center = region.center

        let minLat = center.latitude - halfLatDelta
        let maxLat = center.latitude + halfLatDelta
        let minLon = center.longitude - halfLonDelta
        let maxLon = center.longitude + halfLonDelta

        return filteredDestinations.filter { (dest: TravelDestination) -> Bool in
            let lat = dest.coordinate.latitude
            let lon = dest.coordinate.longitude

            let withinLat = (lat >= minLat) && (lat <= maxLat)
            let withinLon = (lon >= minLon) && (lon <= maxLon)

            return withinLat && withinLon
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                SearchHubMapContent(
                    cameraPosition: $cameraPosition,
                    selectedDestination: $selectedDestination,
                    items: filteredDestinations
                )
                .mapStyle(.standard(elevation: .realistic))
                .onMapCameraChange(frequency: .onEnd) { context in
                    visibleRegion = context.region
                }

                // Overlay UI
                VStack(spacing: 0) {
                    // Search Bar
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Reiseziel suchen...", text: $searchText)
                                .font(.subheadline)

                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                        // Category Filter Pills
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                CategoryPill(title: "Alle", icon: "globe", isSelected: selectedCategory == nil) {
                                    withAnimation { selectedCategory = nil }
                                }

                                ForEach(DestinationCategory.allCases, id: \.self) { cat in
                                    CategoryPill(title: cat.rawValue, icon: cat.icon, isSelected: selectedCategory == cat) {
                                        withAnimation {
                                            selectedCategory = selectedCategory == cat ? nil : cat
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)

                    Spacer()

                    // Bottom Panel
                    if let dest = selectedDestination {
                        // Selected destination card
                        DestinationDetailCard(destination: dest, onClose: {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDestination = nil
                            }
                        }, onCreateTrip: {
                            showCreateTrip = true
                        })
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    } else {
                        // Nearby destinations list toggle
                        VStack(spacing: 0) {
                            // Handle
                            Button(action: {
                                withAnimation(.spring(response: 0.3)) {
                                    showList.toggle()
                                }
                            }) {
                                VStack(spacing: 8) {
                                    Capsule()
                                        .fill(Color.gray.opacity(0.4))
                                        .frame(width: 40, height: 5)
                                        .padding(.top, 10)

                                    HStack {
                                        Text("\(nearbyDestinations.count) Reiseziele in der Nähe")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.appText)

                                        Spacer()

                                        Image(systemName: showList ? "chevron.down" : "chevron.up")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, showList ? 4 : 12)
                                }
                            }

                            if showList {
                                ScrollView {
                                    VStack(spacing: 8) {
                                        ForEach(nearbyDestinations) { dest in
                                            NearbyDestinationRow(destination: dest)
                                                .onTapGesture {
                                                    withAnimation(.spring(response: 0.4)) {
                                                        selectedDestination = dest
                                                        cameraPosition = .region(
                                                            MKCoordinateRegion(
                                                                center: dest.coordinate,
                                                                span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                                                            )
                                                        )
                                                    }
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                }
                                .frame(maxHeight: 280)
                            }
                        }
                        .background(.ultraThinMaterial)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -4)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationTitle("Search Hub")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.4)) {
                            cameraPosition = .region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 45.0, longitude: 10.0),
                                    span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
                                )
                            )
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.appPrimary)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
            }
            .sheet(isPresented: $showCreateTrip) {
                if let dest = selectedDestination {
                    CreateTripFromDestinationView(destination: dest)
                }
            }
        }
    }
}

// MARK: - Helper for Map Content (keeps type-checker happy)
private struct SearchHubMapContent: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var selectedDestination: TravelDestination?
    let items: [TravelDestination]

    var body: some View {
        Map(initialPosition: cameraPosition, selection: $selectedDestination) {
            ForEach(items) { dest in
                Annotation("\(dest.name)", coordinate: dest.coordinate) {
                    DestinationPinView(
                        destination: dest,
                        isSelected: (selectedDestination?.id == dest.id)
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            selectedDestination = dest
                        }
                    }
                }
                .tag(dest)
            }
        }
    }
}

// MARK: - Destination Pin
struct DestinationPinView: View {
    let destination: TravelDestination
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(isSelected ? destination.category.color : .white)
                    .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                    .shadow(color: destination.category.color.opacity(0.4), radius: isSelected ? 8 : 4, x: 0, y: 2)

                Image(systemName: destination.category.icon)
                    .font(.system(size: isSelected ? 20 : 16))
                    .foregroundColor(isSelected ? .white : destination.category.color)
            }

            // Arrow
            Triangle()
                .fill(isSelected ? destination.category.color : .white)
                .frame(width: 12, height: 8)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Category Pill
struct CategoryPill: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
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
            .background(isSelected ? Color.appPrimary : Color.white.opacity(0.9))
            .foregroundColor(isSelected ? .white : .appText)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Destination Detail Card
struct DestinationDetailCard: View {
    let destination: TravelDestination
    let onClose: () -> Void
    let onCreateTrip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: destination.category.icon)
                            .foregroundColor(destination.category.color)
                        Text(destination.category.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(destination.category.color)
                    }

                    Text(destination.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.appText)

                    Text(destination.country)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.gray.opacity(0.6))
                    }

                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", destination.rating))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }

                    Text(destination.priceLevelString)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.appPrimary)
                }
            }

            // Description
            Text(destination.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)

            // Highlights
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(destination.highlights, id: \.self) { highlight in
                        Text(highlight)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.appPrimary.opacity(0.1))
                            .foregroundColor(.appPrimary)
                            .cornerRadius(12)
                    }
                }
            }

            // Action Button
            Button(action: onCreateTrip) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Reise nach \(destination.name) planen")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.appPrimary)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: -4)
    }
}

// MARK: - Nearby Destination Row
struct NearbyDestinationRow: View {
    let destination: TravelDestination

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(destination.category.color.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: destination.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(destination.category.color)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(destination.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.appText)

                Text("\(destination.country) · \(destination.category.rawValue)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", destination.rating))
                        .font(.caption)
                        .fontWeight(.semibold)
                }

                Text(destination.priceLevelString)
                    .font(.caption)
                    .foregroundColor(.appPrimary)
                    .fontWeight(.semibold)
            }
        }
        .padding(10)
        .background(Color.appCardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Create Trip from Destination
struct CreateTripFromDestinationView: View {
    let destination: TravelDestination
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var title = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(7 * 24 * 3600)
    @State private var budget = ""

    var body: some View {
        NavigationStack {
            Form {
                // Destination Info Header
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(destination.category.color.opacity(0.15))
                                .frame(width: 56, height: 56)

                            Image(systemName: destination.category.icon)
                                .font(.system(size: 24))
                                .foregroundColor(destination.category.color)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(destination.name)
                                .font(.headline)
                            Text(destination.country)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", destination.rating))
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
                    }
                }

                Section("Reisedetails") {
                    TextField("Reisename (z.B. \(destination.name) Sommer 2026)", text: $title)
                }

                Section("Zeitraum") {
                    DatePicker("Startdatum", selection: $startDate, displayedComponents: .date)
                    DatePicker("Enddatum", selection: $endDate, displayedComponents: .date)
                }

                Section("Budget") {
                    HStack {
                        Text("€")
                        TextField("Betrag", text: $budget)
                            .keyboardType(.decimalPad)
                    }
                }

                // Highlights
                Section("Highlights in \(destination.name)") {
                    ForEach(destination.highlights, id: \.self) { highlight in
                        HStack(spacing: 10) {
                            Image(systemName: "star.circle.fill")
                                .foregroundColor(.appPrimary)
                            Text(highlight)
                        }
                    }
                }

                Section {
                    Button(action: createTrip) {
                        Text("Reise erstellen")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.appPrimary)
                    }
                    .disabled(title.isEmpty)
                }
            }
            .navigationTitle("Reise planen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
            }
            .onAppear {
                if title.isEmpty {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MM/yyyy"
                    title = "\(destination.name) \(formatter.string(from: startDate))"
                }
            }
        }
    }

    private func createTrip() {
        let trip = Trip(
            title: title,
            startDate: startDate,
            endDate: endDate,
            destination: destination.name
        )
        trip.budget = Double(budget) ?? 0
        trip.organizer = "Max Mustermann"
        trip.members = ["Max Mustermann"]
        modelContext.insert(trip)
        do {
            try modelContext.save()
        } catch {
            // Handle save errors gracefully (e.g., log). In production, show an alert.
            print("Failed to save trip: \(error)")
        }
        dismiss()
    }
}

// MARK: - Corner Radius Helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Preview
#Preview {
    SearchHubView()
}

