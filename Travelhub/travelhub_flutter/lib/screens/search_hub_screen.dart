import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'create_trip_screen.dart';

// ─────────────────────────────────────────────────────────
//  Datenmodell – Reiseziel
// ─────────────────────────────────────────────────────────

class TravelDestination {
  final String name;
  final String country;
  final String emoji; // Länderflagge
  final String category;
  final String description;
  final double rating;
  final IconData icon;
  final int priceLevel;
  final List<String> highlights;
  final Color categoryColor;
  final double latitude;
  final double longitude;
  final String imageTag; // Farbverlauf-Tag für Karten

  const TravelDestination({
    required this.name,
    required this.country,
    required this.emoji,
    required this.category,
    required this.description,
    required this.rating,
    required this.icon,
    required this.priceLevel,
    required this.highlights,
    required this.categoryColor,
    required this.latitude,
    required this.longitude,
    required this.imageTag,
  });

  String get priceLevelString => '€' * priceLevel;
  LatLng get latLng => LatLng(latitude, longitude);
}

// ─────────────────────────────────────────────────────────
//  Beispiel-Reiseziele
// ─────────────────────────────────────────────────────────

final _allDestinations = <TravelDestination>[
  TravelDestination(name: 'Mallorca', country: 'Spanien', emoji: '🇪🇸', category: 'Strand', description: 'Traumhafte Strände, malerische Buchten und lebendige Kultur auf der beliebtesten Baleareninsel.', rating: 4.5, icon: Icons.wb_sunny, priceLevel: 2, highlights: ['Drachenhöhlen', 'Palma Altstadt', 'Cap Formentor', 'Serra de Tramuntana'], categoryColor: Colors.orange, latitude: 39.6953, longitude: 3.0176, imageTag: 'beach'),
  TravelDestination(name: 'Barcelona', country: 'Spanien', emoji: '🇪🇸', category: 'Stadt', description: 'Gaudís Meisterwerke, mediterrane Küche und Strandleben in Kataloniens Hauptstadt.', rating: 4.7, icon: Icons.apartment, priceLevel: 2, highlights: ['Sagrada Familia', 'Park Güell', 'La Rambla', 'Barceloneta Strand'], categoryColor: Colors.purple, latitude: 41.3874, longitude: 2.1686, imageTag: 'city'),
  TravelDestination(name: 'Ibiza', country: 'Spanien', emoji: '🇪🇸', category: 'Insel', description: 'Weltberühmte Clubs, versteckte Buchten und wunderschöne Sonnenuntergänge.', rating: 4.3, icon: Icons.water, priceLevel: 3, highlights: ['Altstadt Dalt Vila', 'Cala Comte', 'Es Vedrà', 'Hippiemärkte'], categoryColor: Colors.cyan, latitude: 38.9067, longitude: 1.4206, imageTag: 'island'),
  TravelDestination(name: 'Rom', country: 'Italien', emoji: '🇮🇹', category: 'Kultur', description: 'Die ewige Stadt – antike Ruinen, Vatikan und die beste Pasta der Welt.', rating: 4.8, icon: Icons.theater_comedy, priceLevel: 2, highlights: ['Kolosseum', 'Vatikan', 'Trevi-Brunnen', 'Pantheon'], categoryColor: Colors.pink, latitude: 41.9028, longitude: 12.4964, imageTag: 'culture'),
  TravelDestination(name: 'Amalfiküste', country: 'Italien', emoji: '🇮🇹', category: 'Strand', description: 'Dramatische Klippen, pastellfarbene Dörfer und kristallklares Wasser.', rating: 4.6, icon: Icons.wb_sunny, priceLevel: 3, highlights: ['Positano', 'Ravello', 'Capri Bootstour', 'Limoncello Verkostung'], categoryColor: Colors.orange, latitude: 40.6340, longitude: 14.6027, imageTag: 'beach'),
  TravelDestination(name: 'Sardinien', country: 'Italien', emoji: '🇮🇹', category: 'Insel', description: 'Karibik-Feeling im Mittelmeer mit türkisfarbenem Wasser und wilder Natur.', rating: 4.4, icon: Icons.water, priceLevel: 2, highlights: ['Costa Smeralda', 'Cala Luna', 'Grotta di Nettuno', 'Nuraghen'], categoryColor: Colors.cyan, latitude: 40.1209, longitude: 9.0129, imageTag: 'island'),
  TravelDestination(name: 'Paris', country: 'Frankreich', emoji: '🇫🇷', category: 'Stadt', description: 'Die Stadt der Liebe – Eiffelturm, Louvre und die schönsten Boulevards Europas.', rating: 4.6, icon: Icons.apartment, priceLevel: 3, highlights: ['Eiffelturm', 'Louvre', 'Montmartre', 'Champs-Élysées'], categoryColor: Colors.purple, latitude: 48.8566, longitude: 2.3522, imageTag: 'city'),
  TravelDestination(name: 'Nizza', country: 'Frankreich', emoji: '🇫🇷', category: 'Strand', description: 'Glamour an der Côte d\'Azur mit Promenade, Altstadt und azurblauem Meer.', rating: 4.3, icon: Icons.wb_sunny, priceLevel: 3, highlights: ['Promenade des Anglais', 'Altstadt', 'Colline du Château', 'Matisse Museum'], categoryColor: Colors.orange, latitude: 43.7102, longitude: 7.2620, imageTag: 'beach'),
  TravelDestination(name: 'Santorini', country: 'Griechenland', emoji: '🇬🇷', category: 'Insel', description: 'Ikonische weiß-blaue Architektur und die schönsten Sonnenuntergänge der Ägäis.', rating: 4.7, icon: Icons.water, priceLevel: 3, highlights: ['Oia Sonnenuntergang', 'Red Beach', 'Akrotiri', 'Weinverkostung'], categoryColor: Colors.cyan, latitude: 36.3932, longitude: 25.4615, imageTag: 'island'),
  TravelDestination(name: 'Kreta', country: 'Griechenland', emoji: '🇬🇷', category: 'Abenteuer', description: 'Griechenlands größte Insel mit Schluchten, Stränden und antiker Geschichte.', rating: 4.5, icon: Icons.hiking, priceLevel: 1, highlights: ['Samaria-Schlucht', 'Elafonisi Strand', 'Knossos', 'Balos Lagune'], categoryColor: Colors.red, latitude: 35.2401, longitude: 24.8093, imageTag: 'adventure'),
  TravelDestination(name: 'Athen', country: 'Griechenland', emoji: '🇬🇷', category: 'Kultur', description: 'Wiege der Demokratie – Akropolis, lebendige Viertel und griechische Gastfreundschaft.', rating: 4.4, icon: Icons.theater_comedy, priceLevel: 1, highlights: ['Akropolis', 'Plaka', 'Monastiraki', 'Syntagma-Platz'], categoryColor: Colors.pink, latitude: 37.9838, longitude: 23.7275, imageTag: 'culture'),
  TravelDestination(name: 'St. Anton', country: 'Österreich', emoji: '🇦🇹', category: 'Berge', description: 'Weltklasse-Skigebiet und Wanderparadies in den Tiroler Alpen.', rating: 4.5, icon: Icons.terrain, priceLevel: 2, highlights: ['Skifahren', 'Après-Ski', 'Verwalltal Wanderung', 'Bergpanorama'], categoryColor: Colors.green, latitude: 47.1275, longitude: 10.2683, imageTag: 'mountain'),
  TravelDestination(name: 'Wien', country: 'Österreich', emoji: '🇦🇹', category: 'Kultur', description: 'Kaiserstadt mit Prachtbauten, Kaffeehauskultur und musikalischer Tradition.', rating: 4.6, icon: Icons.theater_comedy, priceLevel: 2, highlights: ['Schloss Schönbrunn', 'Stephansdom', 'Naschmarkt', 'Hofburg'], categoryColor: Colors.pink, latitude: 48.2082, longitude: 16.3738, imageTag: 'culture'),
  TravelDestination(name: 'Berlin', country: 'Deutschland', emoji: '🇩🇪', category: 'Stadt', description: 'Pulsierende Hauptstadt mit Geschichte, Kunst, Clubs und multikulturellen Vierteln.', rating: 4.4, icon: Icons.apartment, priceLevel: 1, highlights: ['Brandenburger Tor', 'East Side Gallery', 'Museumsinsel', 'Kreuzberg'], categoryColor: Colors.purple, latitude: 52.5200, longitude: 13.4050, imageTag: 'city'),
  TravelDestination(name: 'München', country: 'Deutschland', emoji: '🇩🇪', category: 'Kultur', description: 'Bayerische Gemütlichkeit, Biergärten, Alpen-Nähe und erstklassige Museen.', rating: 4.3, icon: Icons.theater_comedy, priceLevel: 2, highlights: ['Marienplatz', 'Englischer Garten', 'Oktoberfest', 'Schloss Nymphenburg'], categoryColor: Colors.pink, latitude: 48.1351, longitude: 11.5820, imageTag: 'culture'),
  TravelDestination(name: 'Dubrovnik', country: 'Kroatien', emoji: '🇭🇷', category: 'Kultur', description: 'Die Perle der Adria – mittelalterliche Stadtmauern und kristallklares Meer.', rating: 4.5, icon: Icons.theater_comedy, priceLevel: 2, highlights: ['Stadtmauer', 'Lokrum Insel', 'Stradun', 'Game of Thrones Drehorte'], categoryColor: Colors.pink, latitude: 42.6507, longitude: 18.0944, imageTag: 'culture'),
  TravelDestination(name: 'Split', country: 'Kroatien', emoji: '🇭🇷', category: 'Strand', description: 'Antiker Diokletianpalast trifft auf moderne Strandkultur an der dalmatinischen Küste.', rating: 4.3, icon: Icons.wb_sunny, priceLevel: 1, highlights: ['Diokletianpalast', 'Marjan Hügel', 'Bačvice Strand', 'Hvar Tagesausflug'], categoryColor: Colors.orange, latitude: 43.5081, longitude: 16.4402, imageTag: 'beach'),
  TravelDestination(name: 'Lissabon', country: 'Portugal', emoji: '🇵🇹', category: 'Stadt', description: 'Hügelige Stadt am Tejo mit Fado-Musik, Pastéis de Nata und bunt gekachelten Fassaden.', rating: 4.5, icon: Icons.apartment, priceLevel: 1, highlights: ['Alfama', 'Belém Tower', 'Tram 28', 'Pastéis de Belém'], categoryColor: Colors.purple, latitude: 38.7223, longitude: -9.1393, imageTag: 'city'),
  TravelDestination(name: 'Algarve', country: 'Portugal', emoji: '🇵🇹', category: 'Strand', description: 'Spektakuläre Felsformationen, goldene Strände und ganzjährig mildes Klima.', rating: 4.4, icon: Icons.wb_sunny, priceLevel: 1, highlights: ['Benagil Höhle', 'Praia da Marinha', 'Lagos', 'Silves Burg'], categoryColor: Colors.orange, latitude: 37.0179, longitude: -7.9307, imageTag: 'beach'),
  TravelDestination(name: 'Zürich', country: 'Schweiz', emoji: '🇨🇭', category: 'Berge', description: 'Kosmopolitische Stadt am See umgeben von Alpenpanorama und Schokoladenkultur.', rating: 4.5, icon: Icons.terrain, priceLevel: 3, highlights: ['Altstadt', 'Zürichsee', 'Uetliberg', 'Kunsthaus'], categoryColor: Colors.green, latitude: 47.3769, longitude: 8.5417, imageTag: 'mountain'),
];

// ─────────────────────────────────────────────────────────
//  Kategorien
// ─────────────────────────────────────────────────────────

const _categories = <(String, IconData, Color?)>[
  ('Alle', Icons.public, null),
  ('Strand', Icons.wb_sunny, Colors.orange),
  ('Stadt', Icons.apartment, Colors.purple),
  ('Berge', Icons.terrain, Colors.green),
  ('Kultur', Icons.theater_comedy, Colors.pink),
  ('Abenteuer', Icons.hiking, Colors.red),
  ('Insel', Icons.water, Colors.cyan),
];

// Gradient-Paare je Kategorie-Tag
const _gradients = <String, List<Color>>{
  'beach': [Color(0xFFF6D365), Color(0xFFFDA085)],
  'city': [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
  'island': [Color(0xFF89F7FE), Color(0xFF66A6FF)],
  'culture': [Color(0xFFF093FB), Color(0xFFF5576C)],
  'adventure': [Color(0xFF4FACFE), Color(0xFF00F2FE)],
  'mountain': [Color(0xFF43E97B), Color(0xFF38F9D7)],
};

// ═══════════════════════════════════════════════════════
//  SearchHubScreen
// ═══════════════════════════════════════════════════════

class SearchHubScreen extends StatefulWidget {
  const SearchHubScreen({super.key});

  @override
  State<SearchHubScreen> createState() => _SearchHubScreenState();
}

class _SearchHubScreenState extends State<SearchHubScreen>
    with TickerProviderStateMixin {
  String _search = '';
  String? _selectedCategory;
  bool _showMap = true;
  TravelDestination? _selectedDestination;

  final MapController _mapController = MapController();
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  static const _initialCenter = LatLng(46.0, 10.0);
  static const _initialZoom = 4.2;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_pulseCtrl);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  List<TravelDestination> get _filtered {
    var list = _allDestinations.toList();
    if (_selectedCategory != null) {
      list = list.where((d) => d.category == _selectedCategory).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list
          .where((d) =>
              d.name.toLowerCase().contains(q) ||
              d.country.toLowerCase().contains(q) ||
              d.category.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void _selectDestination(TravelDestination d) {
    setState(() => _selectedDestination = d);
    _mapController.move(d.latLng, 8.0);
  }

  void _resetMap() {
    setState(() => _selectedDestination = null);
    _mapController.move(_initialCenter, _initialZoom);
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Premium Header ──
          _buildHeader(),

          // ── Kategorie-Chips ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final (label, icon, color) = _categories[i];
                  final sel =
                      (label == 'Alle' && _selectedCategory == null) ||
                          label == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedCategory = label == 'Alle' ? null : label;
                      _selectedDestination = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: sel
                            ? LinearGradient(colors: [
                                color ?? AppColors.primary,
                                (color ?? AppColors.primary)
                                    .withValues(alpha: 0.7),
                              ])
                            : null,
                        color: sel ? null : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: sel
                            ? [
                                BoxShadow(
                                    color: (color ?? AppColors.primary)
                                        .withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon,
                              size: 14,
                              color: sel ? Colors.white : Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(label,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: sel
                                      ? Colors.white
                                      : Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Hauptinhalt ──
          Expanded(
            child: _showMap ? _buildMapView(results) : _buildListView(results),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HEADER mit Suchleiste
  // ═══════════════════════════════════════════════════════

  Widget _buildHeader() {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, top + 12, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // Titel-Zeile
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF67B8DE)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.explore, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entdecken',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                    Text('Finde dein nächstes Abenteuer',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              _HeaderIconBtn(
                icon: _showMap ? Icons.view_list_rounded : Icons.map_rounded,
                onTap: () => setState(() => _showMap = !_showMap),
              ),
              const SizedBox(width: 8),
              if (_showMap)
                _HeaderIconBtn(
                  icon: Icons.my_location_rounded,
                  onTap: _resetMap,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Suchfeld
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TextField(
              onChanged: (v) => setState(() {
                _search = v;
                _selectedDestination = null;
              }),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Stadt, Land oder Kategorie suchen …',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon:
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close,
                            color: Colors.grey.shade400, size: 18),
                        onPressed: () => setState(() => _search = ''))
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  KARTE  –  CartoDB Voyager (schöner Stil)
  // ═══════════════════════════════════════════════════════

  Widget _buildMapView(List<TravelDestination> results) {
    return Stack(
      children: [
        // ── Die Karte ──
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialCenter,
            initialZoom: _initialZoom,
            minZoom: 3,
            maxZoom: 18,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onTap: (_, __) {
              if (_selectedDestination != null) {
                setState(() => _selectedDestination = null);
              }
            },
          ),
          children: [
            // ── CartoDB Voyager – schöner, moderner Kartenstil ──
            TileLayer(
              urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.travelhub.app',
              maxZoom: 18,
              retinaMode: true,
            ),

            // Marker
            MarkerLayer(
              markers: results.map((d) {
                final isSelected = _selectedDestination?.name == d.name;
                return Marker(
                  point: d.latLng,
                  width: isSelected ? 120 : 48,
                  height: isSelected ? 70 : 48,
                  child: GestureDetector(
                    onTap: () => _selectDestination(d),
                    child: AnimatedBuilder2(
                      listenable: _pulseAnim,
                      builder: (ctx, child) => _PremiumPin(
                        destination: d,
                        isSelected: isSelected,
                        pulse: isSelected ? _pulseAnim.value : 1.0,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // ── Gradient Overlay oben ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 40,
          child: IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x30FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
        ),

        // ── Glaseffekt-Legende ──
        Positioned(
          right: 12,
          top: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.layers, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('Legende',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    for (final (label, icon, color) in _categories)
                      if (color != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.5),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(icon, size: 11, color: color),
                              ),
                              const SizedBox(width: 6),
                              Text(label,
                                  style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── Ergebnis-Badge unten links ──
        Positioned(
          left: 12,
          bottom: _selectedDestination != null ? 200 : 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.place, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('${results.length} Ziele',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ── OSM-Attribution ──
        Positioned(
          right: 12,
          bottom: _selectedDestination != null ? 200 : 160,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text('© OpenStreetMap · CartoDB',
                style: TextStyle(fontSize: 8, color: Colors.grey)),
          ),
        ),

        // ── Bottom Card Carousel ──
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _selectedDestination != null
              ? _SelectedCard(
                  destination: _selectedDestination!,
                  onClose: () =>
                      setState(() => _selectedDestination = null),
                  onDetail: () => _showDetail(_selectedDestination!),
                  onTrip: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CreateTripScreen(
                                initialDestination:
                                    _selectedDestination!.name)));
                  },
                )
              : _DestinationCarousel(
                  destinations: results,
                  onTap: _selectDestination,
                ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════
  //  LISTENANSICHT – Karten mit Gradient-Header
  // ═══════════════════════════════════════════════════════

  Widget _buildListView(List<TravelDestination> results) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (ctx, i) => _ListCard(
        destination: results[i],
        onTap: () => _showDetail(results[i]),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  DETAIL BOTTOM SHEET
  // ═══════════════════════════════════════════════════════

  void _showDetail(TravelDestination d) {
    final grad = _gradients[d.imageTag] ?? [AppColors.primary, AppColors.secondary];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.94,
        expand: false,
        builder: (ctx, scroll) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Gradient Hero Header ──
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: grad,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Stack(
                    children: [
                      // Pattern overlay
                      Positioned.fill(
                        child: CustomPaint(painter: _DotPatternPainter()),
                      ),
                      // Handle
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                            child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.5),
                                    borderRadius:
                                        BorderRadius.circular(2)))),
                      ),
                      // Emoji groß
                      Center(
                        child: Text(d.emoji,
                            style: const TextStyle(fontSize: 60)),
                      ),
                      // Kategorie Pill
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(d.icon, size: 13, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(d.category,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      // Name overlay unten
                      Positioned(
                        left: 20,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(d.name,
                                style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                            Text('${d.emoji}  ${d.country}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white
                                        .withValues(alpha: 0.85))),
                          ],
                        ),
                      ),
                      // Rating badge
                      Positioned(
                        right: 20,
                        bottom: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  size: 15, color: Colors.amber),
                              const SizedBox(width: 3),
                              Text(d.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Preis + Koordinaten
                      Row(
                        children: [
                          _InfoChip(Icons.euro, d.priceLevelString, AppColors.primary),
                          const SizedBox(width: 8),
                          _InfoChip(
                              Icons.location_on,
                              '${d.latitude.toStringAsFixed(2)}°N, ${d.longitude.abs().toStringAsFixed(2)}°${d.longitude >= 0 ? 'O' : 'W'}',
                              Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Mini-Karte
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 150,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: d.latLng,
                              initialZoom: 10,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                                subdomains: const ['a', 'b', 'c', 'd'],
                                userAgentPackageName: 'com.travelhub.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: d.latLng,
                                    width: 44,
                                    height: 44,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: d.categoryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                              color: d.categoryColor
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 10)
                                        ],
                                      ),
                                      child: Icon(d.icon,
                                          color: Colors.white, size: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Beschreibung
                      Text(d.description,
                          style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Color(0xFF5A6A7A))),
                      const SizedBox(height: 20),

                      // Highlights
                      const Text('Highlights',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 10),
                      ...d.highlights.map((h) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    gradient:
                                        LinearGradient(colors: grad),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.check,
                                      color: Colors.white, size: 14),
                                ),
                                const SizedBox(width: 10),
                                Text(h,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )),
                      const SizedBox(height: 20),

                      // CTA
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: grad),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                  color: grad.first.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4))
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => CreateTripScreen(
                                          initialDestination: d.name)));
                            },
                            icon: const Icon(Icons.flight_takeoff,
                                color: Colors.white),
                            label: Text('Reise nach ${d.name} planen',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Premium Map Pin
// ═══════════════════════════════════════════════════════════

class _PremiumPin extends StatelessWidget {
  final TravelDestination destination;
  final bool isSelected;
  final double pulse;

  const _PremiumPin({
    required this.destination,
    required this.isSelected,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final d = destination;

    if (isSelected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name Label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(d.emoji, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(d.name,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Pin mit Puls
          Transform.scale(
            scale: pulse,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _gradients[d.imageTag] ??
                      [d.categoryColor, d.categoryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: d.categoryColor.withValues(alpha: 0.5),
                    blurRadius: 14,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Icon(d.icon, color: Colors.white, size: 18),
            ),
          ),
        ],
      );
    }

    // Nicht ausgewählt – kleiner Pin
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              _gradients[d.imageTag] ?? [d.categoryColor, d.categoryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(d.emoji, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Destination Carousel (Bottom)
// ═══════════════════════════════════════════════════════════

class _DestinationCarousel extends StatelessWidget {
  final List<TravelDestination> destinations;
  final ValueChanged<TravelDestination> onTap;

  const _DestinationCarousel(
      {required this.destinations, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00F0F4F8), Color(0xFFF0F4F8)],
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        itemCount: destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final d = destinations[i];
          final grad =
              _gradients[d.imageTag] ?? [AppColors.primary, AppColors.secondary];
          return GestureDetector(
            onTap: () => onTap(d),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient-Strip
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: grad),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(d.emoji,
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(d.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(d.country,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    d.categoryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(d.icon,
                                      size: 10, color: d.categoryColor),
                                  const SizedBox(width: 3),
                                  Text(d.category,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: d.categoryColor)),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.star,
                                size: 12, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(d.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 6),
                            Text(d.priceLevelString,
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Selected Card
// ═══════════════════════════════════════════════════════════

class _SelectedCard extends StatelessWidget {
  final TravelDestination destination;
  final VoidCallback onClose;
  final VoidCallback onDetail;
  final VoidCallback onTrip;

  const _SelectedCard({
    required this.destination,
    required this.onClose,
    required this.onDetail,
    required this.onTrip,
  });

  @override
  Widget build(BuildContext context) {
    final d = destination;
    final grad =
        _gradients[d.imageTag] ?? [AppColors.primary, AppColors.secondary];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient top
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: grad),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(d.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(d.country,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: d.categoryColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(d.category,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: d.categoryColor)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.star,
                              size: 15, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(d.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                        ]),
                        Text(d.priceLevelString,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary)),
                      ],
                    ),
                    IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: onClose),
                  ],
                ),
                const SizedBox(height: 6),
                Text(d.description,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onDetail,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Details'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: grad),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: grad.first.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: onTrip,
                          icon: const Icon(Icons.flight_takeoff,
                              size: 16, color: Colors.white),
                          label: const Text('Reise planen',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 13)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  List Card (für Listenansicht)
// ═══════════════════════════════════════════════════════════

class _ListCard extends StatelessWidget {
  final TravelDestination destination;
  final VoidCallback onTap;

  const _ListCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final d = destination;
    final grad =
        _gradients[d.imageTag] ?? [AppColors.primary, AppColors.secondary];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            // Gradient-Side + Emoji
            Container(
              width: 72,
              height: 82,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: grad,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(18)),
              ),
              child: Center(
                child:
                    Text(d.emoji, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text('${d.country} · ${d.category}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 2),
                    Text(d.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ]),
                  const SizedBox(height: 4),
                  Text(d.priceLevelString,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Header Icon Button
// ═══════════════════════════════════════════════════════════

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 18, color: Colors.grey.shade600),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Info Chip (Detail Sheet)
// ═══════════════════════════════════════════════════════════

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip(this.icon, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Dot Pattern Painter (Detail-Sheet Header Dekoration)
// ═══════════════════════════════════════════════════════════

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════
//  AnimatedBuilder2 Helper (flutter_map Marker rebuild)
// ═══════════════════════════════════════════════════════════

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
