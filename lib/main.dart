import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/isar_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Isar Local Database
  final isar = await IsarDatabase.init();

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const FinTraceApp(),
    ),
  );
}

class FinTraceApp extends StatelessWidget {
  const FinTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTrace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const MainScreen(),
    );
  }
}
