import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static Future<Database>? _opening;
  static const Duration _openTimeout = Duration(seconds: 20);

  /// Ensures DB is open before UI providers run heavy queries.
  static Future<void> warmUp() async {
    try {
      await _instance.database.timeout(_openTimeout);
    } catch (e, st) {
      // ignore: avoid_print
      print('Database warmUp failed: $e\n$st');
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _opening ??= _initDatabase();
    try {
      _database = await _opening!.timeout(_openTimeout);
      return _database!;
    } on TimeoutException {
      _opening = null;
      rethrow;
    } catch (e) {
      _opening = null;
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    final path = await _resolveDatabasePath();

    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await _repairSchema(db);
      },
    );
  }

  static Future<String> _resolveDatabasePath() async {
    if (kIsWeb) {
      return 'beth_app.db';
    }
    final databasesPath = await getDatabasesPath();
    return join(databasesPath, 'beth_app.db');
  }

  /// Close and delete local DB (e.g. corrupted IndexedDB on web).
  static Future<void> resetLocalDatabase() async {
    final path = await _resolveDatabasePath();
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    _opening = null;
    await deleteDatabase(path);
  }

  Future<void> _repairSchema(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS people (
        id TEXT PRIMARY KEY,
        display_name TEXT NOT NULL,
        legal_name TEXT,
        preferred_name TEXT,
        pronouns TEXT,
        gender_identity TEXT,
        relationship_to_user TEXT NOT NULL,
        date_of_birth TEXT,
        age_stage TEXT DEFAULT 'adult',
        profile_type TEXT DEFAULT 'household_member',
        colour_icon TEXT,
        calendar_category_id TEXT,
        calendar_birthday_event_id TEXT,
        privacy_level TEXT DEFAULT 'standard',
        lives_with_me INTEGER DEFAULT 1,
        notes TEXT,
        feature_toggles TEXT DEFAULT '{}',
        species TEXT,
        breed TEXT,
        teen_privacy_json TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await _addColumnIfMissing(db, 'people', 'legal_name', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'preferred_name', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'pronouns', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'gender_identity', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'feature_toggles', "TEXT DEFAULT '{}'");
    await _addColumnIfMissing(db, 'people', 'calendar_birthday_event_id', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'calendar_category_id', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'species', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'breed', 'TEXT');
    await _addColumnIfMissing(db, 'people', 'teen_privacy_json', "TEXT DEFAULT '{}'");
    await _addColumnIfMissing(db, 'event_categories', 'person_id', 'TEXT');
    await _addColumnIfMissing(db, 'medications', 'person_id', 'TEXT');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE capture_entries (
          id TEXT PRIMARY KEY,
          raw_text TEXT NOT NULL,
          input_type TEXT NOT NULL DEFAULT 'text',
          pipeline_status TEXT,
          response_text TEXT,
          category TEXT,
          priority TEXT,
          emotional_signal TEXT,
          clarify_thread TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
      await db.execute('''
        CREATE TABLE people (
          id TEXT PRIMARY KEY,
          display_name TEXT NOT NULL,
          relationship_to_user TEXT NOT NULL,
          date_of_birth TEXT,
          age_stage TEXT DEFAULT 'adult',
          profile_type TEXT DEFAULT 'household_member',
          colour_icon TEXT,
          privacy_level TEXT DEFAULT 'standard',
          lives_with_me INTEGER DEFAULT 1,
          notes TEXT,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
    if (oldVersion < 3) {
      await _addColumnIfMissing(db, 'people', 'legal_name', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'preferred_name', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'pronouns', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'gender_identity', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'feature_toggles', "TEXT DEFAULT '{}'");
      await _addColumnIfMissing(db, 'people', 'calendar_birthday_event_id', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'calendar_category_id', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'species', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'breed', 'TEXT');
      await _addColumnIfMissing(db, 'people', 'teen_privacy_json', "TEXT DEFAULT '{}'");
    }
    if (oldVersion < 4) {
      await _addColumnIfMissing(db, 'calendar_events', 'person_id', 'TEXT');
      await _addColumnIfMissing(db, 'calendar_events', 'source', "TEXT DEFAULT 'manual'");
      await _addColumnIfMissing(db, 'calendar_events', 'priority', "TEXT DEFAULT 'normal'");
      await _addColumnIfMissing(db, 'calendar_events', 'event_type', 'TEXT');
      await _addColumnIfMissing(db, 'calendar_events', 'start_time', 'TEXT');
      await _addColumnIfMissing(db, 'medications', 'person_id', 'TEXT');
      await _addColumnIfMissing(db, 'feeding_logs', 'person_id', 'TEXT');
      await _addColumnIfMissing(db, 'nap_logs', 'person_id', 'TEXT');
      await _addColumnIfMissing(db, 'growth_notes', 'person_id', 'TEXT');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS care_activity_logs (
          id TEXT PRIMARY KEY,
          person_id TEXT NOT NULL,
          log_type TEXT NOT NULL,
          detail TEXT NOT NULL,
          logged_at TEXT NOT NULL,
          metadata TEXT
        )
      ''');
      await _addColumnIfMissing(db, 'event_categories', 'person_id', 'TEXT');
    }
    if (oldVersion < 5) {
      await _repairSchema(db);
    }
  }

  Future<void> _addColumnIfMissing(Database db, String table, String column, String type) async {
    final info = await db.rawQuery('PRAGMA table_info($table)');
    final exists = info.any((row) => row['name'] == column);
    if (!exists) {
      await db.execute('ALTER TABLE $table ADD COLUMN $column $type');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Calendar events
    await db.execute('''
      CREATE TABLE calendar_events (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        start_time TEXT,
        end_time TEXT,
        is_all_day INTEGER DEFAULT 0,
        recurrence TEXT,
        category_id TEXT,
        emoji TEXT,
        location TEXT,
        notes TEXT,
        person_id TEXT,
        source TEXT DEFAULT 'manual',
        priority TEXT DEFAULT 'normal',
        event_type TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Event categories
    await db.execute('''
      CREATE TABLE event_categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        colour TEXT NOT NULL,
        icon TEXT,
        sort_order INTEGER DEFAULT 0,
        person_id TEXT
      )
    ''');

    // Children
    await db.execute('''
      CREATE TABLE children (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date_of_birth TEXT NOT NULL,
        age_group TEXT NOT NULL,
        feature_toggles TEXT DEFAULT '{}',
        teen_app_invite_sent INTEGER DEFAULT 0,
        relationship_type TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Medications
    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        child_id TEXT,
        person_id TEXT,
        name TEXT NOT NULL,
        dose REAL NOT NULL,
        dose_unit TEXT NOT NULL,
        minimum_interval_hours INTEGER,
        minimum_interval_minutes INTEGER,
        scheduled_times TEXT DEFAULT '',
        notes TEXT,
        mode TEXT NOT NULL DEFAULT 'as_needed',
        last_given TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (child_id) REFERENCES children(id)
      )
    ''');

    // Medication log
    await db.execute('''
      CREATE TABLE medication_logs (
        id TEXT PRIMARY KEY,
        medication_id TEXT NOT NULL,
        given_at TEXT NOT NULL,
        dose_given REAL NOT NULL,
        notes TEXT,
        FOREIGN KEY (medication_id) REFERENCES medications(id)
      )
    ''');

    // Tasks
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        priority TEXT DEFAULT 'medium',
        deadline TEXT,
        category_id TEXT,
        notes TEXT,
        assigned_instance_id TEXT,
        status TEXT DEFAULT 'active',
        completed_at TEXT,
        snoozed_until TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Budget entries
    await db.execute('''
      CREATE TABLE budget_entries (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        category_id TEXT NOT NULL,
        date TEXT NOT NULL,
        note TEXT,
        is_recurring INTEGER DEFAULT 0,
        source TEXT,
        shared_with_ant INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Budget categories
    await db.execute('''
      CREATE TABLE budget_categories (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        colour TEXT NOT NULL,
        budget_amount REAL DEFAULT 0,
        period TEXT DEFAULT 'monthly',
        shared_with_ant INTEGER DEFAULT 0
      )
    ''');

    // Cycle entries
    await db.execute('''
      CREATE TABLE cycle_entries (
        id TEXT PRIMARY KEY,
        period_start_date TEXT NOT NULL,
        period_end_date TEXT,
        flow_intensity TEXT,
        symptoms TEXT DEFAULT '',
        energy_level INTEGER,
        notes TEXT,
        shared_with_rhen INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Messages (chat history)
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        instance_id TEXT NOT NULL,
        content TEXT NOT NULL,
        role TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // Settings
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Notification log
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        tier TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        data TEXT,
        is_read INTEGER DEFAULT 0,
        is_dismissed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');

    // Growth notes (children)
    await db.execute('''
      CREATE TABLE growth_notes (
        id TEXT PRIMARY KEY,
        child_id TEXT NOT NULL,
        date TEXT NOT NULL,
        weight_kg REAL,
        height_cm REAL,
        head_circumference_cm REAL,
        notes TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (child_id) REFERENCES children(id)
      )
    ''');

    // Feeding logs (baby)
    await db.execute('''
      CREATE TABLE feeding_logs (
        id TEXT PRIMARY KEY,
        child_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        type TEXT NOT NULL,
        duration_minutes INTEGER,
        notes TEXT,
        FOREIGN KEY (child_id) REFERENCES children(id)
      )
    ''');

    // Nap logs (baby)
    await db.execute('''
      CREATE TABLE nap_logs (
        id TEXT PRIMARY KEY,
        child_id TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        notes TEXT,
        FOREIGN KEY (child_id) REFERENCES children(id)
      )
    ''');

    // Insert default event categories
    final defaultCategories = [
      {'id': 'evander', 'name': 'Evander', 'colour': '#90CAF9', 'icon': '👶', 'sort_order': 1},
      {'id': 'ant', 'name': 'Ant', 'colour': '#388E3C', 'icon': '👤', 'sort_order': 2},
      {'id': 'beth', 'name': 'Beth', 'colour': '#FFB74D', 'icon': '👤', 'sort_order': 3},
      {'id': 'family', 'name': 'Family', 'colour': '#CE93D8', 'icon': '👨‍👩‍👦', 'sort_order': 4},
      {'id': 'work', 'name': 'Work', 'colour': '#FF7043', 'icon': '💼', 'sort_order': 5},
      {'id': 'parents', 'name': 'Parents', 'colour': '#26A69A', 'icon': '👥', 'sort_order': 6},
      {'id': 'social', 'name': 'Social', 'colour': '#EC407A', 'icon': '🎉', 'sort_order': 7},
    ];

    for (final cat in defaultCategories) {
      await db.insert('event_categories', cat);
    }

    // Insert default settings
    final defaultSettings = {
      'affirmation_source': 'ai_generated',
      'default_calendar_view': 'week',
      'week_starts_on': 'monday',
      'notification_mode': 'digest',
      'digest_time': '07:00',
      'status_shield_default': 'open_to_leads',
      'status_shield_auto_expiry': 'end_of_day',
      'ghost_log_auto_submit': 'false',
      'ghost_log_detail_level': 'standard',
    };

    for (final entry in defaultSettings.entries) {
      await db.insert('settings', {'key': entry.key, 'value': entry.value});
    }

    await db.execute('''
      CREATE TABLE capture_entries (
        id TEXT PRIMARY KEY,
        raw_text TEXT NOT NULL,
        input_type TEXT NOT NULL DEFAULT 'text',
        pipeline_status TEXT,
        response_text TEXT,
        category TEXT,
        priority TEXT,
        emotional_signal TEXT,
        clarify_thread TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE people (
        id TEXT PRIMARY KEY,
        display_name TEXT NOT NULL,
        legal_name TEXT,
        preferred_name TEXT,
        pronouns TEXT,
        gender_identity TEXT,
        relationship_to_user TEXT NOT NULL,
        date_of_birth TEXT,
        age_stage TEXT DEFAULT 'adult',
        profile_type TEXT DEFAULT 'household_member',
        colour_icon TEXT,
        calendar_category_id TEXT,
        calendar_birthday_event_id TEXT,
        privacy_level TEXT DEFAULT 'standard',
        lives_with_me INTEGER DEFAULT 1,
        notes TEXT,
        feature_toggles TEXT DEFAULT '{}',
        species TEXT,
        breed TEXT,
        teen_privacy_json TEXT DEFAULT '{}',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE care_activity_logs (
        id TEXT PRIMARY KEY,
        person_id TEXT NOT NULL,
        log_type TEXT NOT NULL,
        detail TEXT NOT NULL,
        logged_at TEXT NOT NULL,
        metadata TEXT
      )
    ''');
  }
}