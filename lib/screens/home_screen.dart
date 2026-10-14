import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';
import '../widgets/glass_card.dart';
import '../models/mood.dart';
import 'add_expense_screen.dart';
import 'all_expenses_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.gradStart,
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ═══ TOP BAR ═══
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Formatters.greeting(),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  Formatters.dayMonth(DateTime.now()),
                                  style: const TextStyle(
                                    color: AppTheme.gradStart,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Welcome back 👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                        child: const Icon(
                          Icons.notifications_none_outlined,
                          color: Colors.white70,
                          size: 22,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ═══ TOTAL SPENT CARD ═══
                  _buildTotalCard(context, provider),

                  const SizedBox(height: 16),

                  // ═══ STATS ROW ═══
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniStat(
                          'Today',
                          '${provider.currencySymbol}${Formatters.number(provider.todayTotal)}',
                          Icons.today_outlined,
                          AppTheme.cyan,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildMiniStat(
                          'This Week',
                          '${provider.currencySymbol}${Formatters.number(provider.weekTotal)}',
                          Icons.date_range_outlined,
                          AppTheme.emerald,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ═══ RECENT EXPENSES ═══
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (provider.recentExpenses.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: AppTheme.fastDuration,
                                pageBuilder: (_, __, ___) =>
                                    const AllExpensesScreen(),
                                transitionsBuilder: (_, anim, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: anim,
                                        curve: AppTheme.snappy,
                                      ),
                                    ),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.gradStart.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'See all',
                                  style: TextStyle(
                                    color: AppTheme.gradStart,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: AppTheme.gradStart,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  if (provider.recentExpenses.isEmpty)
                    _buildEmptyState(context)
                  else
                    ...provider.recentExpenses
                        .take(5)
                        .map((e) => _buildExpenseItem(context, e, provider)),

                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppTheme.gradStart.withOpacity(0.5),
              blurRadius: 30,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _openAddExpense(context),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  void _openAddExpense(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: AppTheme.fastDuration,
        pageBuilder: (_, __, ___) => const AddExpenseScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: anim, curve: AppTheme.snappy),
            ),
            child: child,
          );
        },
      ),
    );
  }

  Widget _buildTotalCard(BuildContext context, ExpenseProvider provider) {
    return GradientCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'This Month',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '${provider.currencySymbol}${Formatters.number(provider.monthTotal)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.monthExpenses.length} transactions this month',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.gradStart.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No expenses yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tap + to add your first expense',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    BuildContext context,
    dynamic expense,
    ExpenseProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(expense.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: AppTheme.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 26,
          ),
        ),
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Delete expense?',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'This cannot be undone.',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: AppTheme.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        onDismissed: (_) {
          context.read<ExpenseProvider>().deleteExpense(expense.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Expense deleted'),
              backgroundColor: AppTheme.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: expense.category.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    expense.category.emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          expense.category.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          moodEmoji(expense.mood),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      Formatters.relative(expense.date),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${provider.currencySymbol}${Formatters.number(expense.amount)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}