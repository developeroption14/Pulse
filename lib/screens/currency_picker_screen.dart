import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/currencies.dart';
import '../services/hive_service.dart';

class CurrencyPickerScreen extends StatefulWidget {
  const CurrencyPickerScreen({super.key});

  @override
  State<CurrencyPickerScreen> createState() => _CurrencyPickerScreenState();
}

class _CurrencyPickerScreenState extends State<CurrencyPickerScreen> {
  final _searchController = TextEditingController();
  List<Currency> _filtered = kCurrencies;
  String _selectedCode = 'USD';

  @override
  void initState() {
    super.initState();
    _selectedCode = HiveService.getSetting('currency_code', 'USD');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    if (query.isEmpty) {
      setState(() => _filtered = kCurrencies);
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _filtered = kCurrencies.where((c) {
        return c.code.toLowerCase().contains(q) ||
            c.name.toLowerCase().contains(q) ||
            c.country.toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<void> _select(Currency c) async {
    await HiveService.setSetting('currency_code', c.code);
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        Icons.arrow_back_ios_new,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Currency',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.gradStart.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _selectedCode,
                      style: const TextStyle(
                        color: AppTheme.gradStart,
                        fontSize: 12,
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
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 20,
                    ),
                    hintText: 'Search currency or country...',
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
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '🔍',
                            style: TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No currency found',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final c = _filtered[i];
                        final isSelected = c.code == _selectedCode;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () => _select(c),
                            child: AnimatedContainer(
                              duration: AppTheme.fastDuration,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.gradStart.withOpacity(0.12)
                                    : AppTheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.gradStart.withOpacity(0.5)
                                      : Colors.white.withOpacity(0.05),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Symbol circle
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? AppTheme.primaryGradient
                                          : null,
                                      color: isSelected
                                          ? null
                                          : AppTheme.surfaceAlt,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        c.symbol,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              c.code,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (isSelected)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.gradStart,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Text(
                                                  'SELECTED',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c.name,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          c.country,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppTheme.gradStart,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}