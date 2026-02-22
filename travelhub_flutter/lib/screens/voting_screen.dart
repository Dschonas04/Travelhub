import 'package:flutter/material.dart';
import '../models/voting_activity.dart';
import '../theme/app_theme.dart';
import '../widgets/star_rating.dart';
import '../widgets/user_avatar.dart';

/// Pendant zu VotingView.swift – Ideensammlung & Abstimmung
class VotingScreen extends StatefulWidget {
  final String tripId;
  const VotingScreen({super.key, required this.tripId});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  List<VotingActivity> _activities = [
    VotingActivity(
      name: 'Drachenhoehlen',
      description: 'Besuch der berühmten Drachenhöhlen',
      iconName: 'terrain',
      ratings: {'Lars': 2, 'Tim': 4, 'Sophie': 2, 'Anna': 4, 'Max': 3},
    ),
    VotingActivity(
      name: 'Strandtag',
      description: 'Entspannter Tag am Strand',
      iconName: 'wb_sunny',
      ratings: {'Lars': 5, 'Tim': 4, 'Sophie': 5, 'Anna': 4, 'Max': 5},
    ),
    VotingActivity(
      name: 'Sightseeing Palma',
      description: 'Stadtbesichtigung Palma de Mallorca',
      iconName: 'account_balance',
      ratings: {'Lars': 3, 'Tim': 3, 'Sophie': 4, 'Anna': 2, 'Max': 3},
    ),
    VotingActivity(
      name: 'Shopping',
      description: 'Shopping Tour',
      iconName: 'shopping_bag',
      ratings: {'Lars': 2, 'Tim': 1, 'Sophie': 4, 'Anna': 3, 'Max': 2},
    ),
    VotingActivity(
      name: 'Boot mieten',
      description: 'Boot mieten und die Küste erkunden',
      iconName: 'sailing',
      ratings: {'Lars': 4, 'Tim': 3, 'Sophie': 3, 'Anna': 4, 'Max': 3},
    ),
  ];

  IconData _iconFor(String name) {
    switch (name) {
      case 'terrain':
        return Icons.terrain;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'account_balance':
        return Icons.account_balance;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'sailing':
        return Icons.sailing;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<VotingActivity>.from(_activities)
      ..sort((a, b) => b.averageRating.compareTo(a.averageRating));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ideensammlung & Abstimmung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF7043), Color(0xFFFF8A65)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Eigene Abstimmungen ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Eigene Abstimmungen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Aktivitäten', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            ..._activities.map((a) => _activityRow(a, onTap: () => _showVoteSheet(a))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextButton.icon(
                onPressed: _showAddActivity,
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                label: const Text('weitere Abstimmung hinzufügen', style: TextStyle(color: AppColors.primary)),
              ),
            ),
            const Divider(indent: 16, endIndent: 16),

            // ── Auswertungen ──
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text('Auswertungen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text('Aktivitäten', style: TextStyle(fontSize: 14, color: Colors.grey)),
            ),
            ...sorted.map((a) => _resultRow(a, onTap: () => _showResultSheet(a))),
          ],
        ),
      ),
    );
  }

  // ── Activity row (vote) ──
  Widget _activityRow(VotingActivity a, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(_iconFor(a.iconName), color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                StaticStarRating(rating: a.averageRating, size: 14),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Result row ──
  Widget _resultRow(VotingActivity a, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(child: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w500))),
                StaticStarRating(rating: a.averageRating, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Vote Sheet ──
  void _showVoteSheet(VotingActivity activity) {
    int myRating = 0;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconFor(activity.iconName), size: 60, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(activity.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Bitte gib dein Voting für ${activity.name} ab',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              StarRating(
                rating: myRating,
                size: 40,
                onChanged: (r) => setSheetState(() => myRating = r),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: myRating == 0
                      ? null
                      : () {
                          setState(() {
                            final idx = _activities.indexWhere((e) => e.id == activity.id);
                            if (idx != -1) _activities[idx].ratings['Du'] = myRating;
                          });
                          Navigator.pop(ctx);
                        },
                  child: const Text('Abstimmen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Result Sheet ──
  void _showResultSheet(VotingActivity activity) {
    final entries = activity.ratings.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scroll) => SingleChildScrollView(
          controller: scroll,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(_iconFor(activity.iconName), size: 48, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(activity.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...entries.map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          UserAvatar(name: e.key, size: 36),
                          const SizedBox(width: 10),
                          Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w500))),
                          StaticStarRating(rating: e.value.toDouble(), size: 16),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    const Text('Gesamtergebnis', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    StaticStarRating(rating: activity.averageRating, size: 24),
                    const SizedBox(height: 4),
                    Text('${activity.averageRating.toStringAsFixed(1)} / 5',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Add Activity ──
  void _showAddActivity() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Weitere Abstimmung hinzufügen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Bezeichnung')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Beschreibung'), maxLines: 3),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text('Foto hinzufügen', style: TextStyle(color: Colors.grey.shade500)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty) {
                        setState(() {
                          _activities.add(VotingActivity(
                            name: nameCtrl.text,
                            description: descCtrl.text,
                            iconName: 'star',
                            ratings: {},
                          ));
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Hinzufügen'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
