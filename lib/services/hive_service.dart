import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

// ═══════════════════════════════════════════════════════════
// HIVE SERVICE — Database initialization and management
// ═══════════════════════════════════════════════════════════

class HiveService {
  // Box names
  static const String expensesBox = 'expenses';
  static const String settingsBox = 'settings';

  HiveService._();

  // ═══════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ExpenseAdapter());
    }

    await Hive.openBox<Expense>(expensesBox);
    await Hive.openBox(settingsBox);

    // Set default currency if not set
    if (!settings.containsKey('currency_code')) {
      await settings.put('currency_code', 'USD');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // BOX ACCESS
  // ═══════════════════════════════════════════════════════════

  static Box<Expense> get expenses => Hive.box<Expense>(expensesBox);
  static Box get settings => Hive.box(settingsBox);

  // ═══════════════════════════════════════════════════════════
  // SETTINGS HELPERS
  // ═══════════════════════════════════════════════════════════

  static Future<void> setSetting(String key, dynamic value) async {
    await settings.put(key, value);
  }

  static T getSetting<T>(String key, T defaultValue) {
    return settings.get(key, defaultValue: defaultValue) as T;
  }

  static Future<void> removeSetting(String key) async {
    await settings.delete(key);
  }

  // ═══════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════

  static Future<void> clearAllExpenses() async {
    await expenses.clear();
  }

  static Future<void> clearAllSettings() async {
    await settings.clear();
  }

  static Future<void> clearEverything() async {
    await clearAllExpenses();
    await clearAllSettings();
  }

  // ═══════════════════════════════════════════════════════════
  // STATS
  // ═══════════════════════════════════════════════════════════

  static int get expenseCount => expenses.length;
  static bool get isEmpty => expenses.isEmpty;
}