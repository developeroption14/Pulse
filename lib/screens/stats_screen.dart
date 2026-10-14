import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';
import '../utils/categories.dart';
import '../utils/formatters.dart';
import '../widgets/insights_widget.dart';
import '../widgets/life_energy_map.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _period = 'month';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.gradStart),
              );
            }

            final total = _getTotalForPeriod(provider);
            final categoryData = provider.categoryBreakdown(period: _period);
            final moodData = provider.moodBreakdown(period: _period);
            final lifeData = provider.lifeAreaBreakdown(period: _period);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ═══ TOP BAR ═══
                  Row(
                    children: [
                      const Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: const Icon(
                          Icons.analytics_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ═══ TIME FILTER ═══
                  _buildTimeFilter(),

                  const SizedBox(height: 24),

                  // ═══ TOTAL CARD ═══
                  _buildTotalCard(total, provider),

                  const SizedBox(height: 24),

                  // ═══ PIE CHART ═══
                  if (categoryData.isNotEmpty) ...[
                    _buildSectionTitle('By Category'),
                    const SizedBox(height: 14),
                    _buildPieChart(categoryData),
                    const SizedBox(height: 24),
                  ],

                  // ═══ BAR CHART ═══
                  _buildSectionTitle('Last 7 Days'),
                  const SizedBox(height: 14),
                  _buildBarChart(provider),
                  const SizedBox(height: 24),

                  // ═══ MOOD BREAKDOWN ═══
                  if (moodData.isNotEmpty) ...[
                    _buildSectionTitle('By Mood'),
                    const SizedBox(height: 14),
                    _buildMoodBreakdown(moodData),
                    const SizedBox(height: 24),
                  ],

                  // ═══ LIFE ENERGY MAP ═══
                  if (lifeData.isNotEmpty) ...[
                    LifeEnergyMap(breakdown: lifeData),
                    const SizedBox(height: 24),
                  ],

                  // ═══ INSIGHTS ═══
                  InsightsWidget(provider: provider),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════

  double _getTotalForPeriod(ExpenseProvider p) {
    switch (_period) {
      case 'today':
        return p.todayTotal;
      case 'week':
        return p.weekTotal;
      case 'year':
        return p.yearTotal;
      case 'month':
      default:
        return p.monthTotal;
    }
  }

  // ═══════════════════════════════════════════════════════════
  // WIDGETS
  // ═══════════════════════════════════════════════════════════

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTimeFilter() {
    final periods = ['today', 'week', 'month', 'year'];
    final labels = ['Today', 'Week', 'Month', 'Year'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: List.generate(periods.length, (i) {
          final isActive = _period == periods[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _period = periods[i]),
              child: AnimatedContainer(
                duration: AppTheme.fastDuration,
                curve: AppTheme.snappy,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isActive ? AppTheme.primaryGradient : null,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppTheme.gradStart.withOpacity(0.4),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTotalCard(double total, ExpenseProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.gradStart.withOpacity(0.15),
            AppTheme.gradEnd.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.gradStart.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Spent',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) =>
                AppTheme.primaryGradient.createShader(bounds),
            child: Text(
              '${provider.currencySymbol}${Formatters.number(total)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart(Map<String, double> data) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 40,
                startDegreeOffset: -90,
                sections: entries.map((e) {
                  final cat = getCategoryById(e.key);
                  return PieChartSectionData(
                    value: e.value,
                    color: cat.color,
                    radius: 22,
                    showTitle: false,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entries.take(5).map((e) {
                final cat = getCategoryById(e.key);
                final percent = (e.value / total * 100).toStringAsFixed(0);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: cat.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cat.color.withOpacity(0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cat.name,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(ExpenseProvider provider) {
    final daily = provider.dailyTotals(days: 7);
    final maxValue = daily.values.isEmpty
        ? 1.0
        : daily.values.reduce((a, b) => a > b ? a : b);
    final maxY = maxValue == 0 ? 100.0 : maxValue * 1.3;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: SizedBox(
        height: 180,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 24,
                  getTitlesWidget: (value, meta) {
                    final entries = daily.entries.toList();
                    if (value.toInt() >= entries.length) {
                      return const SizedBox.shrink();
                    }
                    final date = entries[value.toInt()].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        Formatters.shortDayName(date).substring(0, 1),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: List.generate(daily.length, (i) {
              final value = daily.values.elementAt(i);
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: value == 0 ? 0.5 : value,
                    width: 22,
                    borderRadius: BorderRadius.circular(6),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [AppTheme.gradStart, AppTheme.gradEnd],
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY,
                      color: Colors.white.withOpacity(0.04),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodBreakdown(Map<String, double> data) {
    final total = data.values.fold(0.0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();

    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: entries.map((e) {
          final moodId = e.key;
          final percent = e.value / total;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Text(
                  _getMoodEmoji(moodId),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        moodId[0].toUpperCase() + moodId.substring(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: Colors.white.withOpacity(0.06),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getMoodColor(moodId),
                          ),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(percent * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getMoodEmoji(String moodId) {
    switch (moodId) {
      case 'happy':
        return '😊';
      case 'neutral':
        return '😐';
      case 'stressed':
        return '😔';
      case 'celebrating':
        return '🎉';
      case 'tired':
        return '😴';
      default:
        return '😐';
    }
  }

  Color _getMoodColor(String moodId) {
    switch (moodId) {
      case 'happy':
        return AppTheme.moodHappy;
      case 'neutral':
        return AppTheme.moodNeutral;
      case 'stressed':
        return AppTheme.moodStressed;
      case 'celebrating':
        return AppTheme.moodCelebrating;
      case 'tired':
        return AppTheme.moodTired;
      default:
        return AppTheme.moodNeutral;
    }
  }
}