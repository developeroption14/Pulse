import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/expense.dart';
import '../models/mood.dart';
import '../providers/expense_provider.dart';
import '../utils/formatters.dart';

class AllExpensesScreen extends StatefulWidget {
  const AllExpensesScreen({super.key});

  @override
  State<AllExpensesScreen> createState() => _AllExpensesScreenState();
}

class _AllExpensesScreenState extends State<AllExpensesScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Consumer<ExpenseProvider>(
          builder: (context, provider, _) {
            final all = provider.allExpenses;
            final filtered = _query.isEmpty
                ? all
                : all.where((e) {
                    final q = _query.toLowerCase();
                    return e.category.name.toLowerCase().contains(q) ||
                        e.note.toLowerCase().contains(q) ||
                        e.amount.toString().contains(q) ||
                        moodLabel(e.mood).toLowerCase().contains(q);
                  }).toList();

            return Column(
              children: [
                // TOP BAR
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
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
                            Icons.arrow_back_ios_new,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'All Expenses',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.gradStart.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${all.length}',
                          style: const TextStyle(
                            color: AppTheme.gradStart,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                          size: 20,
                        ),
                        hintText: 'Search expenses...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14,
                        ),
                      ),
                      cursorColor: AppTheme.gradStart,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // LIST
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      AppTheme.gradStart.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '🔍',
                                    style: TextStyle(fontSize: 36),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _query.isEmpty
                                    ? 'No expenses yet'
                                    : 'No results found',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filtered.length,
                          itemBuilder: (context, i) {
                            final e = filtered[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Dismissible(
                                key: Key(e.id),
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
                                        style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, false),
                                          child: const Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white70),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(ctx, true),
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
                                  provider.deleteExpense(e.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          const Text('Expense deleted'),
                                      backgroundColor: AppTheme.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                                child: _buildItem(e, provider),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildItem(Expense e, ExpenseProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Category emoji
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: e.category.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                e.category.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      e.category.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      moodEmoji(e.mood),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  Formatters.relative(e.date),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                if (e.hasNote) ...[
                  const SizedBox(height: 3),
                  Text(
                    e.note,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

                    // Amount
          Text(
            '${provider.currencySymbol}${Formatters.number(e.amount)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}