import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Packliste mit Kategorien, Fortschrittsanzeige, geteilten Items & Suchfunktion
class PacklisteScreen extends StatefulWidget {
  final String tripId;
  const PacklisteScreen({super.key, required this.tripId});

  @override
  State<PacklisteScreen> createState() => _PacklisteScreenState();
}

class _PacklisteScreenState extends State<PacklisteScreen> {
  String _searchText = '';
  bool _showOnlyUnchecked = false;

  final List<_PackCategory> _categories = [
    _PackCategory(
      name: 'Kleidung',
      emoji: '👕',
      color: const Color(0xFF42A5F5),
      items: [
        _PackItem(name: 'T-Shirts', quantity: 5),
        _PackItem(name: 'Badehose / Bikini', quantity: 2),
        _PackItem(name: 'Shorts', quantity: 3),
        _PackItem(name: 'Leichte Jacke', quantity: 1),
        _PackItem(name: 'Unterwäsche', quantity: 7),
        _PackItem(name: 'Socken', quantity: 5),
      ],
    ),
    _PackCategory(
      name: 'Hygiene',
      emoji: '🧴',
      color: const Color(0xFF26A69A),
      items: [
        _PackItem(name: 'Sonnencreme LSF 50'),
        _PackItem(name: 'Zahnbürste & Zahnpasta'),
        _PackItem(name: 'Shampoo & Duschgel'),
        _PackItem(name: 'Deo'),
        _PackItem(name: 'Autan / Mückenspray'),
        _PackItem(name: 'After-Sun Lotion'),
      ],
    ),
    _PackCategory(
      name: 'Technik',
      emoji: '📱',
      color: const Color(0xFFAB47BC),
      items: [
        _PackItem(name: 'Handy + Ladekabel'),
        _PackItem(name: 'Kopfhörer'),
        _PackItem(name: 'Powerbank'),
        _PackItem(name: 'Kamera'),
        _PackItem(name: 'Reiseadapter'),
      ],
    ),
    _PackCategory(
      name: 'Dokumente',
      emoji: '📄',
      color: const Color(0xFFEF5350),
      items: [
        _PackItem(name: 'Reisepass / Personalausweis'),
        _PackItem(name: 'Flugtickets'),
        _PackItem(name: 'Hotelbestätigung'),
        _PackItem(name: 'Krankenversicherungskarte'),
        _PackItem(name: 'Bargeld + Kreditkarte'),
      ],
    ),
    _PackCategory(
      name: 'Strand & Freizeit',
      emoji: '🏖️',
      color: const Color(0xFFFFA726),
      items: [
        _PackItem(name: 'Strandtuch'),
        _PackItem(name: 'Sonnenbrille'),
        _PackItem(name: 'FlipFlops'),
        _PackItem(name: 'Schnorchel-Set'),
        _PackItem(name: 'Luftmatratze'),
        _PackItem(name: 'Gesellschaftsspiele'),
        _PackItem(name: 'Buch / eReader'),
      ],
    ),
    _PackCategory(
      name: 'Reiseapotheke',
      emoji: '💊',
      color: const Color(0xFFEC407A),
      items: [
        _PackItem(name: 'Schmerztabletten'),
        _PackItem(name: 'Pflaster'),
        _PackItem(name: 'Durchfall-Medikamente'),
        _PackItem(name: 'Magen-Tabletten'),
        _PackItem(name: 'Desinfektionsspray'),
      ],
    ),
  ];

  // Shared items that multiple people can claim
  final List<_SharedItem> _sharedItems = [
    _SharedItem(name: 'Bluetooth-Lautsprecher', claimedBy: 'Max', emoji: '🔊'),
    _SharedItem(name: 'Kartenspiele', claimedBy: 'Sophie', emoji: '🃏'),
    _SharedItem(name: 'Erste-Hilfe-Set', claimedBy: 'Lars', emoji: '🩹'),
    _SharedItem(name: 'Reiseführer', claimedBy: '', emoji: '📖'),
    _SharedItem(name: 'Strandmuschel', claimedBy: '', emoji: '⛱️'),
  ];

  int get _totalItems => _categories.fold(0, (sum, c) => sum + c.items.length);
  int get _checkedItems => _categories.fold(0, (sum, c) => sum + c.items.where((i) => i.isChecked).length);
  double get _progress => _totalItems == 0 ? 0 : _checkedItems / _totalItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Packliste', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showOnlyUnchecked ? Icons.filter_alt : Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () => setState(() => _showOnlyUnchecked = !_showOnlyUnchecked),
            tooltip: 'Nur offene anzeigen',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.cardBackground,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('$_checkedItems von $_totalItems eingepackt', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('${(_progress * 100).toInt()}% erledigt', style: TextStyle(fontSize: 13, color: _progress == 1.0 ? Colors.green : Colors.grey.shade600)),
                    ])),
                    // Progress circle
                    SizedBox(
                      width: 52, height: 52,
                      child: Stack(
                        children: [
                          CircularProgressIndicator(value: _progress, backgroundColor: Colors.grey.shade200, color: _progress == 1.0 ? Colors.green : const Color(0xFF42A5F5), strokeWidth: 5),
                          Center(child: Text('${(_progress * 100).toInt()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _progress == 1.0 ? Colors.green : const Color(0xFF42A5F5)))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search
                TextField(
                  onChanged: (v) => setState(() => _searchText = v),
                  decoration: InputDecoration(
                    hintText: 'Item suchen...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ..._categories.map(_categorySection),
                const SizedBox(height: 16),
                // Shared items section
                _sharedItemsSection(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItem,
        backgroundColor: const Color(0xFF42A5F5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _categorySection(_PackCategory category) {
    final filteredItems = category.items.where((item) {
      if (_showOnlyUnchecked && item.isChecked) return false;
      if (_searchText.isNotEmpty && !item.name.toLowerCase().contains(_searchText.toLowerCase())) return false;
      return true;
    }).toList();

    if (filteredItems.isEmpty && (_searchText.isNotEmpty || _showOnlyUnchecked)) return const SizedBox.shrink();

    final checkedInCat = category.items.where((i) => i.isChecked).length;
    final totalInCat = category.items.length;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(gradient: LinearGradient(colors: [category.color, category.color.withOpacity(0.6)]), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(category.emoji, style: const TextStyle(fontSize: 18))),
          ),
          title: Row(
            children: [
              Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: checkedInCat == totalInCat ? Colors.green.withOpacity(0.1) : category.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$checkedInCat/$totalInCat',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: checkedInCat == totalInCat ? Colors.green : category.color),
                ),
              ),
            ],
          ),
          children: [
            ...filteredItems.map((item) => _itemRow(item, category.color)),
            // Add button
            InkWell(
              onTap: () => _addToCategory(category),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  Icon(Icons.add_circle_outline, size: 18, color: category.color),
                  const SizedBox(width: 10),
                  Text('Item hinzufügen', style: TextStyle(fontSize: 13, color: category.color)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemRow(_PackItem item, Color accentColor) {
    return Dismissible(
      key: Key(item.name + item.hashCode.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        setState(() {
          for (final cat in _categories) {
            cat.items.remove(item);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${item.name}" entfernt')));
      },
      child: InkWell(
        onTap: () => setState(() => item.isChecked = !item.isChecked),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(item.isChecked ? Icons.check_circle : Icons.radio_button_unchecked, color: item.isChecked ? Colors.green : Colors.grey.shade400, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    decoration: item.isChecked ? TextDecoration.lineThrough : null,
                    color: item.isChecked ? Colors.grey : AppColors.text,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (item.quantity > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('${item.quantity}x', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accentColor)),
                ),
              if (item.assignedTo.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(item.assignedTo, style: const TextStyle(fontSize: 10, color: Colors.orange)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sharedItemsSection() {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          leading: Container(
            width: 36, height: 36,
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)]), borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('🤝', style: TextStyle(fontSize: 18))),
          ),
          title: const Text('Gemeinsame Items', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          children: [
            ..._sharedItems.map(_sharedItemRow),
            InkWell(
              onTap: _addSharedItem,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(children: [
                  const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF5C6BC0)),
                  const SizedBox(width: 10),
                  const Text('Gemeinsames Item hinzufügen', style: TextStyle(fontSize: 13, color: Color(0xFF5C6BC0))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sharedItemRow(_SharedItem item) {
    return InkWell(
      onTap: () => _claimItem(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(children: [
          Text(item.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(item.claimedBy.isEmpty ? 'Noch nicht zugewiesen' : 'Mitgebracht von ${item.claimedBy}',
              style: TextStyle(fontSize: 12, color: item.claimedBy.isEmpty ? Colors.orange : Colors.green)),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.claimedBy.isEmpty ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.claimedBy.isEmpty ? 'Übernehmen' : '✓',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.claimedBy.isEmpty ? Colors.orange : Colors.green),
            ),
          ),
        ]),
      ),
    );
  }

  void _claimItem(_SharedItem item) {
    if (item.claimedBy.isEmpty) {
      setState(() => item.claimedBy = 'Du');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Du bringst "${item.name}" mit! ✓')));
    }
  }

  void _addToCategory(_PackCategory category) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Item zu ${category.name}'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Bezeichnung'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          TextButton(onPressed: () { if (ctrl.text.isNotEmpty) { setState(() => category.items.add(_PackItem(name: ctrl.text))); Navigator.pop(ctx); } }, child: const Text('Hinzufügen')),
        ],
      ),
    );
  }

  void _showAddItem() {
    final ctrl = TextEditingController();
    String selectedCat = _categories.first.name;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Neues Item', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Bezeichnung'), autofocus: true),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedCat,
              decoration: const InputDecoration(labelText: 'Kategorie'),
              items: _categories.map((c) => DropdownMenuItem(value: c.name, child: Row(children: [Text(c.emoji), const SizedBox(width: 8), Text(c.name)]))).toList(),
              onChanged: (v) => setSheet(() => selectedCat = v ?? selectedCat),
            ),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                if (ctrl.text.isNotEmpty) {
                  setState(() => _categories.firstWhere((c) => c.name == selectedCat).items.add(_PackItem(name: ctrl.text)));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Hinzufügen'),
            )),
          ]),
        ),
      ),
    );
  }

  void _addSharedItem() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gemeinsames Item'),
        content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'z.B. Bluetooth-Box'), autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
          TextButton(onPressed: () {
            if (ctrl.text.isNotEmpty) {
              setState(() => _sharedItems.add(_SharedItem(name: ctrl.text, claimedBy: '', emoji: '📦')));
              Navigator.pop(ctx);
            }
          }, child: const Text('Hinzufügen')),
        ],
      ),
    );
  }
}

class _PackCategory {
  final String name, emoji;
  final Color color;
  final List<_PackItem> items;
  _PackCategory({required this.name, required this.emoji, required this.color, required this.items});
}

class _PackItem {
  String name;
  bool isChecked;
  int quantity;
  String assignedTo;
  _PackItem({required this.name, this.isChecked = false, this.quantity = 1, this.assignedTo = ''});
}

class _SharedItem {
  String name, claimedBy, emoji;
  _SharedItem({required this.name, required this.claimedBy, required this.emoji});
}
