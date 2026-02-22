import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/agreement.dart';
import '../providers/agreements_provider.dart';
import '../theme/app_theme.dart';

/// Pendant zu AgreementsView.swift – Absprachen
class AgreementsScreen extends StatefulWidget {
  final String tripId;
  const AgreementsScreen({super.key, required this.tripId});

  @override
  State<AgreementsScreen> createState() => _AgreementsScreenState();
}

class _AgreementsScreenState extends State<AgreementsScreen> {
  String _filter = 'Alle';
  final _filters = ['Alle', 'Offen', 'Beschlossen', 'Erledigt'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AgreementsProvider>().loadAgreements());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absprachen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.white),
            onPressed: () => _showCreate(context),
          ),
        ],
      ),
      body: Consumer<AgreementsProvider>(
        builder: (ctx, prov, _) {
          final all = prov.agreementsForTrip(widget.tripId);
          final filtered = _applyFilter(all);
          return Column(
            children: [
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: _filters.map((f) {
                    final count = _countFor(f, all);
                    final sel = f == _filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(f),
                            if (count > 0 && f != 'Alle') ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: sel ? Colors.white : Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text('$count',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: sel ? AppColors.primary : Colors.white)),
                              ),
                            ],
                          ],
                        ),
                        selected: sel,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: sel ? Colors.white : null, fontWeight: FontWeight.w600, fontSize: 13),
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // List
              Expanded(
                child: filtered.isEmpty
                    ? _empty()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, i) => _card(filtered[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Agreement> _applyFilter(List<Agreement> all) {
    switch (_filter) {
      case 'Offen':
        return all.where((a) => a.status == 'offen' || a.status == 'inAbstimmung').toList();
      case 'Beschlossen':
        return all.where((a) => a.status == 'beschlossen').toList();
      case 'Erledigt':
        return all.where((a) => a.status == 'erledigt').toList();
      default:
        return all;
    }
  }

  int _countFor(String f, List<Agreement> all) {
    switch (f) {
      case 'Offen':
        return all.where((a) => a.status == 'offen' || a.status == 'inAbstimmung').length;
      case 'Beschlossen':
        return all.where((a) => a.status == 'beschlossen').length;
      case 'Erledigt':
        return all.where((a) => a.status == 'erledigt').length;
      default:
        return all.length;
    }
  }

  Widget _empty() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 56, color: AppColors.primary.withOpacity(0.3)),
            const SizedBox(height: 12),
            const Text('Keine Absprachen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text('Erstelle eine Absprache, um\nEntscheidungen gemeinsam zu treffen',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      );

  Color _statusColor(String s) {
    switch (s) {
      case 'offen':
        return Colors.blue;
      case 'inAbstimmung':
        return Colors.orange;
      case 'beschlossen':
        return Colors.green;
      case 'erledigt':
        return Colors.grey;
      default:
        return Colors.red;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'offen':
        return 'Offen';
      case 'inAbstimmung':
        return 'In Abstimmung';
      case 'beschlossen':
        return 'Beschlossen';
      case 'erledigt':
        return 'Erledigt';
      default:
        return s;
    }
  }

  IconData _catIcon(String c) {
    switch (c) {
      case 'Unterkunft':
        return Icons.apartment;
      case 'Transport':
        return Icons.directions_car;
      case 'Aktivitäten':
        return Icons.hiking;
      case 'Essen':
        return Icons.restaurant;
      case 'Budget':
        return Icons.account_balance_wallet;
      default:
        return Icons.description;
    }
  }

  Color _prioColor(String p) {
    switch (p) {
      case 'hoch':
        return Colors.red;
      case 'mittel':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Widget _card(Agreement a) {
    final sc = _statusColor(a.status);
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showDetail(a),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(color: sc, borderRadius: BorderRadius.circular(8)),
                    child: Icon(_catIcon(a.category), color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(a.category, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: sc.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(_statusLabel(a.status), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sc)),
                  ),
                ],
              ),
              if (a.descriptionText.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(a.descriptionText, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: BoxDecoration(color: _prioColor(a.priority), shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  Text(a.priority[0].toUpperCase() + a.priority.substring(1), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const Spacer(),
                  if (a.votesYes > 0 || a.votesNo > 0) ...[
                    Icon(Icons.thumb_up, size: 12, color: Colors.green),
                    Text(' ${a.votesYes}', style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 6),
                    Icon(Icons.thumb_down, size: 12, color: Colors.red),
                    Text(' ${a.votesNo}', style: const TextStyle(fontSize: 11)),
                    const SizedBox(width: 8),
                  ],
                  if (a.hasDueDate) ...[
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    const SizedBox(width: 2),
                    Text(DateFormat('dd.MM.yy').format(a.dueDate), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Detail ──
  void _showDetail(Agreement agreement) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _AgreementDetailPage(agreement: agreement, tripId: widget.tripId)));
  }

  // ── Create ──
  void _showCreate(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _CreateAgreementPage(tripId: widget.tripId)));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DETAIL
// ─────────────────────────────────────────────────────────────────────────────
class _AgreementDetailPage extends StatelessWidget {
  final Agreement agreement;
  final String tripId;
  const _AgreementDetailPage({required this.agreement, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<AgreementsProvider>();

    Color statusColor(String s) {
      switch (s) {
        case 'offen':
          return Colors.blue;
        case 'inAbstimmung':
          return Colors.orange;
        case 'beschlossen':
          return Colors.green;
        case 'erledigt':
          return Colors.grey;
        default:
          return Colors.red;
      }
    }

    String statusName(String s) {
      switch (s) {
        case 'offen':
          return 'Offen';
        case 'inAbstimmung':
          return 'In Abstimmung';
        case 'beschlossen':
          return 'Beschlossen';
        case 'erledigt':
          return 'Erledigt';
        default:
          return s;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(agreement.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    Chip(label: Text(agreement.category), backgroundColor: AppColors.primary.withOpacity(0.1)),
                    Chip(
                      avatar: Icon(Icons.flag, size: 14, color: agreement.priority == 'hoch' ? Colors.red : agreement.priority == 'mittel' ? Colors.orange : Colors.green),
                      label: Text(agreement.priority[0].toUpperCase() + agreement.priority.substring(1)),
                    ),
                  ]),
                  if (agreement.descriptionText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(agreement.descriptionText, style: const TextStyle(color: Colors.grey)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Voting
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Abstimmung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final updated = agreement.copyWith(votesYes: agreement.votesYes + 1, status: 'inAbstimmung');
                            prov.updateAgreement(updated);
                          },
                          icon: const Icon(Icons.thumb_up, color: Colors.green),
                          label: Text('Dafür (${agreement.votesYes})'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.1),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final updated = agreement.copyWith(votesNo: agreement.votesNo + 1, status: 'inAbstimmung');
                            prov.updateAgreement(updated);
                          },
                          icon: const Icon(Icons.thumb_down, color: Colors.red),
                          label: Text('Dagegen (${agreement.votesNo})'),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            side: BorderSide.none,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (agreement.votesYes + agreement.votesNo > 0) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: agreement.votesYes / (agreement.votesYes + agreement.votesNo),
                        backgroundColor: Colors.red,
                        valueColor: const AlwaysStoppedAnimation(Colors.green),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status change
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status ändern', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['offen', 'inAbstimmung', 'beschlossen', 'erledigt'].map((s) {
                      final sel = agreement.status == s;
                      return ChoiceChip(
                        label: Text(statusName(s)),
                        selected: sel,
                        selectedColor: statusColor(s),
                        labelStyle: TextStyle(color: sel ? Colors.white : null, fontWeight: FontWeight.w600, fontSize: 12),
                        onSelected: (_) {
                          final updated = agreement.copyWith(status: s, isResolved: s == 'erledigt');
                          prov.updateAgreement(updated);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Details info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  _infoRow('Erstellt von', agreement.createdBy),
                  const Divider(),
                  _infoRow('Erstellt am', DateFormat('dd.MM.yy HH:mm').format(agreement.createdDate)),
                  if (agreement.hasDueDate) ...[
                    const Divider(),
                    _infoRow('Fällig bis', DateFormat('dd.MM.yy').format(agreement.dueDate)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delete
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  prov.deleteAgreement(agreement);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Absprache löschen', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), side: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 12)),
          ],
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// CREATE
// ─────────────────────────────────────────────────────────────────────────────
class _CreateAgreementPage extends StatefulWidget {
  final String tripId;
  const _CreateAgreementPage({required this.tripId});

  @override
  State<_CreateAgreementPage> createState() => _CreateAgreementPageState();
}

class _CreateAgreementPageState extends State<_CreateAgreementPage> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'Sonstiges';
  String _priority = 'mittel';
  bool _hasDueDate = false;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  final _categories = ['Unterkunft', 'Transport', 'Aktivitäten', 'Essen', 'Budget', 'Sonstiges'];
  final _priorities = ['niedrig', 'mittel', 'hoch'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neue Absprache', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _titleCtrl, decoration: const InputDecoration(labelText: 'Titel')),
          const SizedBox(height: 12),
          TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Beschreibung (optional)'), maxLines: 3),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(labelText: 'Kategorie'),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _priority,
            decoration: const InputDecoration(labelText: 'Priorität'),
            items: _priorities.map((p) => DropdownMenuItem(
                  value: p,
                  child: Row(children: [
                    Container(width: 8, height: 8, decoration: BoxDecoration(color: p == 'hoch' ? Colors.red : p == 'mittel' ? Colors.orange : Colors.green, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Text(p[0].toUpperCase() + p.substring(1)),
                  ]),
                )).toList(),
            onChanged: (v) => setState(() => _priority = v ?? _priority),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Fälligkeitsdatum'),
            value: _hasDueDate,
            onChanged: (v) => setState(() => _hasDueDate = v),
          ),
          if (_hasDueDate)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fällig bis'),
              trailing: Text(DateFormat('dd.MM.yyyy').format(_dueDate)),
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => _dueDate = d);
              },
            ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _titleCtrl.text.isEmpty ? null : _create,
            child: const Text('Absprache erstellen'),
          ),
        ],
      ),
    );
  }

  void _create() {
    final a = Agreement(
      tripId: widget.tripId,
      title: _titleCtrl.text,
      descriptionText: _descCtrl.text,
      createdBy: 'Du',
      category: _category,
      priority: _priority,
      hasDueDate: _hasDueDate,
      dueDate: _dueDate,
    );
    context.read<AgreementsProvider>().addAgreement(a);
    Navigator.pop(context);
  }
}
