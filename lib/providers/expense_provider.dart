import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/hive_service.dart';
import '../utils/currencies.dart';

// ═══════════════════════════════════════════════════════════
// EXPENSE PROVIDER — State management for the whole app
// ═══════════════════════════════════════════════════════════

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _allExpenses = [];
  bool _isLoading = true;
  String _currencyCode = 'USD';

  // ═══════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════

  List<Expense> get allExpenses => _allExpenses;
  bool get isLoading => _isLoading;

  // Currency (from settings, kept in sync)
  String get currencyCode => _currencyCode;
  String get currencySymbol => getCurrencyByCode(_currencyCode).symbol;
  Currency get currency => getCurrencyByCode(_currencyCode);

  // Filtered lists
  List<Expense> get todayExpenses => ExpenseService.getTodayExpenses();
  List<Expense> get weekExpenses => ExpenseService.getThisWeekExpenses();
  List<Expense> get monthExpenses => ExpenseService.getThisMonthExpenses();
  List<Expense> get yearExpenses => ExpenseService.getThisYearExpenses();
  List<Expense> get recentExpenses =>
      ExpenseService.getRecentExpenses(limit: 10);

  // Totals
  double get todayTotal => ExpenseService.todayTotal;
  double get weekTotal => ExpenseService.weekTotal;
  double get monthTotal => ExpenseService.monthTotal;
  double get yearTotal => ExpenseService.yearTotal;
  double get allTimeTotal => ExpenseService.allTimeTotal;

  // Stats
  int get expenseCount => _allExpenses.length;
  bool get isEmpty => _allExpenses.isEmpty;

  // ═══════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════

  /// Load all expenses and current currency from Hive
  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    _allExpenses = ExpenseService.getAllExpenses();
    _currencyCode = HiveService.getSetting('currency_code', 'USD');

    _isLoading = false;
    notifyListeners();
  }

  /// Update the currency (called from Settings screen)
  Future<void> setCurrency(String code) async {
    await HiveService.setSetting('currency_code', code);
    _currencyCode = code;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // ACTIONS
  // ═══════════════════════════════════════════════════════════

  Future<void> addExpense({
    required double amount,
    required String categoryId,
    required String moodId,
    String note = '',
    DateTime? date,
  }) async {
    await ExpenseService.addExpense(
      amount: amount,
      categoryId: categoryId,
      moodId: moodId,
      note: note,
      date: date,
    );

    await _refresh();
  }

  Future<void> updateExpense(Expense expense) async {
    await ExpenseService.updateExpense(expense);
    await _refresh();
  }

  Future<void> deleteExpense(String id) async {
    await ExpenseService.deleteExpense(id);
    await _refresh();
  }

  Future<void> deleteAll() async {
    await ExpenseService.deleteAllExpenses();
    await _refresh();
  }

  // ═══════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════

  List<Expense> getExpensesInRange(DateTime start, DateTime end) {
    return ExpenseService.getExpensesInRange(start, end);
  }

  List<Expense> getByCategory(String categoryId) {
    return _allExpenses.where((e) => e.categoryId == categoryId).toList();
  }

  List<Expense> getByMood(String moodId) {
    return _allExpenses.where((e) => e.moodId == moodId).toList();
  }

  Expense? getById(String id) {
    return ExpenseService.getExpenseById(id);
  }

  // ═══════════════════════════════════════════════════════════
  // ANALYTICS
  // ═══════════════════════════════════════════════════════════

  Map<String, double> categoryBreakdown({String period = 'month'}) {
    final expenses = _expensesForPeriod(period);
    return ExpenseService.getByCategory(expenses);
  }

  Map<String, double> moodBreakdown({String period = 'month'}) {
    final expenses = _expensesForPeriod(period);
    return ExpenseService.getByMood(expenses);
  }

  Map<String, double> lifeAreaBreakdown({String period = 'month'}) {
    final expenses = _expensesForPeriod(period);
    return ExpenseService.getByLifeArea(expenses);
  }

  Map<DateTime, double> dailyTotals({int days = 7}) {
    return ExpenseService.getDailyTotals(days: days);
  }

  Expense? get biggestExpenseThisMonth {
    return ExpenseService.biggestOf(monthExpenses);
  }

  double get averageExpenseThisMonth {
    return ExpenseService.averageOf(monthExpenses);
  }

  String? get topMoodThisMonth {
    final map = moodBreakdown(period: 'month');
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String? get topCategoryThisMonth {
    final map = categoryBreakdown(period: 'month');
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  String? get topLifeAreaThisMonth {
    final map = lifeAreaBreakdown(period: 'month');
    if (map.isEmpty) return null;
    return map.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // ═══════════════════════════════════════════════════════════
  // INSIGHTS (auto-generated, currency-aware)
  // ═══════════════════════════════════════════════════════════

  List<String> getInsights() {
    final insights = <String>[];
    final monthExps = monthExpenses;
    final sym = currencySymbol;

    if (monthExps.isEmpty) {
      insights.add('Add your first expense to see insights');
      return insights;
    }

    // 1. TOP MOOD INSIGHT
    final topMood = topMoodThisMonth;
    if (topMood != null) {
      final moodTotal = moodBreakdown(period: 'month')[topMood] ?? 0;
      final percent = (moodTotal / monthTotal * 100).toStringAsFixed(0);
      final moodName = topMood[0].toUpperCase() + topMood.substring(1);
      insights.add(
        'You spent $percent% of your money while feeling "$moodName"',
      );
    }

    // 2. BIGGEST SINGLE EXPENSE
    final biggest = biggestExpenseThisMonth;
    if (biggest != null) {
      insights.add(
        'Your biggest single expense was $sym${biggest.amount.toStringAsFixed(0)} '
        'on ${biggest.category.name}',
      );
    }

    // 3. COMFORT vs GROWTH
    final lifeMap = lifeAreaBreakdown(period: 'month');
    final comfort = lifeMap['comfort'] ?? 0;
    final growth = lifeMap['growth'] ?? 0;

    if (growth == 0 && comfort > 0) {
      insights.add(
        'You spent $sym${comfort.toStringAsFixed(0)} on Comfort but '
        'nothing on Growth. Try investing in yourself!',
      );
    } else if (comfort == 0 && growth > 0) {
      insights.add(
        'Great! You invested $sym${growth.toStringAsFixed(0)} in Growth '
        'with no Comfort spending',
      );
    } else if (comfort > 0 && growth > 0) {
      final ratio = comfort / growth;
      if (ratio > 3) {
        insights.add(
          'You spend ${ratio.toStringAsFixed(1)}x more on Comfort than Growth. '
          'Consider investing more in yourself',
        );
      } else if (ratio < 0.5) {
        insights.add(
          'Great! You spend ${(1 / ratio).toStringAsFixed(1)}x more on '
          'Growth than Comfort',
        );
      } else {
        insights.add('Balanced! You invest equally in Comfort and Growth');
      }
    }

    // 4. AVERAGE PER DAY
    final daysInMonth = DateTime.now().day;
    final avgPerDay = monthTotal / daysInMonth;
    insights.add(
      'You are spending an average of $sym${avgPerDay.toStringAsFixed(0)} per day',
    );

    // 5. TOP CATEGORY
    final catMap = categoryBreakdown(period: 'month');
    if (catMap.isNotEmpty) {
      final topCat = catMap.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      final catPercent = (topCat.value / monthTotal * 100).toStringAsFixed(0);
      final catName = topCat.key[0].toUpperCase() + topCat.key.substring(1);
      insights.add(
        '$catName accounts for $catPercent% of your total spending',
      );
    }

    // 6. STRESS SPENDING
    final stressedTotal = moodBreakdown(period: 'month')['stressed'] ?? 0;
    if (stressedTotal > 0 && stressedTotal / monthTotal > 0.3) {
      final stressPercent =
          (stressedTotal / monthTotal * 100).toStringAsFixed(0);
      insights.add(
        '⚠️ $stressPercent% of your spending happens when stressed. '
        'Watch your emotional spending!',
      );
    }

    // 7. TRANSACTION COUNT
    if (monthExps.length >= 5) {
      insights.add(
        'You made ${monthExps.length} transactions this month — '
        'average $sym${(monthTotal / monthExps.length).toStringAsFixed(0)} each',
      );
    }

    return insights;
  }

  // ═══════════════════════════════════════════════════════════
  // INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════

  List<Expense> _expensesForPeriod(String period) {
    switch (period) {
      case 'today':
        return todayExpenses;
      case 'week':
        return weekExpenses;
      case 'year':
        return yearExpenses;
      case 'all':
        return _allExpenses;
      case 'month':
      default:
        return monthExpenses;
    }
  }

  Future<void> _refresh() async {
    _allExpenses = ExpenseService.getAllExpenses();
    notifyListeners();
  }
}