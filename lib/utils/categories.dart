import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
// LIFE AREAS (How money flows into different parts of life)
// ═══════════════════════════════════════════════════════════

enum LifeArea {
  health,        // ❤️ Physical & mental health
  growth,        // 🧠 Learning, skills, future self
  relationships, // 🤝 Family, friends, love
  comfort,       // 🛋️ Convenience, relaxation
  status,        // 📱 Image, appearance, social
  fun,           // 🎉 Entertainment, joy
}

extension LifeAreaInfo on LifeArea {
  String get label {
    switch (this) {
      case LifeArea.health:
        return 'Health';
      case LifeArea.growth:
        return 'Growth';
      case LifeArea.relationships:
        return 'Relationships';
      case LifeArea.comfort:
        return 'Comfort';
      case LifeArea.status:
        return 'Status';
      case LifeArea.fun:
        return 'Fun';
    }
  }

  String get emoji {
    switch (this) {
      case LifeArea.health:
        return '❤️';
      case LifeArea.growth:
        return '🧠';
      case LifeArea.relationships:
        return '🤝';
      case LifeArea.comfort:
        return '🛋️';
      case LifeArea.status:
        return '📱';
      case LifeArea.fun:
        return '🎉';
    }
  }

  Color get color {
    switch (this) {
      case LifeArea.health:
        return AppTheme.rose;
      case LifeArea.growth:
        return AppTheme.violet;
      case LifeArea.relationships:
        return AppTheme.pink;
      case LifeArea.comfort:
        return AppTheme.amber;
      case LifeArea.status:
        return AppTheme.blue;
      case LifeArea.fun:
        return AppTheme.orange;
    }
  }
}

// ═══════════════════════════════════════════════════════════
// CATEGORIES (Each category belongs to a Life Area)
// ═══════════════════════════════════════════════════════════

class ExpenseCategory {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final LifeArea lifeArea;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    required this.lifeArea,
  });
}

const List<ExpenseCategory> kCategories = [
  // ═══════════ HEALTH ❤️ ═══════════
  ExpenseCategory(
    id: 'food',
    name: 'Food',
    emoji: '🍔',
    color: AppTheme.rose,
    lifeArea: LifeArea.health,
  ),
  ExpenseCategory(
    id: 'health',
    name: 'Health',
    emoji: '💊',
    color: AppTheme.emerald,
    lifeArea: LifeArea.health,
  ),
  ExpenseCategory(
    id: 'gym',
    name: 'Gym',
    emoji: '🏋️',
    color: AppTheme.red,
    lifeArea: LifeArea.health,
  ),

  // ═══════════ GROWTH 🧠 ═══════════
  ExpenseCategory(
    id: 'education',
    name: 'Education',
    emoji: '📚',
    color: AppTheme.violet,
    lifeArea: LifeArea.growth,
  ),
  ExpenseCategory(
    id: 'courses',
    name: 'Courses',
    emoji: '🎓',
    color: AppTheme.blue,
    lifeArea: LifeArea.growth,
  ),
  ExpenseCategory(
    id: 'books',
    name: 'Books',
    emoji: '📖',
    color: AppTheme.cyan,
    lifeArea: LifeArea.growth,
  ),

  // ═══════════ RELATIONSHIPS 🤝 ═══════════
  ExpenseCategory(
    id: 'family',
    name: 'Family',
    emoji: '👨‍👩‍👧',
    color: AppTheme.pink,
    lifeArea: LifeArea.relationships,
  ),
  ExpenseCategory(
    id: 'gifts',
    name: 'Gifts',
    emoji: '🎁',
    color: AppTheme.rose,
    lifeArea: LifeArea.relationships,
  ),
  ExpenseCategory(
    id: 'dining_out',
    name: 'Dining Out',
    emoji: '🍽️',
    color: AppTheme.orange,
    lifeArea: LifeArea.relationships,
  ),

  // ═══════════ COMFORT 🛋️ ═══════════
  ExpenseCategory(
    id: 'transport',
    name: 'Transport',
    emoji: '🚕',
    color: AppTheme.amber,
    lifeArea: LifeArea.comfort,
  ),
  ExpenseCategory(
    id: 'rent',
    name: 'Rent',
    emoji: '🏠',
    color: AppTheme.amber,
    lifeArea: LifeArea.comfort,
  ),
  ExpenseCategory(
    id: 'bills',
    name: 'Bills',
    emoji: '💡',
    color: AppTheme.orange,
    lifeArea: LifeArea.comfort,
  ),
  ExpenseCategory(
    id: 'subscriptions',
    name: 'Subscriptions',
    emoji: '📺',
    color: AppTheme.pink,
    lifeArea: LifeArea.comfort,
  ),

  // ═══════════ STATUS 📱 ═══════════
  ExpenseCategory(
    id: 'shopping',
    name: 'Shopping',
    emoji: '🛍️',
    color: AppTheme.pink,
    lifeArea: LifeArea.status,
  ),
  ExpenseCategory(
    id: 'fashion',
    name: 'Fashion',
    emoji: '👕',
    color: AppTheme.violet,
    lifeArea: LifeArea.status,
  ),
  ExpenseCategory(
    id: 'gadgets',
    name: 'Gadgets',
    emoji: '📱',
    color: AppTheme.blue,
    lifeArea: LifeArea.status,
  ),

  // ═══════════ FUN 🎉 ═══════════
  ExpenseCategory(
    id: 'entertainment',
    name: 'Entertainment',
    emoji: '🎬',
    color: AppTheme.orange,
    lifeArea: LifeArea.fun,
  ),
  ExpenseCategory(
    id: 'games',
    name: 'Games',
    emoji: '🎮',
    color: AppTheme.violet,
    lifeArea: LifeArea.fun,
  ),
  ExpenseCategory(
    id: 'travel',
    name: 'Travel',
    emoji: '✈️',
    color: AppTheme.cyan,
    lifeArea: LifeArea.fun,
  ),
  ExpenseCategory(
    id: 'other',
    name: 'Other',
    emoji: '💸',
    color: AppTheme.textSecondary,
    lifeArea: LifeArea.fun,
  ),
];

// ═══════════════════════════════════════════════════════════
// HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════

/// Get category by id
ExpenseCategory getCategoryById(String id) {
  return kCategories.firstWhere(
    (cat) => cat.id == id,
    orElse: () => kCategories.last, // 'other' as fallback
  );
}

/// Get all categories for a specific life area
List<ExpenseCategory> getCategoriesByLifeArea(LifeArea area) {
  return kCategories.where((cat) => cat.lifeArea == area).toList();
}

/// Get all unique life areas from a list of category ids
Set<LifeArea> getLifeAreasFromCategories(List<String> categoryIds) {
  return categoryIds
      .map((id) => getCategoryById(id).lifeArea)
      .toSet();
}