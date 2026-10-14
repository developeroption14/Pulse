import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';
import '../services/hive_service.dart';
import '../utils/currencies.dart';
import 'currency_picker_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;
  bool _hapticEnabled = true;
  String _currencyCode = 'USD';

  @override
  void initState() {
    super.initState();
    _soundEnabled = HiveService.getSetting('sound_enabled', true);
    _hapticEnabled = HiveService.getSetting('haptic_enabled', true);
    _currencyCode = HiveService.getSetting('currency_code', 'USD');
  }

  Future<void> _toggleSound(bool value) async {
    setState(() => _soundEnabled = value);
    await HiveService.setSetting('sound_enabled', value);
  }

  Future<void> _toggleHaptic(bool value) async {
    setState(() => _hapticEnabled = value);
    await HiveService.setSetting('haptic_enabled', value);
  }

  Future<void> _pickCurrency() async {
    final result = await Navigator.of(context).push<bool>(
      PageRouteBuilder(
        transitionDuration: AppTheme.fastDuration,
        pageBuilder: (_, __, ___) => const CurrencyPickerScreen(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim, curve: AppTheme.snappy)),
          child: child,
        ),
      ),
    );
    if (result == true && mounted) {
      final newCode = HiveService.getSetting('currency_code', 'USD');
      // ⚡ Sync with provider — this notifies Home + Stats automatically
      await context.read<ExpenseProvider>().setCurrency(newCode);
      if (mounted) {
        setState(() {
          _currencyCode = newCode;
        });
      }
    }
  }

  Future<void> _clearData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Clear all data?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This will permanently delete all your expenses. This cannot be undone.',
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
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

    if (confirmed == true && mounted) {
      await context.read<ExpenseProvider>().deleteAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('All data cleared'),
            backgroundColor: AppTheme.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ═══ TOP BAR ═══
              Row(
                children: [
                  // Decorative icon (Settings is a tab — no back button)
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
                      Icons.tune,
                      color: AppTheme.gradStart,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // ═══ PREFERENCES SECTION ═══
              _buildSectionTitle('Preferences'),
              const SizedBox(height: 12),

              // Currency
              _buildActionTile(
                icon: Icons.attach_money,
                iconColor: AppTheme.emerald,
                title: 'Currency',
                subtitle:
                    '${_currencyCode} — ${getCurrencyByCode(_currencyCode).name}',
                onTap: _pickCurrency,
              ),

              const SizedBox(height: 10),

              // Sound Effects
              _buildToggleTile(
                icon: Icons.volume_up_outlined,
                iconColor: AppTheme.violet,
                title: 'Sound Effects',
                subtitle: 'Subtle feedback on tap',
                value: _soundEnabled,
                onChanged: _toggleSound,
              ),

              const SizedBox(height: 10),

              // Haptic Feedback
              _buildToggleTile(
                icon: Icons.vibration,
                iconColor: AppTheme.cyan,
                title: 'Haptic Feedback',
                subtitle: 'Vibration on interaction',
                value: _hapticEnabled,
                onChanged: _toggleHaptic,
              ),

              const SizedBox(height: 32),

              // ═══ ABOUT SECTION ═══
              _buildSectionTitle('About'),
              const SizedBox(height: 12),

              _buildInfoTile(
                icon: Icons.info_outline,
                iconColor: AppTheme.emerald,
                title: 'Pulse',
                subtitle: 'Version 1.0.0',
              ),

              const SizedBox(height: 10),

              _buildInfoTile(
                icon: Icons.code,
                iconColor: AppTheme.amber,
                title: 'Built with Flutter',
                subtitle: 'Dart 3.13+',
              ),

              const SizedBox(height: 32),

              // ═══ DATA SECTION ═══
              _buildSectionTitle('Data'),
              const SizedBox(height: 12),

              _buildActionTile(
                icon: Icons.delete_outline,
                iconColor: AppTheme.red,
                title: 'Clear All Data',
                subtitle: 'Delete all expenses permanently',
                onTap: _clearData,
              ),

              const SizedBox(height: 40),

              // ═══ FOOTER ═══
              Center(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppTheme.primaryGradient.createShader(bounds),
                      child: const Text(
                        'Pulse',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LIFE ENERGY TRACKER',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: Colors.white.withOpacity(0.4),
        fontSize: 11,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.gradStart,
            activeTrackColor: AppTheme.gradStart.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}