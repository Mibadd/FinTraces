import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/entities/budget_session.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/validators/budget_input_validator.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return TransactionRepositoryImpl(isar);
});

final budgetControllerProvider = StateNotifierProvider<BudgetController, AsyncValue<BudgetState>>((ref) {
  final repo = ref.watch(transactionRepositoryProvider);
  return BudgetController(repo);
});

class BudgetState {
  final BudgetSession? session;
  final List<Transaction> todaysTransactions;

  BudgetState({this.session, this.todaysTransactions = const []});
}

class BudgetController extends StateNotifier<AsyncValue<BudgetState>> {
  final TransactionRepository _repo;

  BudgetController(this._repo) : super(const AsyncValue.loading()) {
    _loadData();
  }

  /// Dipanggil ulang saat aplikasi kembali aktif — memastikan sesi bulan
  /// berjalan dan jatah harian ikut menyesuaikan bila tanggal sudah berganti.
  Future<void> refresh() => _loadData();

  Future<void> _loadData() async {
    try {
      final now = DateTime.now();
      final session = await _repo.getActiveBudgetSession(now) ??
          await _startNewMonthSession(now);
      final transactions = await _repo.getTransactions(now);
      state = AsyncValue.data(BudgetState(session: session, todaysTransactions: transactions));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Belum ada sesi untuk bulan berjalan: buat otomatis dengan mewarisi gaji &
  /// target tabungan dari sesi terakhir, dan pengeluaran direset ke 0.
  /// Transaksi bulan sebelumnya tetap tersimpan sebagai riwayat.
  /// Mengembalikan null bila pengguna memang belum pernah setup budget.
  Future<BudgetSession?> _startNewMonthSession(DateTime now) async {
    final previous = await _repo.getLatestBudgetSession();
    if (previous == null) return null;

    final newSession = BudgetSession(
      id: const Uuid().v4(),
      totalSalary: previous.totalSalary,
      savingsGoal: previous.savingsGoal,
      totalSpent: 0,
      monthYear: _firstDayOfMonth(now),
    );
    await _repo.saveBudgetSession(newSession);
    return newSession;
  }

  DateTime _firstDayOfMonth(DateTime date) => DateTime(date.year, date.month, 1);

  Future<void> addTransaction(int amount, TransactionCategory category) async {
    final currentState = state.value;
    if (currentState == null || currentState.session == null) return;

    final transaction = Transaction(
      id: const Uuid().v4(),
      amount: amount,
      category: category,
      date: DateTime.now(),
    );

    await _repo.saveTransaction(transaction);
    await _applySpentDelta(currentState.session!, amount);

    // Reload data efficiently
    await _loadData();
  }

  /// Menimpa transaksi lama (id sama) dan menyesuaikan `totalSpent`
  /// sebesar selisih nominal lama vs baru.
  Future<void> updateTransaction(
    Transaction original,
    int newAmount,
    TransactionCategory newCategory,
  ) async {
    final session = state.value?.session;
    if (session == null) return;

    await _repo.saveTransaction(
      Transaction(
        id: original.id,
        amount: newAmount,
        category: newCategory,
        date: original.date,
      ),
    );
    await _applySpentDelta(session, newAmount - original.amount);
    await _loadData();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    final session = state.value?.session;
    if (session == null) return;

    await _repo.deleteTransaction(transaction.id);
    await _applySpentDelta(session, -transaction.amount);
    await _loadData();
  }

  /// Merevisi gaji & target tabungan pada sesi bulan berjalan.
  /// Pengeluaran yang sudah tercatat tetap dipertahankan.
  Future<void> updateBudget(int salary, int savings) async {
    final session = state.value?.session;
    if (session == null) return;
    if (!BudgetInputValidator.isValidBudget(salary, savings)) return;

    await _repo.saveBudgetSession(
      session.copyWith(totalSalary: salary, savingsGoal: savings),
    );
    await _loadData();
  }

  /// Menghapus seluruh sesi budget dan transaksi, lalu kembali ke layar setup.
  /// Menghapus semuanya (bukan hanya bulan berjalan) supaya rollover tidak
  /// langsung membuat ulang sesi dari data bulan sebelumnya.
  Future<void> resetAllData() async {
    await _repo.deleteAllData();
    await _loadData();
  }

  Future<void> _applySpentDelta(BudgetSession session, int delta) async {
    final newTotal = session.totalSpent + delta;
    await _repo.saveBudgetSession(
      session.copyWith(totalSpent: newTotal < 0 ? 0 : newTotal),
    );
  }

  /// Mengabaikan nilai yang tidak masuk akal (gaji <= 0, atau target tabungan
  /// melebihi gaji). Form setup sudah memvalidasi lebih dulu; ini pengaman
  /// terakhir agar sesi rusak tidak pernah tersimpan.
  Future<void> createInitialBudget(int salary, int savings) async {
    if (!BudgetInputValidator.isValidBudget(salary, savings)) return;

    final now = DateTime.now();
    final session = BudgetSession(
      id: const Uuid().v4(),
      totalSalary: salary,
      savingsGoal: savings,
      totalSpent: 0,
      monthYear: _firstDayOfMonth(now),
    );
    await _repo.saveBudgetSession(session);
    await _loadData();
  }
}
