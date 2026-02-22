import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reisetipps – interaktive Tipps mit Kategorien, Bookmarks, Detail-Ansicht und eigenen Tipps
class TravelTipsScreen extends StatefulWidget {
  final String tripId;
  const TravelTipsScreen({super.key, required this.tripId});

  @override
  State<TravelTipsScreen> createState() => _TravelTipsScreenState();
}

class _TravelTipsScreenState extends State<TravelTipsScreen> {
  String _selectedCategory = 'Alle';
  String _searchQuery = '';
  final List<_TravelTip> _tips = _defaultTips();

  static List<_TravelTip> _defaultTips() => [
    _TravelTip(
      emoji: '📋', title: 'Dokumente digitalisieren',
      summary: 'Scanne alle wichtigen Dokumente und speichere sie in der Cloud.',
      detail: 'Erstelle digitale Kopien von Reisepass, Personalausweis, Versicherungsnachweisen, Buchungsbestätigungen und Impfpass. '
          'Speichere sie in einer Cloud (z.B. Google Drive, iCloud) und teile den Ordner mit deiner Reisegruppe. '
          'Tipp: Auch eine physische Kopie im Koffer kann helfen!',
      category: 'Vorbereitung', upvotes: 42,
    ),
    _TravelTip(
      emoji: '💳', title: 'Kreditkarte ohne Auslandsgebühr',
      summary: 'Spare Geld mit der richtigen Reisekreditkarte.',
      detail: 'Viele Banken bieten kostenlose Kreditkarten mit 0 % Auslandsgebühr an. '
          'Beliebte Optionen: DKB Visa, Barclays Visa, N26 Metal. '
          'Informiere deine Bank vor der Reise über dein Reiseziel, damit die Karte nicht gesperrt wird. '
          'Tipp: Immer in Landeswährung bezahlen, nicht in Euro!',
      category: 'Finanzen', upvotes: 38,
    ),
    _TravelTip(
      emoji: '🎒', title: 'Packen wie ein Profi',
      summary: 'Rolling-Technik spart bis zu 30 % Platz im Koffer.',
      detail: 'Rolle deine Kleidung statt sie zu falten – das spart Platz und vermeidet Knitterfalten. '
          'Nutze Packwürfel (Packing Cubes) für mehr Ordnung. '
          'Schuhe in Duschhaube verpacken, um andere Kleidung sauber zu halten. '
          'Schwere Sachen unten, leichte oben. '
          'Tipp: Teste ob alles passt 2 Tage vor Abflug!',
      category: 'Vorbereitung', upvotes: 55,
    ),
    _TravelTip(
      emoji: '📱', title: 'Offline-Karten herunterladen',
      summary: 'Google Maps und Maps.me bieten Offline-Karten für jedes Ziel.',
      detail: 'Lade vor der Reise die Karten deines Reiseziels herunter. '
          'Google Maps: Karte anzeigen → "Offlinekarte herunterladen". '
          'Maps.me ist komplett offline nutzbar und zeigt auch Wanderwege. '
          'Tipp: WLAN-Karten von Cafés und Hotels vorher auf OpenStreetMap markieren.',
      category: 'Technik', upvotes: 47,
    ),
    _TravelTip(
      emoji: '🏥', title: 'Reiseapotheke zusammenstellen',
      summary: 'Die wichtigsten Medikamente gehören ins Handgepäck.',
      detail: 'Packe immer ein: Schmerztabletten, Pflaster, Sonnencreme (30+), Mückenschutz, '
          'Durchfalltabletten, Elektrolyte, Desinfektionsmittel, Fieberthermometer. '
          'Bei Fernreisen: Malaria-Prophylaxe mit Arzt besprechen. '
          'Tipp: Medikamente immer im Handgepäck – Koffer können verloren gehen!',
      category: 'Gesundheit', upvotes: 33,
    ),
    _TravelTip(
      emoji: '🔌', title: 'Universaladapter besorgen',
      summary: 'Ein guter Adapter deckt über 150 Länder ab.',
      detail: 'Investiere in einen hochwertigen Universaladapter mit USB-Ports. '
          'Prüfe vorher die Steckdosen-Typen deines Reiselandes (Typ C/F in Europa, Typ G in UK, Typ A/B in USA). '
          'Tipp: Ein Adapter mit integriertem USB-C ist perfekt für Handy, Tablet und Laptop gleichzeitig.',
      category: 'Technik', upvotes: 29,
    ),
    _TravelTip(
      emoji: '💡', title: 'Lokale SIM-Karte kaufen',
      summary: 'Oft günstiger als Roaming – und schnelleres Internet.',
      detail: 'In vielen Ländern kosten lokale SIM-Karten nur 5-10 € mit viel Datenvolumen. '
          'Alternative: eSIM-Anbieter wie Airalo oder Holafly. '
          'In der EU gilt Roaming-Verordnung – dein Tarif gilt wie zu Hause. '
          'Tipp: Vor dem Kauf Handy-Simlock prüfen!',
      category: 'Technik', upvotes: 36,
    ),
    _TravelTip(
      emoji: '🍽️', title: 'Street Food ausprobieren',
      summary: 'Das beste Essen findest du oft an der Straße, nicht im Restaurant.',
      detail: 'Orientiere dich an Einheimischen: Wo die meisten Leute anstehen, ist es gut und sicher. '
          'Achte auf frische Zubereitung und heißes Essen. '
          'Vermeide rohes Obst und Gemüse in Ländern mit unsicherem Wasser. '
          'Tipp: Frage dein Hotel nach den besten Street-Food-Märkten!',
      category: 'Vor Ort', upvotes: 41,
    ),
    _TravelTip(
      emoji: '🛡️', title: 'Wertsachen sichern',
      summary: 'Teile dein Geld und deine Dokumente immer auf.',
      detail: 'Verteile Geld und Karten auf verschiedene Taschen (Hosentasche, Geldgürtel, Koffer). '
          'Nutze ein TSA-Schloss für den Koffer. '
          'Trage Rucksäcke in Menschenmengen nach vorne. '
          'Hotel-Safe für Pass und größere Geldbeträge. '
          'Tipp: Foto von allen wichtigen Nummern auf dem Handy speichern!',
      category: 'Sicherheit', upvotes: 44,
    ),
    _TravelTip(
      emoji: '🧘', title: 'Jetlag bekämpfen',
      summary: 'Mit einfachen Tricks schneller akklimatisieren.',
      detail: 'Bereits 2-3 Tage vor Abflug die Schlafenszeit anpassen. '
          'Im Flugzeug viel Wasser trinken, Alkohol und Koffein vermeiden. '
          'Am Zielort sofort nach Ortszeit leben und Tageslicht suchen. '
          'Leichtes Essen in den ersten Tagen. '
          'Tipp: Melatonin kann helfen – aber vorher mit Arzt besprechen.',
      category: 'Gesundheit', upvotes: 27,
    ),
    _TravelTip(
      emoji: '📸', title: 'Golden Hour nutzen',
      summary: 'Die besten Fotos entstehen in der Stunde nach Sonnenaufgang oder vor Sonnenuntergang.',
      detail: 'Die "Golden Hour" bietet weiches, warmes Licht das perfekt für Landschafts- und Porträtfotos ist. '
          'Nutze Apps wie "Golden Hour" oder "Sun Surveyor" um die genauen Zeiten zu finden. '
          'Tipp: Auch die "Blue Hour" (kurz vor Sonnenaufgang/nach -untergang) ergibt magische Bilder!',
      category: 'Vor Ort', upvotes: 35,
    ),
    _TravelTip(
      emoji: '✈️', title: 'Flug-Hacks',
      summary: 'Flexibilität bei Daten und Flughäfen spart bis zu 40 %.',
      detail: 'Buche Flüge am Dienstag/Mittwoch – oft am günstigsten. '
          'Nutze Vergleichsseiten wie Skyscanner mit flexiblen Daten. '
          'Prüfe alternative Flughäfen in der Nähe. '
          'Inkognito-Modus im Browser verhindert Preis-Tracking. '
          'Tipp: Gabelflüge (Open-Jaw) sind oft günstiger als Hin und Rück zum selben Ort.',
      category: 'Finanzen', upvotes: 51,
    ),
  ];

  final _categories = const ['Alle', 'Vorbereitung', 'Technik', 'Finanzen', 'Gesundheit', 'Sicherheit', 'Vor Ort'];

  List<_TravelTip> get _filtered {
    var tips = _tips.toList();
    if (_selectedCategory != 'Alle') tips = tips.where((t) => t.category == _selectedCategory).toList();
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      tips = tips.where((t) => t.title.toLowerCase().contains(q) || t.summary.toLowerCase().contains(q) || t.category.toLowerCase().contains(q)).toList();
    }
    tips.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    return tips;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final bookmarked = _tips.where((t) => t.bookmarked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reisetipps', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFA726), Color(0xFFFFB74D)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        )),
        foregroundColor: Colors.white,
        actions: [
          if (bookmarked > 0) TextButton.icon(
            onPressed: _showBookmarked,
            icon: const Icon(Icons.bookmark, color: Colors.white, size: 18),
            label: Text('$bookmarked', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(children: [
        // Search
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: 'Tipps durchsuchen…', prefixIcon: const Icon(Icons.search, size: 20),
              filled: true, fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),

        // Category chips
        SizedBox(height: 40, child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (ctx, i) {
            final cat = _categories[i];
            final selected = cat == _selectedCategory;
            return ChoiceChip(
              label: Text(cat, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.text, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
              selected: selected, showCheckmark: false,
              selectedColor: const Color(0xFFFFA726),
              backgroundColor: AppColors.cardBackground,
              onSelected: (_) => setState(() => _selectedCategory = cat),
            );
          },
        )),
        const SizedBox(height: 8),

        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            Text('${filtered.length} Tipps', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text('👍 ${_tips.fold<int>(0, (s, t) => s + t.upvotes)} Bewertungen', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ]),
        ),
        const SizedBox(height: 8),

        // Tip list
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🔍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text('Keine Tipps gefunden', style: TextStyle(color: Colors.grey.shade600)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, i) => _buildTipCard(filtered[i]),
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCustomTip,
        backgroundColor: const Color(0xFFFFA726),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tipp hinzufügen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTipCard(_TravelTip tip) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showTipDetail(tip),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: const Color(0xFFFFA726).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(tip.emoji, style: const TextStyle(fontSize: 20))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tip.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: _categoryColor(tip.category).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                child: Text(tip.category, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _categoryColor(tip.category))),
              ),
            ])),
            // Bookmark
            GestureDetector(
              onTap: () => setState(() => tip.bookmarked = !tip.bookmarked),
              child: Icon(tip.bookmarked ? Icons.bookmark : Icons.bookmark_border, color: tip.bookmarked ? const Color(0xFFFFA726) : Colors.grey, size: 22),
            ),
          ]),
          const SizedBox(height: 10),
          Text(tip.summary, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          const SizedBox(height: 10),
          Row(children: [
            // Upvote
            GestureDetector(
              onTap: () => setState(() => tip.upvoted ? (tip.upvoted = false, tip.upvotes--) : (tip.upvoted = true, tip.upvotes++)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: tip.upvoted ? Colors.green.withOpacity(0.12) : Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.thumb_up, size: 14, color: tip.upvoted ? Colors.green : Colors.grey),
                  const SizedBox(width: 4),
                  Text('${tip.upvotes}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: tip.upvoted ? Colors.green : Colors.grey)),
                ]),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 16, color: Colors.grey.shade400),
            Text('Details lesen', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
            const Spacer(),
            if (tip.isCustom) Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: const Text('Eigener Tipp', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.w500)),
            ),
          ]),
        ]),
      ),
    ),
  );

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Vorbereitung': return const Color(0xFF4A90D9);
      case 'Technik': return const Color(0xFF5C6BC0);
      case 'Finanzen': return const Color(0xFF66BB6A);
      case 'Gesundheit': return const Color(0xFFEF5350);
      case 'Sicherheit': return const Color(0xFFFF7043);
      case 'Vor Ort': return const Color(0xFF26A69A);
      default: return Colors.grey;
    }
  }

  void _showTipDetail(_TravelTip tip) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false, initialChildSize: 0.6, maxChildSize: 0.9,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Center(child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(color: _categoryColor(tip.category).withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
              child: Center(child: Text(tip.emoji, style: const TextStyle(fontSize: 32))),
            )),
            const SizedBox(height: 12),
            Center(child: Text(tip.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
            const SizedBox(height: 4),
            Center(child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _categoryColor(tip.category).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(tip.category, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _categoryColor(tip.category))),
            )),
            const SizedBox(height: 16),
            Text(tip.summary, style: TextStyle(fontSize: 14, color: Colors.grey.shade700, fontStyle: FontStyle.italic)),
            const Divider(height: 24),
            Text(tip.detail, style: const TextStyle(fontSize: 14, height: 1.6)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(child: StatefulBuilder(
                builder: (ctx, setBtn) => OutlinedButton.icon(
                  onPressed: () {
                    setState(() => tip.upvoted ? (tip.upvoted = false, tip.upvotes--) : (tip.upvoted = true, tip.upvotes++));
                    setBtn(() {});
                  },
                  icon: Icon(Icons.thumb_up, size: 16, color: tip.upvoted ? Colors.green : Colors.grey),
                  label: Text('${tip.upvotes} hilfreich', style: TextStyle(color: tip.upvoted ? Colors.green : Colors.grey)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: tip.upvoted ? Colors.green.withOpacity(0.5) : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )),
              const SizedBox(width: 8),
              Expanded(child: StatefulBuilder(
                builder: (ctx, setBtn) => OutlinedButton.icon(
                  onPressed: () {
                    setState(() => tip.bookmarked = !tip.bookmarked);
                    setBtn(() {});
                  },
                  icon: Icon(tip.bookmarked ? Icons.bookmark : Icons.bookmark_border, size: 16, color: tip.bookmarked ? const Color(0xFFFFA726) : Colors.grey),
                  label: Text(tip.bookmarked ? 'Gespeichert' : 'Speichern', style: TextStyle(color: tip.bookmarked ? const Color(0xFFFFA726) : Colors.grey)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: tip.bookmarked ? const Color(0xFFFFA726).withOpacity(0.5) : Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              )),
            ]),
          ]),
        ),
      ),
    );
  }

  void _showBookmarked() {
    final bookmarked = _tips.where((t) => t.bookmarked).toList();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 12),
          const Text('📑 Gespeicherte Tipps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...bookmarked.map((t) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(t.emoji, style: const TextStyle(fontSize: 24)),
            title: Text(t.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(t.category, style: TextStyle(fontSize: 12, color: _categoryColor(t.category))),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_remove, color: Colors.orange),
              onPressed: () { setState(() => t.bookmarked = false); Navigator.pop(ctx); },
            ),
            onTap: () { Navigator.pop(ctx); _showTipDetail(t); },
          )),
          if (bookmarked.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Noch keine Tipps gespeichert', style: TextStyle(color: Colors.grey)))),
        ]),
      ),
    );
  }

  void _addCustomTip() {
    final titleCtrl = TextEditingController();
    final summaryCtrl = TextEditingController();
    final detailCtrl = TextEditingController();
    String cat = 'Vorbereitung';
    String emoji = '💡';
    final emojis = ['💡', '🌟', '🎯', '📌', '🔑', '⭐', '🎒', '🏖️', '🚗', '🍕'];

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 12),
            const Center(child: Text('Eigenen Tipp hinzufügen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            // Emoji selection
            const Text('Emoji wählen:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: emojis.map((e) => GestureDetector(
              onTap: () => setSheet(() => emoji = e),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: emoji == e ? const Color(0xFFFFA726).withOpacity(0.15) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: emoji == e ? Border.all(color: const Color(0xFFFFA726), width: 2) : null,
                ),
                child: Center(child: Text(e, style: const TextStyle(fontSize: 18))),
              ),
            )).toList()),
            const SizedBox(height: 14),
            // Category
            DropdownButtonFormField<String>(
              value: cat, decoration: const InputDecoration(labelText: 'Kategorie'),
              items: _categories.where((c) => c != 'Alle').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setSheet(() => cat = v ?? cat),
            ),
            const SizedBox(height: 12),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titel', hintText: 'z.B. Beste Reise-App')),
            const SizedBox(height: 12),
            TextField(controller: summaryCtrl, decoration: const InputDecoration(labelText: 'Kurzbeschreibung', hintText: 'Eine Zeile Zusammenfassung'), maxLines: 2),
            const SizedBox(height: 12),
            TextField(controller: detailCtrl, decoration: const InputDecoration(labelText: 'Details (optional)', hintText: 'Ausführliche Beschreibung…'), maxLines: 4),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFA726)),
              onPressed: () {
                if (titleCtrl.text.isEmpty || summaryCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Titel und Beschreibung sind erforderlich!')));
                  return;
                }
                setState(() => _tips.add(_TravelTip(
                  emoji: emoji, title: titleCtrl.text, summary: summaryCtrl.text,
                  detail: detailCtrl.text.isNotEmpty ? detailCtrl.text : summaryCtrl.text,
                  category: cat, upvotes: 0, isCustom: true,
                )));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✓ Tipp hinzugefügt!'), backgroundColor: Colors.green));
              },
              child: const Text('Tipp speichern', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )),
          ])),
        ),
      ),
    );
  }
}

class _TravelTip {
  final String emoji;
  final String title;
  final String summary;
  final String detail;
  final String category;
  int upvotes;
  bool bookmarked;
  bool upvoted;
  bool isCustom;

  _TravelTip({
    required this.emoji, required this.title, required this.summary,
    required this.detail, required this.category, required this.upvotes,
    this.bookmarked = false, this.upvoted = false, this.isCustom = false,
  });
}
