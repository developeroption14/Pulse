import 'package:hive/hive.dart';
import '../utils/categories.dart';
import 'mood.dart';
part 'expense.g.dart';

// ═══════════════════════════════════════════════════════════
// EXPENSE MODEL — The core data of the app
// ═══════════════════════════════════════════════════════════

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String categoryId;

  @HiveField(3)
  final String moodId;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.categoryId,
    required this.moodId,
    this.note = '',
    required this.date,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // ═══════════════════════════════════════════════════════════
  // CONVENIENCE GETTERS
  // ═══════════════════════════════════════════════════════════

  /// Get the full category object
  ExpenseCategory get category => getCategoryById(categoryId);

  /// Get the full mood object
  Mood get mood => MoodInfo.fromId(moodId);

  /// Get the life area of this expense
  LifeArea get lifeArea => category.lifeArea;

  /// Does this have a note?
  bool get hasNote => note.trim().isNotEmpty;

  // ═══════════════════════════════════════════════════════════
  // COPY WITH — For updates
  // ═══════════════════════════════════════════════════════════

  Expense copyWith({
    String? id,
    double? amount,
    String? categoryId,
    String? moodId,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      moodId: moodId ?? this.moodId,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ═══════════════════════════════════════════════════════════
  // SERIALIZATION (for backup/export)
  // ═══════════════════════════════════════════════════════════

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'categoryId': categoryId,
      'moodId': moodId,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['categoryId'] as String,
      moodId: map['moodId'] as String,
      note: map['note'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // TO STRING (for debugging)
  // ═══════════════════════════════════════════════════════════

  @override
  String toString() {
    return 'Expense(id: $id, amount: $amount, '
        'category: ${category.name}, mood: ${mood.label}, '
        'note: $note, date: $date)';
  }
}