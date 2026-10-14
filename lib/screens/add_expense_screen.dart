import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/mood.dart';
import '../utils/categories.dart';
import '../utils/formatters.dart';
import '../providers/expense_provider.dart';
import '../widgets/gradient_button.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedCategoryId = 'food';
  Mood _selectedMood = Mood.happy;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await context.read<ExpenseProvider>().addExpense(
            amount: amount,
            categoryId: _selectedCategoryId,
            moodId: _selectedMood.id,
            note: _noteController.text.trim(),
            date: _selectedDate,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense added: ${Formatters.currency(amount)}'),
            backgroundColor: AppTheme.gradStart,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      _showError('Failed to save: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppTheme.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.gradStart,
              onPrimary: Colors.white,
              surface: AppTheme.surface,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
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
                        Icons.close,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Add Expense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAmountInput(provider.currencySymbol),

                    const SizedBox(height: 32),

                    const Text(
                      'Category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildCategoryGrid(),

                    const SizedBox(height: 32),

                    const Text(
                      'How did you feel?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This helps track your emotional spending',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildMoodSelector(),

                    const SizedBox(height: 32),

                    const Text(
                      'Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildDatePicker(),

                    const SizedBox(height: 32),

                    const Text(
                      'Note (optional)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildNoteInput(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // SAVE BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: GradientButton(
            label: 'Save Expense',
            icon: Icons.check_rounded,
            onPressed: _save,
            isLoading: _isSaving,
            isFullWidth: true,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput(String symbol) {
    return Container(
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
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  symbol,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: AppTheme.gradStart,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: kCategories.length,
      itemBuilder: (context, i) {
        final cat = kCategories[i];
        final isSelected = cat.id == _selectedCategoryId;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategoryId = cat.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? cat.color.withOpacity(0.2)
                  : AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? cat.color
                    : Colors.white.withOpacity(0.05),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: cat.color.withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  cat.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 10,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      children: Mood.values.map((mood) {
        final isSelected = mood == _selectedMood;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => _selectedMood = mood),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? moodColor(mood).withOpacity(0.2)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? moodColor(mood)
                        : Colors.white.withOpacity(0.05),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: moodColor(mood).withOpacity(0.4),
                            blurRadius: 16,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      moodEmoji(mood),
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      moodLabel(mood),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white60,
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.cyan.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppTheme.cyan,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.isToday(_selectedDate)
                        ? 'Today'
                        : Formatters.isYesterday(_selectedDate)
                            ? 'Yesterday'
                            : Formatters.dayName(_selectedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Formatters.dayMonth(_selectedDate),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white38,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteInput() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'What was this for?',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        cursorColor: AppTheme.gradStart,
      ),
    );
  }
}