import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart';

/// SQLite-basierter DatabaseService – für iOS & Android.
class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'travelhub.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        tripDescription TEXT,
        startDate TEXT,
        endDate TEXT,
        budget REAL,
        members TEXT,
        organizer TEXT,
        destination TEXT,
        imageURL TEXT,
        isActive INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        profileImage TEXT,
        bio TEXT,
        lastActive TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE friends (
        id TEXT PRIMARY KEY,
        friendName TEXT NOT NULL,
        friendEmail TEXT NOT NULL,
        status TEXT,
        addedDate TEXT,
        profileImage TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        senderId TEXT,
        senderName TEXT,
        tripId TEXT,
        content TEXT,
        timestamp TEXT,
        isRead INTEGER,
        messageType TEXT,
        replyToId TEXT,
        replyToSender TEXT,
        replyToContent TEXT,
        reactions TEXT,
        isPinned INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE budget_expenses (
        id TEXT PRIMARY KEY,
        tripId TEXT,
        expenseDescription TEXT,
        amount REAL,
        paidBy TEXT,
        category TEXT,
        splitWith TEXT,
        date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE trip_members (
        id TEXT PRIMARY KEY,
        tripId TEXT,
        userId TEXT,
        userName TEXT,
        userEmail TEXT,
        role TEXT,
        joinedDate TEXT,
        isActive INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE agreements (
        id TEXT PRIMARY KEY,
        tripId TEXT,
        title TEXT,
        descriptionText TEXT,
        createdBy TEXT,
        assignedTo TEXT,
        status TEXT,
        category TEXT,
        dueDate TEXT,
        hasDueDate INTEGER,
        createdDate TEXT,
        priority TEXT,
        votesYes INTEGER,
        votesNo INTEGER,
        isResolved INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE route_locations (
        id TEXT PRIMARY KEY,
        tripId TEXT,
        name TEXT,
        latitude REAL,
        longitude REAL,
        visitDate TEXT,
        duration INTEGER,
        notes TEXT,
        orderIndex INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        userId TEXT,
        type TEXT,
        relatedTripId TEXT,
        relatedUserId TEXT,
        title TEXT,
        body TEXT,
        isRead INTEGER,
        timestamp TEXT
      )
    ''');
  }

  // ── Trips ──────────────────────────────────────────────
  static Future<List<Trip>> getTrips() async {
    final db = await database;
    final maps = await db.query('trips');
    return maps.map((m) => Trip.fromMap(m)).toList();
  }

  static Future<void> insertTrip(Trip trip) async {
    final db = await database;
    await db.insert('trips', trip.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateTrip(Trip trip) async {
    final db = await database;
    await db.update('trips', trip.toMap(), where: 'id = ?', whereArgs: [trip.id]);
  }

  static Future<void> deleteTrip(String id) async {
    final db = await database;
    await db.delete('trips', where: 'id = ?', whereArgs: [id]);
  }

  // ── Friends ────────────────────────────────────────────
  static Future<List<Friend>> getFriends() async {
    final db = await database;
    final maps = await db.query('friends');
    return maps.map((m) => Friend.fromMap(m)).toList();
  }

  static Future<void> insertFriend(Friend f) async {
    final db = await database;
    await db.insert('friends', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateFriend(Friend f) async {
    final db = await database;
    await db.update('friends', f.toMap(), where: 'id = ?', whereArgs: [f.id]);
  }

  static Future<void> deleteFriend(String id) async {
    final db = await database;
    await db.delete('friends', where: 'id = ?', whereArgs: [id]);
  }

  // ── Chat Messages ─────────────────────────────────────
  static Future<List<ChatMessage>> getMessages() async {
    final db = await database;
    final maps = await db.query('chat_messages', orderBy: 'timestamp ASC');
    return maps.map((m) => ChatMessage.fromMap(m)).toList();
  }

  static Future<void> insertMessage(ChatMessage m) async {
    final db = await database;
    await db.insert('chat_messages', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateMessage(ChatMessage m) async {
    final db = await database;
    await db.update('chat_messages', m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  static Future<void> deleteMessage(String id) async {
    final db = await database;
    await db.delete('chat_messages', where: 'id = ?', whereArgs: [id]);
  }

  // ── Budget Expenses ───────────────────────────────────
  static Future<List<BudgetExpense>> getExpenses() async {
    final db = await database;
    final maps = await db.query('budget_expenses', orderBy: 'date DESC');
    return maps.map((m) => BudgetExpense.fromMap(m)).toList();
  }

  static Future<void> insertExpense(BudgetExpense e) async {
    final db = await database;
    await db.insert('budget_expenses', e.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete('budget_expenses', where: 'id = ?', whereArgs: [id]);
  }

  // ── Trip Members ──────────────────────────────────────
  static Future<List<TripMember>> getMembers() async {
    final db = await database;
    final maps = await db.query('trip_members');
    return maps.map((m) => TripMember.fromMap(m)).toList();
  }

  static Future<void> insertMember(TripMember m) async {
    final db = await database;
    await db.insert('trip_members', m.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateMember(TripMember m) async {
    final db = await database;
    await db.update('trip_members', m.toMap(), where: 'id = ?', whereArgs: [m.id]);
  }

  static Future<void> deleteMember(String id) async {
    final db = await database;
    await db.delete('trip_members', where: 'id = ?', whereArgs: [id]);
  }

  // ── Agreements ────────────────────────────────────────
  static Future<List<Agreement>> getAgreements() async {
    final db = await database;
    final maps = await db.query('agreements');
    return maps.map((m) => Agreement.fromMap(m)).toList();
  }

  static Future<void> insertAgreement(Agreement a) async {
    final db = await database;
    await db.insert('agreements', a.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateAgreement(Agreement a) async {
    final db = await database;
    await db.update('agreements', a.toMap(), where: 'id = ?', whereArgs: [a.id]);
  }

  static Future<void> deleteAgreement(String id) async {
    final db = await database;
    await db.delete('agreements', where: 'id = ?', whereArgs: [id]);
  }
}
