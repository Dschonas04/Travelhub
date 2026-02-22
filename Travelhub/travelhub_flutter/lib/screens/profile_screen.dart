import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/trips_provider.dart';
import '../providers/budget_provider.dart';
import '../providers/friends_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

/// Profil / Einstellungen – mit Statistiken, Erfolgen, App-Info und editierbarem Profil
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Max Mustermann';
  String _userEmail = 'max@mustermann.com';
  String _userBio = 'Reisebegeistert 🌍 | Abenteurer';
  bool _notificationsEnabled = true;
  bool _darkMode = false;
  String _language = 'Deutsch';
  String _currency = 'EUR (€)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Consumer3<TripsProvider, BudgetProvider, FriendsProvider>(
        builder: (ctx, tripsProv, budgetProv, friendsProv, _) {
          final tripCount = tripsProv.trips.length;
          final activeTrips = tripsProv.activeTrips.length;
          final totalBudget = tripsProv.totalBudget;
          final totalSpent = tripsProv.trips.fold<double>(0, (sum, t) => sum + budgetProv.totalExpensesForTrip(t.id));
          final friendCount = friendsProv.friends.length;
          final countries = tripsProv.trips.map((t) => t.destination).toSet().length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              // Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4A90D9), Color(0xFF67B8DE)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: [
                  Stack(children: [
                    Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                      child: UserAvatar(name: _userName, size: 80),
                    ),
                    Positioned(right: 0, bottom: 0, child: Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3)),
                    )),
                  ]),
                  const SizedBox(height: 12),
                  Text(_userName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text(_userEmail, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                  const SizedBox(height: 4),
                  Text(_userBio, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.75))),
                  const SizedBox(height: 12),
                  // Quick edit button
                  OutlinedButton.icon(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                    label: const Text('Profil bearbeiten', style: TextStyle(color: Colors.white, fontSize: 13)),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)),
                  ),
                ]),
              ),
              const SizedBox(height: 20),

              // Statistics Grid
              _sectionTitle('📊 Deine Statistiken'),
              Row(children: [
                _statCard('✈️', '$tripCount', 'Reisen', const Color(0xFF4A90D9)),
                const SizedBox(width: 8),
                _statCard('🌍', '$countries', 'Ziele', const Color(0xFF66BB6A)),
                const SizedBox(width: 8),
                _statCard('👥', '$friendCount', 'Freunde', const Color(0xFF5C6BC0)),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _statCard('🏃', '$activeTrips', 'Aktiv', Colors.orange),
                const SizedBox(width: 8),
                _statCard('💰', '€${totalBudget.toStringAsFixed(0)}', 'Budget', const Color(0xFF66BB6A)),
                const SizedBox(width: 8),
                _statCard('🛒', '€${totalSpent.toStringAsFixed(0)}', 'Ausgaben', const Color(0xFFEF5350)),
              ]),
              const SizedBox(height: 20),

              // Achievements
              _sectionTitle('🏆 Erfolge'),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
                child: Column(children: [
                  _achievementRow('🌱', 'Erste Reise', 'Deine erste Reise erstellt', tripCount >= 1),
                  const Divider(height: 16),
                  _achievementRow('🌍', 'Weltenbummler', '5 verschiedene Ziele besucht', countries >= 5),
                  const Divider(height: 16),
                  _achievementRow('👥', 'Sozial', '3 Freunde hinzugefügt', friendCount >= 3),
                  const Divider(height: 16),
                  _achievementRow('💰', 'Sparfuchs', 'Budget unter Plan geblieben', totalSpent < totalBudget && tripCount > 0),
                  const Divider(height: 16),
                  _achievementRow('✈️', 'Vielreisender', '10 Reisen erstellt', tripCount >= 10),
                ]),
              ),
              const SizedBox(height: 20),

              // Settings
              _sectionTitle('⚙️ Einstellungen'),
              Container(
                decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
                child: Column(children: [
                  _settingsRow(Icons.notifications_rounded, 'Benachrichtigungen', trailing: Switch(
                    value: _notificationsEnabled, activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _notificationsEnabled = v),
                  )),
                  const Divider(indent: 48, height: 1),
                  _settingsRow(Icons.dark_mode_rounded, 'Dunkelmodus', trailing: Switch(
                    value: _darkMode, activeColor: AppColors.primary,
                    onChanged: (v) { setState(() => _darkMode = v); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dunkelmodus kommt bald! 🌙'))); },
                  )),
                  const Divider(indent: 48, height: 1),
                  _settingsRow(Icons.language_rounded, 'Sprache', trailing: DropdownButton<String>(
                    value: _language, underline: const SizedBox(),
                    items: ['Deutsch', 'English', 'Español', 'Français'].map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => _language = v ?? _language),
                  )),
                  const Divider(indent: 48, height: 1),
                  _settingsRow(Icons.euro_rounded, 'Währung', trailing: DropdownButton<String>(
                    value: _currency, underline: const SizedBox(),
                    items: ['EUR (€)', 'USD (\$)', 'GBP (£)', 'CHF'].map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (v) => setState(() => _currency = v ?? _currency),
                  )),
                  const Divider(indent: 48, height: 1),
                  _settingsRow(Icons.lock_rounded, 'Datenschutz', trailing: const Icon(Icons.chevron_right, color: Colors.grey), onTap: () => _showPrivacy()),
                  const Divider(indent: 48, height: 1),
                  _settingsRow(Icons.help_outline_rounded, 'Hilfe & FAQ', trailing: const Icon(Icons.chevron_right, color: Colors.grey), onTap: () => _showHelp()),
                ]),
              ),
              const SizedBox(height: 20),

              // App Info
              _sectionTitle('ℹ️ App Info'),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
                child: Column(children: [
                  _infoRow('App Version', '2.1.0'),
                  const Divider(height: 16),
                  _infoRow('Flutter SDK', '3.x'),
                  const Divider(height: 16),
                  _infoRow('Entwickler', 'TravelHub Team'),
                  const Divider(height: 16),
                  _infoRow('Lizenz', 'MIT License'),
                ]),
              ),
              const SizedBox(height: 20),

              // Feedback
              SizedBox(width: double.infinity, child: OutlinedButton.icon(
                onPressed: _showFeedback,
                icon: const Icon(Icons.feedback_rounded, color: AppColors.primary),
                label: const Text('Feedback geben', style: TextStyle(color: AppColors.primary)),
                style: OutlinedButton.styleFrom(backgroundColor: AppColors.primary.withOpacity(0.1), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
              const SizedBox(height: 12),

              // Logout
              SizedBox(width: double.infinity, child: OutlinedButton.icon(
                onPressed: () => context.read<AuthProvider>().logout(),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Abmelden', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), side: BorderSide.none, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14)),
              )),
              const SizedBox(height: 20),
            ]),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String t) => Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));

  Widget _statCard(String emoji, String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.15))),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ]),
    ),
  );

  Widget _achievementRow(String emoji, String title, String desc, bool unlocked) => Row(children: [
    Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: unlocked ? Colors.amber.withOpacity(0.15) : Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Center(child: Text(unlocked ? emoji : '🔒', style: TextStyle(fontSize: 18, color: unlocked ? null : Colors.grey))),
    ),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: unlocked ? AppColors.text : Colors.grey)),
      Text(desc, style: TextStyle(fontSize: 12, color: unlocked ? Colors.grey.shade600 : Colors.grey.shade400)),
    ])),
    if (unlocked) const Icon(Icons.check_circle, size: 18, color: Colors.amber),
  ]);

  Widget _settingsRow(IconData icon, String label, {Widget? trailing, VoidCallback? onTap}) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: const TextStyle(color: AppColors.text))),
        if (trailing != null) trailing,
      ]),
    ),
  );

  Widget _infoRow(String label, String value) => Row(children: [
    Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
    const Spacer(),
    Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
  ]);

  void _editProfile(BuildContext context) {
    final nameCtrl = TextEditingController(text: _userName);
    final emailCtrl = TextEditingController(text: _userEmail);
    final bioCtrl = TextEditingController(text: _userBio);
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Profil bearbeiten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name', prefixIcon: Icon(Icons.person))),
          const SizedBox(height: 12),
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'E-Mail', prefixIcon: Icon(Icons.email))),
          const SizedBox(height: 12),
          TextField(controller: bioCtrl, decoration: const InputDecoration(labelText: 'Bio', prefixIcon: Icon(Icons.info_outline)), maxLines: 2),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              setState(() { _userName = nameCtrl.text; _userEmail = emailCtrl.text; _userBio = bioCtrl.text; });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✓ Profil aktualisiert!'), backgroundColor: Colors.green));
            },
            child: const Text('Speichern'),
          )),
        ]),
      ),
    );
  }

  void _showPrivacy() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Datenschutz'),
      content: const SingleChildScrollView(child: Text(
        'TravelHub speichert deine Daten ausschließlich lokal auf deinem Gerät. '
        'Keine personenbezogenen Daten werden an Dritte weitergegeben.\n\n'
        '• Profildaten: Nur lokal gespeichert\n'
        '• Reisedaten: Nur lokal in SQLite\n'
        '• Fotos: Nur lokal referenziert\n'
        '• Chat: Nur innerhalb der Gruppe\n\n'
        'Du kannst jederzeit alle deine Daten löschen, indem du die App deinstallierst.'
      )),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Verstanden'))],
    ));
  }

  void _showHelp() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Hilfe & FAQ'),
      content: const SingleChildScrollView(child: Text(
        '❓ Wie erstelle ich eine Reise?\n'
        '→ Gehe zu "Reisen" und tippe auf "Neue Reise anlegen".\n\n'
        '❓ Wie lade ich Freunde ein?\n'
        '→ Öffne eine Reise → Gruppenverwaltung → "Mitglied einladen".\n\n'
        '❓ Wie funktioniert die Budgetplanung?\n'
        '→ Öffne eine Reise → Budgetplanung. Dort kannst du Ausgaben erfassen und den Schuldenausgleich sehen.\n\n'
        '❓ Kann ich Fotos teilen?\n'
        '→ Ja! Öffne eine Reise → Fotos teilen. Dort kannst du Fotos hochladen und kommentieren.\n\n'
        '❓ Wie funktioniert die Abstimmung?\n'
        '→ Öffne eine Reise → Ideensammlung. Bewerte Aktivitäten mit Sternen.'
      )),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Schließen'))],
    ));
  }

  void _showFeedback() {
    final feedbackCtrl = TextEditingController();
    int rating = 0;
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Feedback geben', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Wie gefällt dir TravelHub?', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            // Star rating
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => GestureDetector(
              onTap: () => setSheet(() => rating = i + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(i < rating ? Icons.star : Icons.star_border, size: 36, color: i < rating ? Colors.amber : Colors.grey.shade400),
              ),
            ))),
            const SizedBox(height: 12),
            TextField(controller: feedbackCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Dein Feedback', hintText: 'Was können wir verbessern?')),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Danke für dein Feedback! ❤️'), backgroundColor: Colors.green));
              },
              child: const Text('Absenden'),
            )),
          ]),
        ),
      ),
    );
  }
}
