import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../models/mood.dart';
import '../utils/formatters.dart';
import 'hive_service.dart';

// ═══════════════════════════════════════════════════════════
// EXPENSE SERVICE — All CRUD operations
// ═══════════════════════════════════════════════════════════

class ExpenseService {
  static const _uuid = Uuid();

  // ═══════════════════════════════════════════════════════════
  // CREATE
  // ═══════════════════════════════════════════════════════════

  /// Add a new expense
  static Future<Expense> addExpense({
    required double amount,
    required String categoryId,
    required String moodId,
    String note = '',
    DateTime? date,
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      categoryId: categoryId,
      moodId: moodId,
      note: note,
      date: date ?? DateTime.now(),
    );

    await HiveService.expenses.put(expense.id, expense);
    return expense;
  }

  // ═══════════════════════════════════════════════════════════
  // READ
  // ═══════════════════════════════════════════════════════════

  /// Get all expenses, newest first
  static List<Expense> getAllExpenses() {
    final list = HiveService.expenses.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Get expense by id
  static Expense? getExpenseById(String id) {
    return HiveService.expenses.get(id);
  }

  /// Get expenses for a specific date range
  static List<Expense> getExpensesInRange(DateTime start, DateTime end) {
    final list = HiveService.expenses.values.where((e) {
      return e.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          e.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// Get today's expenses
  static List<Expense> getTodayExpenses() {
    final start = Formatters.startOfToday();
    return getExpensesInRange(start, start.add(const Duration(days: 1)));
  }

  /// Get this week's expenses
  static List<Expense> getThisWeekExpenses() {
    return getExpensesInRange(
      Formatters.startOfWeek(),
      DateTime.now(),
    );
  }

  /// Get this month's expenses
  static List<Expense> getThisMonthExpenses() {
    return getExpensesInRange(
      Formatters.startOfMonth(),
      DateTime.now(),
    );
  }

  /// Get this year's expenses
  static List<Expense> getThisYearExpenses() {
    return getExpensesInRange(
      Formatters.startOfYear(),
      DateTime.now(),
    );
  }

  /// Get recent N expenses
  static List<Expense> getRecentExpenses({int limit = 10}) {
    final list = getAllExpenses();
    return list.take(limit).toList();
  }

  // ═══════════════════════════════════════════════════════════
  // UPDATE
  // ═══════════════════════════════════════════════════════════

  /// Update an existing expense
  static Future<void> updateExpense(Expense expense) async {
    await expense.save();
  }

  // ═══════════════════════════════════════════════════════════
  // DELETE
  // ═══════════════════════════════════════════════════════════

  /// Delete an expense by id
  static Future<void> deleteExpense(String id) async {
    await HiveService.expenses.delete(id);
  }

  /// Delete all expenses
  static Future<void> deleteAllExpenses() async {
    await HiveService.expenses.clear();
  }

  // ═══════════════════════════════════════════════════════════
  // TOTALS
  // ═══════════════════════════════════════════════════════════

  /// Total amount for a list of expenses
  static double totalOf(List<Expense> expenses) {
    return expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Total spent today
  static double get todayTotal => totalOf(getTodayExpenses());

  /// Total spent this week
  static double get weekTotal => totalOf(getThisWeekExpenses());

  /// Total spent this month
  static double get monthTotal => totalOf(getThisMonthExpenses());

  /// Total spent this year
  static double get yearTotal => totalOf(getThisYearExpenses());

  /// Total spent all time
  static double get allTimeTotal => totalOf(getAllExpenses());

  // ═══════════════════════════════════════════════════════════
  // ANALYTICS
  // ═══════════════════════════════════════════════════════════

  /// Group expenses by category (returns Map of categoryId → total)
  static Map<String, double> getByCategory(List<Expense> expenses) {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.categoryId] = (map[e.categoryId] ?? 0) + e.amount;
    }
    return map;
  }

  /// Group expenses by mood (returns Map of moodId → total)
  static Map<String, double> getByMood(List<Expense> expenses) {
    final map = <String, double>{};
    for (final e in expenses) {
      map[e.moodId] = (map[e.moodId] ?? 0) + e.amount;
    }
    return map;
  }

  /// Group expenses by life area
  static Map<String, double> getByLifeArea(List<Expense> expenses) {
    final map = <String, double>{};
    for (final e in expenses) {
      final key = e.lifeArea.name;
      map[key] = (map[key] ?? 0) + e.amount;
    }
    return map;
  }

  /// Average expense amount
  static double averageOf(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return totalOf(expenses) / expenses.length;
  }

  /// Biggest expense in the list
  static Expense? biggestOf(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  /// How much did you spend when in a specific mood?
  static double totalForMood(Mood mood, List<Expense> expenses) {
    return expenses
        .where((e) => e.moodId == mood.name)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Get daily totals for the last N days
  /// Returns Map of date (at midnight) → total
  static Map<DateTime, double> getDailyTotals({int days = 7}) {
    final map = <DateTime, double>{};
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      map[date] = 0;
    }

    for (final e in getAllExpenses()) {
      final eDate = DateTime(e.date.year, e.date.month, e.date.day);
      if (map.containsKey(eDate)) {
        map[eDate] = map[eDate]! + e.amount;
      }
    }

    return map;
  }
}