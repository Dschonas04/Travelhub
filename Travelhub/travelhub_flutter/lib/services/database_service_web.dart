import '../models/models.dart';

/// In-Memory DatabaseService für Flutter Web.
/// Startet mit Demo-Daten, damit die App bei der Bewertung sofort
/// Inhalte zeigt – kein SQLite nötig.
class DatabaseService {
  // ── In-Memory-Speicher ─────────────────────────────────
  static final List<Trip> _trips = _initTrips();
  static final List<Friend> _friends = _initFriends();
  static final List<ChatMessage> _messages = _initMessages();
  static final List<BudgetExpense> _expenses = _initExpenses();
  static final List<TripMember> _members = _initMembers();
  static final List<Agreement> _agreements = _initAgreements();

  // =====================================================================
  //  DEMO-DATEN
  // =====================================================================

  static const _tripBarcelona = 'trip-barcelona-001';
  static const _tripSki = 'trip-ski-002';
  static const _tripMallorca = 'trip-mallorca-003';

  static const _userJonas = 'user-jonas';
  static const _userMax = 'user-max';
  static const _userSophie = 'user-sophie';
  static const _userLukas = 'user-lukas';
  static const _userEmma = 'user-emma';

  static List<Trip> _initTrips() => [
        Trip(
          id: _tripBarcelona,
          title: 'Barcelona Städtetrip',
          tripDescription:
              'Ein verlängertes Wochenende in Barcelona! Sagrada Família, Tapas, Strand und Nachtleben.',
          startDate: DateTime(2026, 3, 15),
          endDate: DateTime(2026, 3, 22),
          budget: 800.0,
          members: ['Jonas', 'Max', 'Sophie', 'Emma'],
          organizer: 'Jonas',
          destination: 'Barcelona, Spanien',
          imageURL: '',
          isActive: true,
        ),
        Trip(
          id: _tripSki,
          title: 'Skiurlaub Tirol',
          tripDescription:
              'Eine Woche Skifahren in den Tiroler Alpen. Perfekter Schnee garantiert!',
          startDate: DateTime(2026, 1, 10),
          endDate: DateTime(2026, 1, 17),
          budget: 1200.0,
          members: ['Jonas', 'Lukas', 'Max'],
          organizer: 'Lukas',
          destination: 'Sölden, Österreich',
          imageURL: '',
          isActive: true,
        ),
        Trip(
          id: _tripMallorca,
          title: 'Mallorca Sommer 2026',
          tripDescription:
              'Zwei Wochen Sonne, Strand und Meer auf Mallorca. Finca ist schon gebucht!',
          startDate: DateTime(2026, 7, 1),
          endDate: DateTime(2026, 7, 14),
          budget: 1500.0,
          members: ['Jonas', 'Sophie', 'Emma', 'Max', 'Lukas'],
          organizer: 'Sophie',
          destination: 'Palma de Mallorca, Spanien',
          imageURL: '',
          isActive: true,
        ),
      ];

  static List<Friend> _initFriends() => [
        Friend(
          id: _userMax,
          friendName: 'Max Müller',
          friendEmail: 'max.mueller@email.de',
          status: 'accepted',
          addedDate: DateTime(2025, 6, 15),
          profileImage: '',
        ),
        Friend(
          id: _userSophie,
          friendName: 'Sophie Schmidt',
          friendEmail: 'sophie.schmidt@email.de',
          status: 'accepted',
          addedDate: DateTime(2025, 7, 3),
          profileImage: '',
        ),
        Friend(
          id: _userLukas,
          friendName: 'Lukas Weber',
          friendEmail: 'lukas.weber@email.de',
          status: 'accepted',
          addedDate: DateTime(2025, 8, 20),
          profileImage: '',
        ),
        Friend(
          id: _userEmma,
          friendName: 'Emma Fischer',
          friendEmail: 'emma.fischer@email.de',
          status: 'accepted',
          addedDate: DateTime(2025, 9, 10),
          profileImage: '',
        ),
        Friend(
          id: 'user-pending-1',
          friendName: 'Lina Hoffmann',
          friendEmail: 'lina.h@email.de',
          status: 'pending',
          addedDate: DateTime(2026, 2, 14),
          profileImage: '',
        ),
      ];

  static List<ChatMessage> _initMessages() => [
        ChatMessage(
          id: 'msg-001',
          senderId: _userJonas,
          senderName: 'Jonas',
          tripId: _tripBarcelona,
          content: 'Hey Leute! Ich hab die Flüge gecheckt – ab 89€ mit Vueling! 🛫',
          timestamp: DateTime(2026, 2, 10, 14, 30),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-002',
          senderId: _userMax,
          senderName: 'Max',
          tripId: _tripBarcelona,
          content: 'Nice! Sollen wir direkt buchen? Je früher desto billiger.',
          timestamp: DateTime(2026, 2, 10, 14, 35),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-003',
          senderId: _userSophie,
          senderName: 'Sophie',
          tripId: _tripBarcelona,
          content: 'Ja, bin dabei! 🙌 Hat jemand schon ein Hotel gefunden?',
          timestamp: DateTime(2026, 2, 10, 15, 12),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-004',
          senderId: _userEmma,
          senderName: 'Emma',
          tripId: _tripBarcelona,
          content:
              'Ich hab ein Airbnb in der Nähe von La Rambla gefunden – 45€ pro Person/Nacht!',
          timestamp: DateTime(2026, 2, 10, 16, 45),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-005',
          senderId: _userJonas,
          senderName: 'Jonas',
          tripId: _tripBarcelona,
          content: 'Perfekt, lass uns das nehmen! Ich erstelle eine Packliste 📝',
          timestamp: DateTime(2026, 2, 10, 17, 0),
          isRead: true,
          messageType: 'text',
          isPinned: true,
        ),
        ChatMessage(
          id: 'msg-006',
          senderId: _userLukas,
          senderName: 'Lukas',
          tripId: _tripSki,
          content: 'Leute, der Schnee in Sölden war mega! 🎿❄️',
          timestamp: DateTime(2026, 1, 12, 18, 20),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-007',
          senderId: _userMax,
          senderName: 'Max',
          tripId: _tripSki,
          content: 'Beste Woche ever! Nächstes Jahr wieder? 😄',
          timestamp: DateTime(2026, 1, 12, 18, 25),
          isRead: true,
          messageType: 'text',
        ),
        ChatMessage(
          id: 'msg-008',
          senderId: _userSophie,
          senderName: 'Sophie',
          tripId: _tripMallorca,
          content:
              'Finca ist gebucht! 5 Schlafzimmer, Pool, direkt am Meer 🏖️',
          timestamp: DateTime(2026, 2, 16, 10, 0),
          isRead: true,
          messageType: 'text',
          isPinned: true,
        ),
        ChatMessage(
          id: 'msg-009',
          senderId: _userJonas,
          senderName: 'Jonas',
          tripId: _tripMallorca,
          content: 'Wow, sieht traumhaft aus! Wie teilen wir die Kosten auf?',
          timestamp: DateTime(2026, 2, 16, 10, 15),
          isRead: true,
          messageType: 'text',
        ),
      ];

  static List<BudgetExpense> _initExpenses() => [
        BudgetExpense(
          id: 'exp-001',
          tripId: _tripBarcelona,
          expenseDescription: 'Flüge (4 Personen)',
          amount: 356.0,
          paidBy: 'Jonas',
          category: 'Transport',
          splitWith: ['Jonas', 'Max', 'Sophie', 'Emma'],
          date: DateTime(2026, 2, 11),
        ),
        BudgetExpense(
          id: 'exp-002',
          tripId: _tripBarcelona,
          expenseDescription: 'Airbnb (7 Nächte)',
          amount: 1260.0,
          paidBy: 'Emma',
          category: 'Unterkunft',
          splitWith: ['Jonas', 'Max', 'Sophie', 'Emma'],
          date: DateTime(2026, 2, 12),
        ),
        BudgetExpense(
          id: 'exp-003',
          tripId: _tripBarcelona,
          expenseDescription: 'Sagrada Família Tickets',
          amount: 104.0,
          paidBy: 'Sophie',
          category: 'Aktivitäten',
          splitWith: ['Jonas', 'Max', 'Sophie', 'Emma'],
          date: DateTime(2026, 2, 14),
        ),
        BudgetExpense(
          id: 'exp-004',
          tripId: _tripSki,
          expenseDescription: 'Skipass (6 Tage, 3 Personen)',
          amount: 891.0,
          paidBy: 'Lukas',
          category: 'Aktivitäten',
          splitWith: ['Jonas', 'Lukas', 'Max'],
          date: DateTime(2026, 1, 10),
        ),
        BudgetExpense(
          id: 'exp-005',
          tripId: _tripSki,
          expenseDescription: 'Ferienwohnung',
          amount: 980.0,
          paidBy: 'Jonas',
          category: 'Unterkunft',
          splitWith: ['Jonas', 'Lukas', 'Max'],
          date: DateTime(2026, 1, 8),
        ),
        BudgetExpense(
          id: 'exp-006',
          tripId: _tripSki,
          expenseDescription: 'Abendessen Berghütte',
          amount: 135.0,
          paidBy: 'Max',
          category: 'Essen',
          splitWith: ['Jonas', 'Lukas', 'Max'],
          date: DateTime(2026, 1, 13),
        ),
        BudgetExpense(
          id: 'exp-007',
          tripId: _tripMallorca,
          expenseDescription: 'Finca Anzahlung',
          amount: 500.0,
          paidBy: 'Sophie',
          category: 'Unterkunft',
          splitWith: ['Jonas', 'Sophie', 'Emma', 'Max', 'Lukas'],
          date: DateTime(2026, 2, 16),
        ),
      ];

  static List<TripMember> _initMembers() => [
        // Barcelona
        TripMember(
          id: 'tm-001',
          tripId: _tripBarcelona,
          userId: _userJonas,
          userName: 'Jonas',
          userEmail: 'jonas@email.de',
          role: 'Organisator',
          joinedDate: DateTime(2026, 2, 1),
          isActive: true,
        ),
        TripMember(
          id: 'tm-002',
          tripId: _tripBarcelona,
          userId: _userMax,
          userName: 'Max',
          userEmail: 'max.mueller@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 2),
          isActive: true,
        ),
        TripMember(
          id: 'tm-003',
          tripId: _tripBarcelona,
          userId: _userSophie,
          userName: 'Sophie',
          userEmail: 'sophie.schmidt@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 2),
          isActive: true,
        ),
        TripMember(
          id: 'tm-004',
          tripId: _tripBarcelona,
          userId: _userEmma,
          userName: 'Emma',
          userEmail: 'emma.fischer@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 3),
          isActive: true,
        ),
        // Ski
        TripMember(
          id: 'tm-005',
          tripId: _tripSki,
          userId: _userLukas,
          userName: 'Lukas',
          userEmail: 'lukas.weber@email.de',
          role: 'Organisator',
          joinedDate: DateTime(2025, 11, 1),
          isActive: true,
        ),
        TripMember(
          id: 'tm-006',
          tripId: _tripSki,
          userId: _userJonas,
          userName: 'Jonas',
          userEmail: 'jonas@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2025, 11, 5),
          isActive: true,
        ),
        TripMember(
          id: 'tm-007',
          tripId: _tripSki,
          userId: _userMax,
          userName: 'Max',
          userEmail: 'max.mueller@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2025, 11, 5),
          isActive: true,
        ),
        // Mallorca
        TripMember(
          id: 'tm-008',
          tripId: _tripMallorca,
          userId: _userSophie,
          userName: 'Sophie',
          userEmail: 'sophie.schmidt@email.de',
          role: 'Organisator',
          joinedDate: DateTime(2026, 2, 1),
          isActive: true,
        ),
        TripMember(
          id: 'tm-009',
          tripId: _tripMallorca,
          userId: _userJonas,
          userName: 'Jonas',
          userEmail: 'jonas@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 2),
          isActive: true,
        ),
        TripMember(
          id: 'tm-010',
          tripId: _tripMallorca,
          userId: _userEmma,
          userName: 'Emma',
          userEmail: 'emma.fischer@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 3),
          isActive: true,
        ),
        TripMember(
          id: 'tm-011',
          tripId: _tripMallorca,
          userId: _userMax,
          userName: 'Max',
          userEmail: 'max.mueller@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 4),
          isActive: true,
        ),
        TripMember(
          id: 'tm-012',
          tripId: _tripMallorca,
          userId: _userLukas,
          userName: 'Lukas',
          userEmail: 'lukas.weber@email.de',
          role: 'Teilnehmer',
          joinedDate: DateTime(2026, 2, 5),
          isActive: true,
        ),
      ];

  static List<Agreement> _initAgreements() => [
        Agreement(
          id: 'agr-001',
          tripId: _tripBarcelona,
          title: 'Flug buchen bis 28.02.',
          descriptionText: 'Vueling Direktflug ab Stuttgart, 89€ pro Person',
          createdBy: 'Jonas',
          assignedTo: ['Jonas', 'Max', 'Sophie', 'Emma'],
          status: 'offen',
          category: 'Transport',
          dueDate: DateTime(2026, 2, 28),
          hasDueDate: true,
          createdDate: DateTime(2026, 2, 10),
          priority: 'hoch',
          votesYes: 4,
          votesNo: 0,
          isResolved: false,
        ),
        Agreement(
          id: 'agr-002',
          tripId: _tripBarcelona,
          title: 'Restaurantliste erstellen',
          descriptionText: 'Jeder sucht 2-3 gute Tapas-Bars raus',
          createdBy: 'Sophie',
          assignedTo: ['Jonas', 'Max', 'Sophie', 'Emma'],
          status: 'in Bearbeitung',
          category: 'Essen',
          dueDate: DateTime(2026, 3, 10),
          hasDueDate: true,
          createdDate: DateTime(2026, 2, 12),
          priority: 'mittel',
          votesYes: 3,
          votesNo: 0,
          isResolved: false,
        ),
        Agreement(
          id: 'agr-003',
          tripId: _tripMallorca,
          title: 'Mietwagen reservieren',
          descriptionText: 'SUV für 5 Personen am Flughafen Palma',
          createdBy: 'Sophie',
          assignedTo: ['Max'],
          status: 'offen',
          category: 'Transport',
          dueDate: DateTime(2026, 5, 1),
          hasDueDate: true,
          createdDate: DateTime(2026, 2, 16),
          priority: 'mittel',
          votesYes: 5,
          votesNo: 0,
          isResolved: false,
        ),
        Agreement(
          id: 'agr-004',
          tripId: _tripSki,
          title: 'Skiausrüstung zurückgeben',
          descriptionText: 'Leihski bei Sport Auer abgeben',
          createdBy: 'Lukas',
          assignedTo: ['Jonas'],
          status: 'erledigt',
          category: 'Ausrüstung',
          dueDate: DateTime(2026, 1, 17),
          hasDueDate: true,
          createdDate: DateTime(2026, 1, 10),
          priority: 'hoch',
          votesYes: 3,
          votesNo: 0,
          isResolved: true,
        ),
      ];

  // =====================================================================
  //  CRUD – Trips
  // =====================================================================

  static Future<List<Trip>> getTrips() async => List.from(_trips);

  static Future<void> insertTrip(Trip trip) async {
    _trips.removeWhere((t) => t.id == trip.id);
    _trips.add(trip);
  }

  static Future<void> updateTrip(Trip trip) async {
    final idx = _trips.indexWhere((t) => t.id == trip.id);
    if (idx != -1) _trips[idx] = trip;
  }

  static Future<void> deleteTrip(String id) async {
    _trips.removeWhere((t) => t.id == id);
  }

  // =====================================================================
  //  CRUD – Friends
  // =====================================================================

  static Future<List<Friend>> getFriends() async => List.from(_friends);

  static Future<void> insertFriend(Friend f) async {
    _friends.removeWhere((x) => x.id == f.id);
    _friends.add(f);
  }

  static Future<void> updateFriend(Friend f) async {
    final idx = _friends.indexWhere((x) => x.id == f.id);
    if (idx != -1) _friends[idx] = f;
  }

  static Future<void> deleteFriend(String id) async {
    _friends.removeWhere((x) => x.id == id);
  }

  // =====================================================================
  //  CRUD – Chat Messages
  // =====================================================================

  static Future<List<ChatMessage>> getMessages() async {
    final sorted = List<ChatMessage>.from(_messages);
    sorted.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return sorted;
  }

  static Future<void> insertMessage(ChatMessage m) async {
    _messages.removeWhere((x) => x.id == m.id);
    _messages.add(m);
  }

  static Future<void> updateMessage(ChatMessage m) async {
    final idx = _messages.indexWhere((x) => x.id == m.id);
    if (idx != -1) _messages[idx] = m;
  }

  static Future<void> deleteMessage(String id) async {
    _messages.removeWhere((x) => x.id == id);
  }

  // =====================================================================
  //  CRUD – Budget Expenses
  // =====================================================================

  static Future<List<BudgetExpense>> getExpenses() async {
    final sorted = List<BudgetExpense>.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  static Future<void> insertExpense(BudgetExpense e) async {
    _expenses.removeWhere((x) => x.id == e.id);
    _expenses.add(e);
  }

  static Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((x) => x.id == id);
  }

  // =====================================================================
  //  CRUD – Trip Members
  // =====================================================================

  static Future<List<TripMember>> getMembers() async => List.from(_members);

  static Future<void> insertMember(TripMember m) async {
    _members.removeWhere((x) => x.id == m.id);
    _members.add(m);
  }

  static Future<void> updateMember(TripMember m) async {
    final idx = _members.indexWhere((x) => x.id == m.id);
    if (idx != -1) _members[idx] = m;
  }

  static Future<void> deleteMember(String id) async {
    _members.removeWhere((x) => x.id == id);
  }

  // =====================================================================
  //  CRUD – Agreements
  // =====================================================================

  static Future<List<Agreement>> getAgreements() async =>
      List.from(_agreements);

  static Future<void> insertAgreement(Agreement a) async {
    _agreements.removeWhere((x) => x.id == a.id);
    _agreements.add(a);
  }

  static Future<void> updateAgreement(Agreement a) async {
    final idx = _agreements.indexWhere((x) => x.id == a.id);
    if (idx != -1) _agreements[idx] = a;
  }

  static Future<void> deleteAgreement(String id) async {
    _agreements.removeWhere((x) => x.id == id);
  }
}
