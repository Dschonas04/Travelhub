import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/trip_member.dart';
import '../providers/members_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

/// Pendant zu GroupManagementView.swift – Gruppenverwaltung
class GroupManagementScreen extends StatefulWidget {
  final String tripId;
  final String tripTitle;
  final String tripDestination;
  const GroupManagementScreen({super.key, required this.tripId, required this.tripTitle, required this.tripDestination});

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> {
  static const _roles = [
    ('Organisator', Icons.emoji_events, 'Plant und koordiniert die Reise', Colors.orange),
    ('Finanzer', Icons.account_balance_wallet, 'Verwaltet Budget und Ausgaben', Colors.green),
    ('Navigator', Icons.map, 'Kümmert sich um Routen & Transport', Colors.blue),
    ('Fotograf', Icons.camera_alt, 'Dokumentiert die Reise', Colors.purple),
    ('Koch', Icons.restaurant, 'Organisiert Verpflegung', Colors.red),
    ('Teilnehmer', Icons.person, 'Standard-Rolle', Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MembersProvider>().loadMembers());
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'Organisator':
        return Colors.orange;
      case 'Finanzer':
        return Colors.green;
      case 'Navigator':
        return Colors.blue;
      case 'Fotograf':
        return Colors.purple;
      case 'Koch':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'Organisator':
        return Icons.emoji_events;
      case 'Finanzer':
        return Icons.account_balance_wallet;
      case 'Navigator':
        return Icons.map;
      case 'Fotograf':
        return Icons.camera_alt;
      case 'Koch':
        return Icons.restaurant;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gruppenverwaltung', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fertig', style: TextStyle(color: Colors.white)))],
      ),
      body: Consumer<MembersProvider>(
        builder: (ctx, prov, _) {
          final members = prov.membersForTrip(widget.tripId);
          return ListView(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                      ),
                      child: const Icon(Icons.flight, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 10),
                    Text(widget.tripTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(widget.tripDestination, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text('${members.length} Mitglieder', style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),

              // Members
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('Mitglieder & Rollen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              ...members.map((m) => _memberRow(m, prov)),
              const Divider(indent: 16, endIndent: 16),

              // Invite
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.person_add, color: Colors.white, size: 18),
                ),
                title: const Text('Mitglied einladen', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
                onTap: () => _invite(context),
              ),
              const Divider(indent: 16, endIndent: 16),

              // Available Roles
              ExpansionTile(
                title: const Text('Verfügbare Rollen'),
                children: _roles.map((r) {
                  final (name, icon, desc, color) = r;
                  return ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: (color as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, size: 16, color: color),
                    ),
                    title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    subtitle: Text(desc, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
              const Divider(indent: 16, endIndent: 16),

              // Leave
              ListTile(
                title: const Center(child: Text('Gruppe verlassen', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500))),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _memberRow(TripMember m, MembersProvider prov) {
    final rc = _roleColor(m.role);
    return ListTile(
      leading: UserAvatar(name: m.userName, size: 44),
      title: Text(m.userName, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: GestureDetector(
        onTap: () => _pickRole(m, prov),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: rc.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_roleIcon(m.role), size: 12, color: rc),
              const SizedBox(width: 4),
              Text(m.role, style: TextStyle(fontSize: 12, color: rc)),
            ],
          ),
        ),
      ),
      trailing: m.role == 'Organisator' ? const Icon(Icons.emoji_events, color: Colors.orange, size: 16) : null,
    );
  }

  void _pickRole(TripMember m, MembersProvider prov) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(padding: EdgeInsets.all(16), child: Text('Rolle zuweisen', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            ..._roles.map((r) {
              final (name, icon, _, color) = r;
              return ListTile(
                leading: Icon(icon, color: color as Color),
                title: Text(name),
                trailing: m.role == name ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  prov.updateRole(m, name);
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _invite(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    String role = 'Teilnehmer';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Mitglied einladen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              const SizedBox(height: 12),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'E-Mail (optional)'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(labelText: 'Rolle'),
                items: _roles.map((r) => DropdownMenuItem(value: r.$1, child: Text(r.$1))).toList(),
                onChanged: (v) => setSheet(() => role = v ?? role),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nameCtrl.text.isEmpty
                      ? null
                      : () {
                          final member = TripMember(tripId: widget.tripId, userName: nameCtrl.text, userEmail: emailCtrl.text, role: role);
                          context.read<MembersProvider>().addMember(member);
                          Navigator.pop(ctx);
                        },
                  child: const Text('Einladen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
