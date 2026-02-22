import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/star_rating.dart';

/// Hotel-Screen mit Favoriten, Vergleich, Buchungsstatus, Ausstattungs-Filter & Detailansicht
class HotelScreen extends StatefulWidget {
  final String tripId;
  const HotelScreen({super.key, required this.tripId});

  @override
  State<HotelScreen> createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  String _selectedRegion = 'Palma';
  final _regions = ['Palma', 'Alcudia', "Cala d'Or", 'Soller'];
  String _sortBy = 'Preis';
  Set<String> _selectedAmenities = {};
  final _amenityOptions = ['Pool', 'WLAN', 'Frühstück', 'Meerblick', 'Fitness', 'Spa', 'Parken', 'Klimaanlage'];

  final List<_Hotel> _hotels = [
    _Hotel(name: 'Hotel Playa Sol', stars: 4, address: 'Paseo Marítimo 12, Palma', region: 'Palma', pricePerNight: 120, icon: Icons.apartment, amenities: ['Pool', 'WLAN', 'Frühstück', 'Meerblick', 'Klimaanlage'], rating: 4.5, reviews: 234, description: 'Direkt am Meer gelegen mit herrlichem Blick auf die Bucht von Palma.'),
    _Hotel(name: 'Boutique Hotel Altstadt', stars: 3, address: 'Carrer Sant Jaume 5, Palma', region: 'Palma', pricePerNight: 85, icon: Icons.business, amenities: ['WLAN', 'Frühstück', 'Klimaanlage'], rating: 4.2, reviews: 156, description: 'Charmantes Boutique-Hotel im historischen Zentrum.'),
    _Hotel(name: 'Grand Resort & Spa', stars: 5, address: 'Avinguda Gabriel Roca 1, Palma', region: 'Palma', pricePerNight: 220, icon: Icons.domain, amenities: ['Pool', 'WLAN', 'Frühstück', 'Meerblick', 'Fitness', 'Spa', 'Parken', 'Klimaanlage'], rating: 4.8, reviews: 512, description: 'Luxuriöses 5-Sterne-Resort mit Full-Service Spa und mehreren Restaurants.'),
    _Hotel(name: 'Strandhotel Mallorca', stars: 3, address: 'Playa de Palma 22, Palma', region: 'Palma', pricePerNight: 95, icon: Icons.beach_access, amenities: ['Pool', 'WLAN', 'Klimaanlage', 'Meerblick'], rating: 3.9, reviews: 89, description: 'Entspanntes Strandhotel mit direktem Strandzugang.'),
    _Hotel(name: 'Hotel Port Alcudia', stars: 4, address: 'Av. Pere Mas 8, Alcudia', region: 'Alcudia', pricePerNight: 145, icon: Icons.apartment, amenities: ['Pool', 'WLAN', 'Frühstück', 'Fitness', 'Parken'], rating: 4.3, reviews: 198, description: 'Familienfreundliches Hotel nahe dem schönen Strand von Alcudia.'),
    _Hotel(name: 'Finca Rural Soller', stars: 4, address: 'Camí de Son Sales, Soller', region: 'Soller', pricePerNight: 175, icon: Icons.cottage, amenities: ['Pool', 'WLAN', 'Frühstück', 'Parken'], rating: 4.7, reviews: 67, description: 'Wunderschöne Finca mit Orangenhainen und Tramuntana-Blick.'),
    _Hotel(name: "Cala d'Or Beach Hotel", stars: 3, address: "Av. Cala Llonga, Cala d'Or", region: "Cala d'Or", pricePerNight: 110, icon: Icons.beach_access, amenities: ['Pool', 'WLAN', 'Klimaanlage', 'Meerblick'], rating: 4.0, reviews: 122, description: 'Entspanntes Hotel in einer der schönsten Buchten Mallorcas.'),
  ];

  List<_Hotel> get _filtered {
    var result = _hotels.where((h) => h.region == _selectedRegion).toList();
    if (_selectedAmenities.isNotEmpty) {
      result = result.where((h) => _selectedAmenities.every((a) => h.amenities.contains(a))).toList();
    }
    switch (_sortBy) {
      case 'Preis': result.sort((a, b) => a.pricePerNight.compareTo(b.pricePerNight));
      case 'Bewertung': result.sort((a, b) => b.rating.compareTo(a.rating));
      case 'Sterne': result.sort((a, b) => b.stars.compareTo(a.stars));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotelvorschläge', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list, color: Colors.white), onPressed: _showFilterSheet),
          IconButton(
            icon: Badge(
              label: Text('${_hotels.where((h) => h.isFavorite).length}'),
              isLabelVisible: _hotels.any((h) => h.isFavorite),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
            onPressed: _showFavorites,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Region & Sort
          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.cardBackground,
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                      child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                        isExpanded: true, value: _selectedRegion,
                        items: _regions.map((r) => DropdownMenuItem(value: r, child: Row(children: [const Icon(Icons.location_on, size: 16, color: Color(0xFFAB47BC)), const SizedBox(width: 6), Text(r)]))).toList(),
                        onChanged: (v) { if (v != null) setState(() => _selectedRegion = v); },
                      )),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                      value: _sortBy,
                      items: ['Preis', 'Bewertung', 'Sterne'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13)))).toList(),
                      onChanged: (v) { if (v != null) setState(() => _sortBy = v); },
                    )),
                  ),
                ]),
                if (_selectedAmenities.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 28,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _selectedAmenities.map((a) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Chip(
                          label: Text(a, style: const TextStyle(fontSize: 11)),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => setState(() => _selectedAmenities.remove(a)),
                          backgroundColor: const Color(0xFFAB47BC).withOpacity(0.1),
                          labelPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text('${_filtered.length} Hotels gefunden', style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text('Keine Hotels mit diesen Filtern', style: TextStyle(fontWeight: FontWeight.w600)),
                    TextButton(onPressed: () => setState(() => _selectedAmenities.clear()), child: const Text('Filter zurücksetzen')),
                  ]))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) => _hotelCard(_filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _hotelCard(_Hotel hotel) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetail(hotel),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
          child: Column(
            children: [
              Row(children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [const Color(0xFFAB47BC).withOpacity(0.15), const Color(0xFFCE93D8).withOpacity(0.1)]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(hotel.icon, color: const Color(0xFFAB47BC), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(hotel.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                    GestureDetector(
                      onTap: () => setState(() => hotel.isFavorite = !hotel.isFavorite),
                      child: Icon(hotel.isFavorite ? Icons.favorite : Icons.favorite_border, color: hotel.isFavorite ? Colors.red : Colors.grey, size: 20),
                    ),
                  ]),
                  Row(children: [
                    Text('★' * hotel.stars, style: const TextStyle(color: Colors.amber, fontSize: 12)),
                    const SizedBox(width: 6),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text('${hotel.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green))),
                    const SizedBox(width: 4),
                    Text('(${hotel.reviews})', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ]),
                  const SizedBox(height: 2),
                  Text(hotel.address, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ])),
              ]),
              const SizedBox(height: 10),
              // Amenity chips
              SizedBox(
                height: 24,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: hotel.amenities.take(5).map((a) => Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                    child: Text(_amenityEmoji(a), style: const TextStyle(fontSize: 11)),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Row(children: [
                if (hotel.isBooked)
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_circle, size: 14, color: Colors.green), SizedBox(width: 4), Text('Gebucht', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600))]))
                else
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Verfügbar', style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600))),
                const Spacer(),
                Text('€${hotel.pricePerNight.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFAB47BC), fontSize: 18)),
                Text(' / Nacht', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  String _amenityEmoji(String a) {
    switch (a) {
      case 'Pool': return '🏊 Pool';
      case 'WLAN': return '📶 WLAN';
      case 'Frühstück': return '🥐 Frühstück';
      case 'Meerblick': return '🌊 Meerblick';
      case 'Fitness': return '🏋️ Fitness';
      case 'Spa': return '💆 Spa';
      case 'Parken': return '🅿️ Parken';
      case 'Klimaanlage': return '❄️ Klima';
      default: return a;
    }
  }

  void _showDetail(_Hotel hotel) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _HotelDetailPage(hotel: hotel, onBook: () => setState(() {}))));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => SafeArea(child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Ausstattung filtern', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: _amenityOptions.map((a) {
              final sel = _selectedAmenities.contains(a);
              return FilterChip(
                label: Text(_amenityEmoji(a)),
                selected: sel,
                selectedColor: const Color(0xFFAB47BC).withOpacity(0.15),
                checkmarkColor: const Color(0xFFAB47BC),
                onSelected: (v) { setSheet(() => v ? _selectedAmenities.add(a) : _selectedAmenities.remove(a)); setState(() {}); },
              );
            }).toList()),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Anwenden'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFAB47BC)))),
          ]),
        )),
      ),
    );
  }

  void _showFavorites() {
    final favorites = _hotels.where((h) => h.isFavorite).toList();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('❤️ Favoriten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (favorites.isEmpty) const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Center(child: Text('Keine Favoriten gespeichert', style: TextStyle(color: Colors.grey))))
          else ...favorites.map((h) => ListTile(
            leading: Icon(h.icon, color: const Color(0xFFAB47BC)),
            title: Text(h.name),
            subtitle: Text('€${h.pricePerNight.toInt()} / Nacht'),
            trailing: Text('★ ${h.rating}', style: const TextStyle(color: Colors.amber)),
            onTap: () { Navigator.pop(ctx); _showDetail(h); },
          )),
        ]),
      )),
    );
  }
}

class _HotelDetailPage extends StatefulWidget {
  final _Hotel hotel;
  final VoidCallback onBook;
  const _HotelDetailPage({required this.hotel, required this.onBook});

  @override
  State<_HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<_HotelDetailPage> {
  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
    return Scaffold(
      appBar: AppBar(
        title: Text(hotel.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFAB47BC), Color(0xFFCE93D8)], begin: Alignment.topLeft, end: Alignment.bottomRight))),
        actions: [
          IconButton(
            icon: Icon(hotel.isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () => setState(() { hotel.isFavorite = !hotel.isFavorite; widget.onBook(); }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Photo placeholder
          Container(
            width: double.infinity, height: 200,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFFAB47BC).withOpacity(0.15), const Color(0xFFCE93D8).withOpacity(0.08)])),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(hotel.icon, size: 60, color: const Color(0xFFAB47BC)),
              const SizedBox(height: 8),
              Text('★' * hotel.stars, style: const TextStyle(color: Colors.amber, fontSize: 20)),
            ]),
          ),
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Name & Rating
            Text(hotel.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.location_on, color: Color(0xFFAB47BC), size: 16),
              const SizedBox(width: 4),
              Text(hotel.address, style: TextStyle(color: Colors.grey.shade600)),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.star, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Text('${hotel.rating}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ])),
              const SizedBox(width: 8),
              Text('${hotel.reviews} Bewertungen', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            ]),
            const SizedBox(height: 16),
            // Description
            const Text('Beschreibung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(hotel.description, style: TextStyle(color: Colors.grey.shade700, height: 1.5)),
            const SizedBox(height: 16),
            // Amenities
            const Text('Ausstattung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: hotel.amenities.map((a) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFAB47BC).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Text(_amenityEmoji(a), style: const TextStyle(fontSize: 13)),
            )).toList()),
            const SizedBox(height: 16),
            // Price & nights calculator
            const Text('Preisrechner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                _priceRow('1 Nacht', '€${hotel.pricePerNight.toInt()}'),
                _priceRow('3 Nächte', '€${(hotel.pricePerNight * 3).toInt()}'),
                _priceRow('7 Nächte', '€${(hotel.pricePerNight * 7).toInt()}'),
                const Divider(),
                _priceRow('Pro Person (4 Pers.)', '€${(hotel.pricePerNight * 7 / 4).toInt()} / Woche', bold: true),
              ]),
            ),
            const SizedBox(height: 20),
            // Book / Unbook button
            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: () {
                setState(() => hotel.isBooked = !hotel.isBooked);
                widget.onBook();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(hotel.isBooked ? '✓ Hotel gebucht!' : 'Buchung storniert'),
                  backgroundColor: hotel.isBooked ? Colors.green : Colors.red,
                ));
              },
              icon: Icon(hotel.isBooked ? Icons.cancel : Icons.check_circle),
              label: Text(hotel.isBooked ? 'Buchung stornieren' : 'Hotel buchen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: hotel.isBooked ? Colors.red : const Color(0xFFAB47BC),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )),
          ])),
        ]),
      ),
    );
  }

  Widget _priceRow(String label, String price, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
      const Spacer(),
      Text(price, style: TextStyle(fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.w500, color: bold ? const Color(0xFFAB47BC) : null)),
    ]),
  );

  String _amenityEmoji(String a) {
    switch (a) {
      case 'Pool': return '🏊 Pool';
      case 'WLAN': return '📶 WLAN';
      case 'Frühstück': return '🥐 Frühstück';
      case 'Meerblick': return '🌊 Meerblick';
      case 'Fitness': return '🏋️ Fitness';
      case 'Spa': return '💆 Spa';
      case 'Parken': return '🅿️ Parken';
      case 'Klimaanlage': return '❄️ Klima';
      default: return a;
    }
  }
}

class _Hotel {
  final String name, address, region, description;
  final int stars, reviews;
  final double pricePerNight, rating;
  final IconData icon;
  final List<String> amenities;
  bool isFavorite, isBooked;

  _Hotel({
    required this.name, required this.stars, required this.address, required this.region,
    required this.pricePerNight, required this.icon, required this.amenities,
    required this.rating, required this.reviews, required this.description,
    this.isFavorite = false, this.isBooked = false,
  });
}
