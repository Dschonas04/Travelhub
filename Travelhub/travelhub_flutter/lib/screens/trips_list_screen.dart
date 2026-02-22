import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/trips_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/trip_card.dart';
import 'create_trip_screen.dart';
import 'trip_detail_screen.dart';

/// Pendant zu TripsListView.swift (Tab 1)
class TripsListScreen extends StatefulWidget {
  const TripsListScreen({super.key});

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  int _selectedFilter = 0; // 0 = Aktuelle, 1 = Vergangene
  String _searchText = '';

  List<Trip> _filteredTrips(TripsProvider provider) {
    List<Trip> result;
    if (_selectedFilter == 0) {
      result = provider.activeTrips;
    } else {
      result = provider.pastTrips;
    }
    if (_searchText.isNotEmpty) {
      final query = _searchText.toLowerCase();
      result = result.where((t) =>
          t.title.toLowerCase().contains(query) ||
          t.destination.toLowerCase().contains(query)).toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktuelle Reisen', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Consumer<TripsProvider>(
        builder: (context, provider, _) {
          final trips = _filteredTrips(provider);
          return Column(
            children: [
              // Filter Tabs
              Row(
                children: [
                  _filterTab('Aktuelle Reisen', 0),
                  _filterTab('Vergangene', 1),
                ],
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _searchText = v),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          isDense: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Go!', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),

              // Trips List
              Expanded(
                child: trips.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.luggage, size: 56, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text('Keine Reisen vorhanden', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade500)),
                            const SizedBox(height: 4),
                            Text('Erstelle eine neue Reise oder tritt einer bei', style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: trips.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => TripCard(
                          trip: trips[i],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trips[i]))),
                        ),
                      ),
              ),

              // Bottom buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTripScreen())),
                          icon: const Icon(Icons.add_circle),
                          label: const Text('Neue Reise anlegen', style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showJoinDialog(context),
                          icon: const Icon(Icons.person_add, color: AppColors.primary),
                          label: const Text('Einer Reise beitreten', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.grey.shade100,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _filterTab(String label, int index) {
    final selected = _selectedFilter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: selected ? AppColors.primary : Colors.transparent, width: 2)),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? AppColors.primary : Colors.grey,
                )),
          ),
        ),
      ),
    );
  }

  void _showJoinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reise beitreten'),
        content: const TextField(decoration: InputDecoration(hintText: 'Einladungscode')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Beitreten')),
        ],
      ),
    );
  }
}
