import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/hive_service.dart';
import 'providers/expense_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.bg,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const PulseApp());
}

class PulseApp extends StatelessWidget {
  const PulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider()..loadExpenses(),
        ),
      ],
      child: MaterialApp(
        title: 'Pulse',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppTheme.bg,
          colorScheme: const ColorScheme.dark(
            primary: AppTheme.gradStart,
            secondary: AppTheme.gradEnd,
            surface: AppTheme.surface,
          ),
          textTheme: GoogleFonts.interTextTheme(
            ThemeData.dark().textTheme,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}