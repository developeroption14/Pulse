import 'package:intl/intl.dart';

class Formatters {
  // ═══════════════════════════════════════════════════════════
  // CURRENCY
  // ═══════════════════════════════════════════════════════════

  /// Format amount with currency symbol
  /// Example: 1234.56 → "৳1,234.56"
  static String currency(double amount, {String symbol = '৳'}) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return '$symbol${formatter.format(amount)}';
  }

  /// Format amount without symbol
  /// Example: 1234.56 → "1,234.56"
  static String number(double amount) {
    final formatter = NumberFormat('#,##0.##', 'en_US');
    return formatter.format(amount);
  }

  /// Format as compact (1.2K, 1.5M)
  /// Example: 1234 → "1.2K"
  static String compact(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  // ═══════════════════════════════════════════════════════════
  // DATE
  // ═══════════════════════════════════════════════════════════

  /// Full date
  /// Example: "October 11, 2026"
  static String fullDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Short date
  /// Example: "Oct 11"
  static String shortDate(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Day and month
  /// Example: "Oct 11, 2026"
  static String dayMonth(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  /// Time
  /// Example: "3:45 PM"
  static String time(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Full date + time
  /// Example: "Oct 11, 2026 at 3:45 PM"
  static String fullDateTime(DateTime date) {
    return DateFormat('MMM d, y \'at\' h:mm a').format(date);
  }

  /// Month and year
  /// Example: "October 2026"
  static String monthYear(DateTime date) {
    return DateFormat('MMMM y').format(date);
  }

  /// Short month
  /// Example: "Oct"
  static String shortMonth(DateTime date) {
    return DateFormat('MMM').format(date);
  }

  /// Day name
  /// Example: "Friday"
  static String dayName(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Short day name
  /// Example: "Fri"
  static String shortDayName(DateTime date) {
    return DateFormat('EEE').format(date);
  }

  // ═══════════════════════════════════════════════════════════
  // RELATIVE TIME
  // ═══════════════════════════════════════════════════════════

  /// Relative time
  /// Example: "2 hours ago", "Yesterday", "Today"
  static String relative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    final diffDays = today.difference(dateOnly).inDays;

    if (diffDays == 0) {
      // Today
      final diffHours = now.difference(date).inHours;
      if (diffHours < 1) {
        final diffMinutes = now.difference(date).inMinutes;
        if (diffMinutes < 1) return 'Just now';
        return '$diffMinutes min ago';
      }
      if (diffHours < 24) return '$diffHours h ago';
      return 'Today';
    } else if (diffDays == 1) {
      return 'Yesterday';
    } else if (diffDays < 7) {
      return '$diffDays days ago';
    } else if (diffDays < 30) {
      final weeks = (diffDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (diffDays < 365) {
      final months = (diffDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      final years = (diffDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    }
  }

  /// Short relative time
  /// Example: "2h", "Yesterday", "Today"
  static String shortRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    final diffDays = today.difference(dateOnly).inDays;

    if (diffDays == 0) return 'Today';
    if (diffDays == 1) return 'Yesterday';
    if (diffDays < 7) return '${diffDays}d ago';
    return shortDate(date);
  }

  // ═══════════════════════════════════════════════════════════
  // PERCENTAGE
  // ═══════════════════════════════════════════════════════════

  /// Format as percentage
  /// Example: 0.75 → "75%"
  static String percent(double value, {int decimals = 0}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  /// Format as percentage with sign
  /// Example: 0.75 → "+75%" or 0.25 → "25%"
  static String percentWithSign(double value) {
    final p = (value * 100).toStringAsFixed(0);
    return value >= 0 ? '+$p%' : '$p%';
  }

  // ═══════════════════════════════════════════════════════════
  // DATE RANGE HELPERS
  // ═══════════════════════════════════════════════════════════

  /// Get start of today
  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get start of this week (Monday)
  static DateTime startOfWeek() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return DateTime(now.year, now.month, now.day - weekday + 1);
  }

  /// Get start of this month
  static DateTime startOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Get start of this year
  static DateTime startOfYear() {
    final now = DateTime.now();
    return DateTime(now.year, 1, 1);
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ═══════════════════════════════════════════════════════════
  // GREETING
  // ═══════════════════════════════════════════════════════════

  /// Get greeting based on time of day
  static String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    if (hour < 21) return 'Good evening';
    return 'Good night';
  }
}