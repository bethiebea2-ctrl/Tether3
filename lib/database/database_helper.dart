import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'beth_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
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
        sort_order INTEGER DEFAULT 0
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
  }
}