import SwiftUI

struct Hotel: Identifiable {
    let id = UUID()
    let name: String
    let stars: Int
    let address: String
    let region: String
    let pricePerNight: Double
    let imageSystemName: String
}

struct HotelView: View {
    let trip: Trip
    @State private var selectedRegion = "Palma"
    let regions = ["Palma", "Alcudia", "Cala d'Or", "Soller"]

    let hotels: [Hotel] = [
        Hotel(name: "Musterhotel", stars: 4, address: "Musterstr. 1, Palma", region: "Palma", pricePerNight: 120, imageSystemName: "building.2.fill"),
        Hotel(name: "Beispielhotel", stars: 3, address: "Beispielstr. 1, Palma", region: "Palma", pricePerNight: 85, imageSystemName: "building.fill"),
        Hotel(name: "Example-Hotel", stars: 5, address: "Example-Str. 1, Palma", region: "Palma", pricePerNight: 220, imageSystemName: "building.2.crop.circle.fill"),
        Hotel(name: "Strandhotel", stars: 3, address: "Strandstr. 1, Palma", region: "Palma", pricePerNight: 95, imageSystemName: "beach.umbrella"),
    ]

    var filteredHotels: [Hotel] {
        hotels.filter { $0.region == selectedRegion }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Region Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Auswahl der Region")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 12)

                Menu {
                    ForEach(regions, id: \.self) { region in
                        Button(region) { selectedRegion = region }
                    }
                } label: {
                    HStack {
                        Text(selectedRegion)
                            .font(.body)
                            .foregroundColor(.appText)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }

            // Hotel List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredHotels) { hotel in
                        NavigationLink(destination: HotelDetailView(hotel: hotel)) {
                            HStack(spacing: 14) {
                                Image(systemName: hotel.imageSystemName)
                                    .font(.system(size: 28))
                                    .foregroundColor(.appPrimary)
                                    .frame(width: 56, height: 56)
                                    .background(Color.appPrimary.opacity(0.1))
                                    .cornerRadius(12)

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack(spacing: 4) {
                                        Text(hotel.name)
                                            .font(.headline)
                                            .foregroundColor(.appText)
                                        Text(String(repeating: "\u{2605}", count: hotel.stars))
                                            .font(.caption)
                                            .foregroundColor(.yellow)
                                    }
                                    Text(hotel.address)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                VStack(alignment: .trailing) {
                                    Text("\u{20AC}\(Int(hotel.pricePerNight))")
                                        .font(.headline)
                                        .foregroundColor(.appPrimary)
                                    Text("/ Nacht")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color.appCardBackground)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .background(Color.appBackground)
        .navigationTitle("Hotelvorschlaege")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HotelDetailView: View {
    let hotel: Hotel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: hotel.imageSystemName)
                    .font(.system(size: 80))
                    .foregroundColor(.appPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.appPrimary.opacity(0.1))

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(hotel.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(String(repeating: "\u{2605}", count: hotel.stars))
                            .foregroundColor(.yellow)
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.appPrimary)
                        Text(hotel.address)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("\u{20AC}\(Int(hotel.pricePerNight)) / Nacht")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.appPrimary)
                    }
                }
                .padding(.horizontal)

                Button(action: {}) {
                    Text("Hotel auswaehlen")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.appPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(hotel.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let trip = Trip(title: "Mallorca", startDate: Date(), endDate: Date(), destination: "Mallorca")
    NavigationStack {
        HotelView(trip: trip)
    }
}
