import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/trips_provider.dart';

class CreateTripScreen extends StatefulWidget {
  final String? initialDestination;
  const CreateTripScreen({super.key, this.initialDestination});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _titleCtrl = TextEditingController();
  final _destCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialDestination != null) {
      _destCtrl.text = widget.initialDestination!;
    }
  }
  final _descCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleCtrl.dispose();
    _destCtrl.dispose();
    _descCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => isStart ? _startDate = date : _endDate = date);
  }

  void _create() {
    final trip = Trip(
      title: _titleCtrl.text,
      startDate: _startDate,
      endDate: _endDate,
      destination: _destCtrl.text,
      tripDescription: _descCtrl.text,
      budget: double.tryParse(_budgetCtrl.text) ?? 0,
      organizer: 'Max Mustermann',
      members: ['Max Mustermann'],
    );
    context.read<TripsProvider>().addTrip(trip);
    Navigator.pop(context);
  }

  String _formatDate(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final canSave = _titleCtrl.text.isNotEmpty && _destCtrl.text.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neue Reise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90D9), Color(0xFF67B8DE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen', style: TextStyle(color: Colors.white))),
        leadingWidth: 100,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Reisedetails'),
          TextField(controller: _titleCtrl, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Reisename')),
          const SizedBox(height: 12),
          TextField(controller: _destCtrl, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Reiseziel')),
          const SizedBox(height: 12),
          TextField(controller: _descCtrl, maxLines: 3, decoration: const InputDecoration(hintText: 'Beschreibung')),
          const SizedBox(height: 24),

          _sectionTitle('Zeitraum'),
          _dateRow('Startdatum', _startDate, () => _pickDate(true)),
          const SizedBox(height: 8),
          _dateRow('Enddatum', _endDate, () => _pickDate(false)),
          const SizedBox(height: 24),

          _sectionTitle('Budget'),
          TextField(controller: _budgetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(prefixText: '€ ', hintText: 'Betrag')),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canSave ? _create : null,
              child: const Text('Reise erstellen', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(t, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
      );

  Widget _dateRow(String label, DateTime date, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label), Text(_formatDate(date), style: const TextStyle(fontWeight: FontWeight.w500))],
          ),
        ),
      );
}
