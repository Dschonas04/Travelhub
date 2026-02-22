import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class AgreementsProvider extends ChangeNotifier {
  List<Agreement> _agreements = [];
  List<Agreement> get agreements => _agreements;

  Future<void> loadAgreements() async {
    _agreements = await DatabaseService.getAgreements();
    notifyListeners();
  }

  List<Agreement> agreementsForTrip(String tripId) =>
      _agreements.where((a) => a.tripId == tripId).toList();

  Future<void> addAgreement(Agreement a) async {
    await DatabaseService.insertAgreement(a);
    _agreements.add(a);
    notifyListeners();
  }

  Future<void> updateAgreement(Agreement a) async {
    await DatabaseService.updateAgreement(a);
    final idx = _agreements.indexWhere((x) => x.id == a.id);
    if (idx != -1) _agreements[idx] = a;
    notifyListeners();
  }

  Future<void> deleteAgreement(Agreement a) async {
    await DatabaseService.deleteAgreement(a.id);
    _agreements.removeWhere((x) => x.id == a.id);
    notifyListeners();
  }
}
