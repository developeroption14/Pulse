import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/categories.dart';

class LifeEnergyMap extends StatelessWidget {
  final Map<String, double> breakdown;

  const LifeEnergyMap({super.key, required this.breakdown});

  @override
  Widget build(BuildContext context) {
    if (breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = breakdown.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    // Sort by value desc
    final entries = breakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.violet.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.psychology_outlined,
                color: AppTheme.violet,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Life Energy Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Where your money flows',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        ...entries.map((entry) {
          final key = entry.key;
          final value = entry.value;
          final percent = value / total;
          final area = LifeArea.values.firstWhere(
            (a) => a.name == key,
            orElse: () => LifeArea.comfort,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildRow(area, percent, value),
          );
        }),
      ],
    );
  }

  Widget _buildRow(LifeArea area, double percent, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              area.emoji,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                area.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: area.color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(
            children: [
              Container(
                height: 6,
                color: Colors.white.withOpacity(0.06),
              ),
              AnimatedContainer(
                duration: AppTheme.slowDuration,
                curve: AppTheme.snappy,
                height: 6,
                width: (MediaQueryData.fromView(
                              WidgetsBinding.instance.platformDispatcher.views.first)
                          .size
                          .width -
                      80) *
                      percent,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      area.color,
                      area.color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: area.color.withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}