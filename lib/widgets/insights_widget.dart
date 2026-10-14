import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';

class InsightsWidget extends StatelessWidget {
  final ExpenseProvider provider;

  const InsightsWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final insights = provider.getInsights();

    if (insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.lightbulb_outline,
                color: AppTheme.amber,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Smart Insights',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...insights.asMap().entries.map((entry) {
          final index = entry.key;
          final insight = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.gradStart.withOpacity(0.12),
                    AppTheme.gradEnd.withOpacity(0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.gradStart.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}