import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/budget/presentation/providers/budget_provider.dart';
import '../../features/budget/presentation/screens/dashboard_screen.dart';
import '../../features/savings/presentation/screens/savings_screen.dart';
import '../../features/calculator/presentation/screens/calculator_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SavingsScreen(),
    const CalculatorScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Aplikasi bisa dibiarkan terbuka melewati pergantian hari/bulan.
    // Muat ulang saat kembali aktif agar sesi bulan baru terbentuk.
    if (state == AppLifecycleState.resumed) {
      ref.read(budgetControllerProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Anggaran',
          ),
          NavigationDestination(
            icon: Icon(Icons.savings_outlined),
            selectedIcon: Icon(Icons.savings),
            label: 'Tabungan',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Kalkulator',
          ),
        ],
      ),
    );
  }
}
