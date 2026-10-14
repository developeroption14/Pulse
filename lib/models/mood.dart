import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ═══════════════════════════════════════════════════════════
// MOOD — The emotional state when you spent money
// ═══════════════════════════════════════════════════════════

enum Mood {
  happy,        // 😊 Feeling good, satisfied
  neutral,      // 😐 Just a normal purchase
  stressed,     // 😔 Anxious, worried
  celebrating,  // 🎉 Reward, celebration
  tired,        // 😴 Exhausted, lazy purchase
}

extension MoodInfo on Mood {
  /// Display name
  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.neutral:
        return 'Neutral';
      case Mood.stressed:
        return 'Stressed';
      case Mood.celebrating:
        return 'Celebrating';
      case Mood.tired:
        return 'Tired';
    }
  }

  /// Emoji for UI
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.neutral:
        return '😐';
      case Mood.stressed:
        return '😔';
      case Mood.celebrating:
        return '🎉';
      case Mood.tired:
        return '😴';
    }
  }

  /// Color for UI
  Color get color {
    switch (this) {
      case Mood.happy:
        return AppTheme.moodHappy;
      case Mood.neutral:
        return AppTheme.moodNeutral;
      case Mood.stressed:
        return AppTheme.moodStressed;
      case Mood.celebrating:
        return AppTheme.moodCelebrating;
      case Mood.tired:
        return AppTheme.moodTired;
    }
  }

  /// Descriptive message (used in insights)
  String get description {
    switch (this) {
      case Mood.happy:
        return 'You felt good about this';
      case Mood.neutral:
        return 'Just a routine purchase';
      case Mood.stressed:
        return 'Spent while anxious or worried';
      case Mood.celebrating:
        return 'A reward or celebration';
      case Mood.tired:
        return 'Spent out of laziness or fatigue';
    }
  }

  /// String identifier (for storage)
  String get id => name;

  /// Get Mood from string id
  static Mood fromId(String id) {
    return Mood.values.firstWhere(
      (m) => m.name == id,
      orElse: () => Mood.neutral,
    );
  }
}

// ═══════════════════════════════════════════════════════════
// HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════

/// Get mood by id (safe fallback to neutral)
Mood getMoodById(String id) => MoodInfo.fromId(id);

/// All moods as a list
List<Mood> get allMoods => Mood.values;
// ═══════════════════════════════════════════════════════════
// DIRECT HELPER FUNCTIONS (fallback if extension fails)
// ═══════════════════════════════════════════════════════════

String moodEmoji(Mood mood) {
  switch (mood) {
    case Mood.happy:
      return '😊';
    case Mood.neutral:
      return '😐';
    case Mood.stressed:
      return '😔';
    case Mood.celebrating:
      return '🎉';
    case Mood.tired:
      return '😴';
  }
}

String moodLabel(Mood mood) {
  switch (mood) {
    case Mood.happy:
      return 'Happy';
    case Mood.neutral:
      return 'Neutral';
    case Mood.stressed:
      return 'Stressed';
    case Mood.celebrating:
      return 'Celebrating';
    case Mood.tired:
      return 'Tired';
  }
}

Color moodColor(Mood mood) {
  switch (mood) {
    case Mood.happy:
      return AppTheme.moodHappy;
    case Mood.neutral:
      return AppTheme.moodNeutral;
    case Mood.stressed:
      return AppTheme.moodStressed;
    case Mood.celebrating:
      return AppTheme.moodCelebrating;
    case Mood.tired:
      return AppTheme.moodTired;
  }
}