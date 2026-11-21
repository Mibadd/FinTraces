import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../budget/presentation/providers/budget_provider.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(budgetControllerProvider);
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Rencana Tabungan')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (data) {
          if (data.session == null) {
            return const Center(child: Text('Silakan atur anggaran di Beranda terlebih dahulu.'));
          }
          final session = data.session!;
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.savings, size: 80, color: Colors.teal),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Target Tabungan Bulanan', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(session.savingsGoal),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Total Gaji Bulanan', style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormat.format(session.totalSalary),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  'Catatan: Target tabungan akan otomatis dipotong secara virtual '
                  'sebelum sistem menghitung jatah pengeluaran harian Anda, memastikan '
                  'Anda menyisihkan tabungan terlebih dahulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
