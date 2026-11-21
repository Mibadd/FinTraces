import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/budget_provider.dart';
import '../../domain/entities/budget_session.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/validators/budget_input_validator.dart';
import '../../../../core/widgets/numpad.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetState = ref.watch(budgetControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('FinTrace', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (budgetState.value?.session != null)
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: 'Atur anggaran',
              onPressed: () => _showBudgetSettings(
                context,
                ref,
                budgetState.value!.session!,
              ),
            ),
        ],
      ),
      body: budgetState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
        data: (state) {
          if (state.session == null) {
            return const _SetupBudgetForm();
          }
          return _buildDashboard(context, ref, state);
        },
      ),
      floatingActionButton: budgetState.value?.session != null 
        ? FloatingActionButton.extended(
            onPressed: () => _showTransactionBottomSheet(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Tambah'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          )
        : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  Widget _buildDashboard(BuildContext context, WidgetRef ref, BudgetState state) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Column(
      children: [
        const SizedBox(height: 20),
        // Daily Limit Card
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade400, Colors.teal.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Sisa Jatah Hari Ini',
                style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(state.session!.remainingDailyLimit),
                style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sisa Bulanan',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                  ),
                  Text(
                    currencyFormat.format(state.session!.remainingMonthlyBudget),
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Transactions List
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Text(
                    'Hari Ini',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                Expanded(
                  child: state.todaysTransactions.isEmpty
                      ? const Center(
                          child: Text('Belum ada pengeluaran hari ini.', style: TextStyle(color: Colors.grey)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: state.todaysTransactions.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.black12),
                          itemBuilder: (context, index) {
                            final tx = state.todaysTransactions[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () => _showTransactionActions(context, ref, tx),
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.withOpacity(0.1),
                                child: Icon(_getCategoryIcon(tx.category), color: Colors.teal),
                              ),
                              title: Text(tx.category.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text(DateFormat('HH:mm').format(tx.date)),
                              trailing: Text(
                                '-${currencyFormat.format(tx.amount)}',
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.food: return Icons.fastfood;
      case TransactionCategory.transportation: return Icons.directions_car;
      case TransactionCategory.entertainment: return Icons.movie;
      case TransactionCategory.utilities: return Icons.lightbulb;
      default: return Icons.money;
    }
  }

  /// Pengaturan untuk "uang awal" — gaji & target tabungan yang diisi saat
  /// setup. Sebelumnya nilai ini terkunci setelah tersimpan.
  void _showBudgetSettings(BuildContext context, WidgetRef ref, BudgetSession session) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Ubah Gaji & Target Tabungan'),
              subtitle: const Text('Pengeluaran yang sudah dicatat tetap tersimpan'),
              onTap: () {
                Navigator.pop(ctx);
                _showEditBudgetSheet(context, session);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Colors.redAccent),
              title: const Text('Reset Anggaran', style: TextStyle(color: Colors.redAccent)),
              subtitle: const Text('Hapus semua data dan mulai dari awal'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmReset(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBudgetSheet(BuildContext context, BudgetSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _EditBudgetSheet(session: session),
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset anggaran?'),
        content: const Text(
          'Seluruh data gaji, target tabungan, dan riwayat transaksi akan '
          'dihapus permanen. Anda akan kembali ke layar pengaturan awal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(budgetControllerProvider.notifier).resetAllData();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  /// Pilihan aksi untuk satu transaksi: edit atau hapus.
  void _showTransactionActions(BuildContext context, WidgetRef ref, Transaction tx) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Transaksi'),
              onTap: () {
                Navigator.pop(ctx);
                _showTransactionBottomSheet(context, ref, existing: tx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Hapus Transaksi', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref, tx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Transaction tx) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text(
          'Pengeluaran ${tx.category.label} sebesar ${currencyFormat.format(tx.amount)} '
          'akan dihapus dan dikembalikan ke sisa jatah Anda.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(budgetControllerProvider.notifier).deleteTransaction(tx);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  /// Bottom sheet input transaksi. Bila [existing] diisi, sheet berjalan
  /// dalam mode edit: nominal & kategori terisi awal, dan Done menimpa data lama.
  void _showTransactionBottomSheet(BuildContext context, WidgetRef ref, {Transaction? existing}) {
    final isEditing = existing != null;
    String currentAmount = existing?.amount.toString() ?? '';
    TransactionCategory selectedCategory = existing?.category ?? TransactionCategory.food;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(height: 16),
                  Text(
                    isEditing ? 'Edit Pengeluaran' : 'Pengeluaran Baru',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${NumberFormat('#,###', 'id_ID').format(currentAmount.isEmpty ? 0 : int.parse(currentAmount))}',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Category Selector (Simple row)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: TransactionCategory.values.map((cat) {
                        final isSelected = selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat.label),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) setState(() => selectedCategory = cat);
                            },
                            selectedColor: Colors.teal.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.teal.shade700 : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomNumpad(
                    onNumberTap: (num) {
                      if (currentAmount.length < 9) {
                        setState(() => currentAmount += num);
                      }
                    },
                    onBackspace: () {
                      if (currentAmount.isNotEmpty) {
                        setState(() => currentAmount = currentAmount.substring(0, currentAmount.length - 1));
                      }
                    },
                    onDone: () {
                      if (currentAmount.isEmpty) return;
                      final amount = int.parse(currentAmount);
                      if (amount <= 0) return;

                      final controller = ref.read(budgetControllerProvider.notifier);
                      if (existing != null) {
                        controller.updateTransaction(existing, amount, selectedCategory);
                      } else {
                        controller.addTransaction(amount, selectedCategory);
                      }
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            );
          }
        );
      },
    );
  }
}

/// Form revisi gaji & target tabungan. Memakai aturan validasi yang sama
/// dengan form setup awal, termasuk larangan target melebihi gaji.
class _EditBudgetSheet extends ConsumerStatefulWidget {
  const _EditBudgetSheet({required this.session});

  final BudgetSession session;

  @override
  ConsumerState<_EditBudgetSheet> createState() => _EditBudgetSheetState();
}

class _EditBudgetSheetState extends ConsumerState<_EditBudgetSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _salaryController;
  late final TextEditingController _savingsController;

  @override
  void initState() {
    super.initState();
    _salaryController =
        TextEditingController(text: widget.session.totalSalary.toString());
    _savingsController =
        TextEditingController(text: widget.session.savingsGoal.toString());
  }

  @override
  void dispose() {
    _salaryController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final salary = BudgetInputValidator.parseAmount(_salaryController.text)!;
    final savings = BudgetInputValidator.parseAmount(_savingsController.text)!;

    ref.read(budgetControllerProvider.notifier).updateBudget(salary, savings);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ubah Gaji & Target Tabungan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Sudah terpakai: ${currencyFormat.format(widget.session.totalSpent)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gaji Bulanan (Rp)',
                prefixText: 'Rp ',
              ),
              validator: BudgetInputValidator.validateSalary,
              onChanged: (_) => _formKey.currentState?.validate(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _savingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Tabungan (Rp)',
                prefixText: 'Rp ',
              ),
              validator: (value) => BudgetInputValidator.validateSavingsGoal(
                value,
                salaryRaw: _salaryController.text,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submit,
              child: const Text('Simpan', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Form setup awal. Stateful agar controller punya siklus hidup yang benar
/// (dibuang saat widget dilepas) dan pesan error bisa muncul saat mengetik.
class _SetupBudgetForm extends ConsumerStatefulWidget {
  const _SetupBudgetForm();

  @override
  ConsumerState<_SetupBudgetForm> createState() => _SetupBudgetFormState();
}

class _SetupBudgetFormState extends ConsumerState<_SetupBudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _salaryController = TextEditingController();
  final _savingsController = TextEditingController();

  @override
  void dispose() {
    _salaryController.dispose();
    _savingsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // Aman: form sudah lolos validasi, jadi kedua nilai pasti terbaca.
    final salary = BudgetInputValidator.parseAmount(_salaryController.text)!;
    final savings = BudgetInputValidator.parseAmount(_savingsController.text)!;

    ref.read(budgetControllerProvider.notifier).createInitialBudget(salary, savings);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_balance_wallet, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              'Selamat Datang di FinTrace',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mari atur anggaran bulanan Anda',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Gaji Bulanan (Rp)',
                prefixText: 'Rp ',
              ),
              validator: BudgetInputValidator.validateSalary,
              // Target tabungan dibanding gaji, jadi errornya ikut disegarkan.
              onChanged: (_) => _formKey.currentState?.validate(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _savingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Target Tabungan (Rp)',
                prefixText: 'Rp ',
              ),
              validator: (value) => BudgetInputValidator.validateSavingsGoal(
                value,
                salaryRaw: _salaryController.text,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submit,
              child: const Text('Mulai Mencatat', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
