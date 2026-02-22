import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';
import 'budget_screen.dart';
import 'voting_screen.dart';
import 'packliste_screen.dart';
import 'hotel_screen.dart';
import 'photo_sharing_screen.dart';
import 'travel_tips_screen.dart';
import 'agreements_screen.dart';
import 'group_management_screen.dart';

/// Pendant zu TripDetailView.swift
class TripDetailScreen extends StatelessWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});

  static const _menuItems = <_MenuItem>[
    _MenuItem('Gruppenverwaltung', Icons.people_rounded, [Color(0xFF5C6BC0), Color(0xFF7986CB)], 'gruppe'),
    _MenuItem('Chat', Icons.chat_bubble_rounded, [Color(0xFF4A90D9), Color(0xFF67B8DE)], 'chat'),
    _MenuItem('Absprachen', Icons.verified_rounded, [Color(0xFF26A69A), Color(0xFF4DB6AC)], 'absprachen'),
    _MenuItem('Ideensammlung & Abstimmung', Icons.lightbulb_rounded, [Color(0xFFFF7043), Color(0xFFFF8A65)], 'ideensammlung'),
    _MenuItem('Budgetplanung', Icons.account_balance_wallet_rounded, [Color(0xFF66BB6A), Color(0xFF81C784)], 'budget'),
    _MenuItem('Packliste', Icons.checklist_rounded, [Color(0xFF42A5F5), Color(0xFF64B5F6)], 'packliste'),
    _MenuItem('Hotel', Icons.apartment_rounded, [Color(0xFFAB47BC), Color(0xFFCE93D8)], 'hotel'),
    _MenuItem('Fotos teilen', Icons.photo_library_rounded, [Color(0xFFEC407A), Color(0xFFF48FB1)], 'fotos'),
    _MenuItem('Tipps zum Reiseziel', Icons.tips_and_updates_rounded, [Color(0xFFFFA726), Color(0xFFFFB74D)], 'tipps'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(trip.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.flight_takeoff_rounded, size: 28, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(trip.destination, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _chipInfo(Icons.calendar_today_rounded, '${trip.startDate.day}.${trip.startDate.month}.${trip.startDate.year}'),
                          const SizedBox(width: 12),
                          _chipInfo(Icons.people_rounded, '${trip.members.length} Teilnehmer'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ── Countdown & Quick-Stats ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildCountdownCard(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: _buildQuickStats(),
            ),
          ),
          // ── Menü ──
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildMenuItem(context, _menuItems[index]),
                ),
                childCount: _menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownCard() {
    final now = DateTime.now();
    final daysUntil = trip.startDate.difference(now).inDays;
    final tripDuration = trip.endDate.difference(trip.startDate).inDays;
    final isOngoing = now.isAfter(trip.startDate) && now.isBefore(trip.endDate);
    final isPast = now.isAfter(trip.endDate);
    final daysIntoTrip = isOngoing ? now.difference(trip.startDate).inDays + 1 : 0;

    String statusText;
    String statusEmoji;
    Color statusColor;
    if (isPast) {
      statusText = 'Reise beendet';
      statusEmoji = '✅';
      statusColor = Colors.grey;
    } else if (isOngoing) {
      statusText = 'Tag $daysIntoTrip von $tripDuration';
      statusEmoji = '🌴';
      statusColor = Colors.green;
    } else if (daysUntil <= 7) {
      statusText = 'Noch $daysUntil Tage!';
      statusEmoji = '🔥';
      statusColor = Colors.orange;
    } else {
      statusText = 'Noch $daysUntil Tage';
      statusEmoji = '✈️';
      statusColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(statusEmoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(statusText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: statusColor)),
              const SizedBox(height: 2),
              Text(
                '${trip.startDate.day}.${trip.startDate.month}.${trip.startDate.year} – ${trip.endDate.day}.${trip.endDate.month}.${trip.endDate.year}  ·  $tripDuration Tage',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              if (isOngoing) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: daysIntoTrip / tripDuration,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.green,
                    minHeight: 6,
                  ),
                ),
              ],
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _quickStatCard('👥', '${trip.members.length}', 'Mitglieder', const Color(0xFF5C6BC0)),
        const SizedBox(width: 8),
        _quickStatCard('💰', '€${trip.budget.toStringAsFixed(0)}', 'Budget', const Color(0xFF66BB6A)),
        const SizedBox(width: 8),
        _quickStatCard('📅', '${trip.endDate.difference(trip.startDate).inDays}', 'Tage', const Color(0xFFFFA726)),
      ],
    );
  }

  Widget _quickStatCard(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        ]),
      ),
    );
  }

  Widget _chipInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return Material(
      color: AppColors.cardBackground,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: () => _navigate(context, item.destination),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: item.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: item.colors[0].withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Icon(item.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.text)),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: item.colors[0].withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.chevron_right_rounded, size: 18, color: item.colors[0]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String dest) {
    Widget screen;
    switch (dest) {
      case 'gruppe':
        screen = GroupManagementScreen(tripId: trip.id, tripTitle: trip.title, tripDestination: trip.destination);
      case 'chat':
        screen = ChatScreen(trip: trip);
      case 'absprachen':
        screen = AgreementsScreen(tripId: trip.id);
      case 'ideensammlung':
        screen = VotingScreen(tripId: trip.id);
      case 'budget':
        screen = BudgetScreen(trip: trip);
      case 'packliste':
        screen = PacklisteScreen(tripId: trip.id);
      case 'hotel':
        screen = HotelScreen(tripId: trip.id);
      case 'fotos':
        screen = PhotoSharingScreen(tripId: trip.id);
      case 'tipps':
        screen = TravelTipsScreen(tripId: trip.id);
      default:
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final String destination;
  const _MenuItem(this.title, this.icon, this.colors, this.destination);
}
