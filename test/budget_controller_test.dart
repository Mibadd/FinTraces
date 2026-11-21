import 'package:flutter_test/flutter_test.dart';

import 'package:fintrace/features/budget/domain/entities/budget_session.dart';
import 'package:fintrace/features/budget/domain/entities/transaction.dart';
import 'package:fintrace/features/budget/domain/repositories/transaction_repository.dart';
import 'package:fintrace/features/budget/presentation/providers/budget_provider.dart';

/// Repository in-memory agar logika controller bisa diuji tanpa Isar.
class FakeTransactionRepository implements TransactionRepository {
  final List<BudgetSession> sessions = [];
  final List<Transaction> transactions = [];

  @override
  Future<List<Transaction>> getTransactions(DateTime date) async {
    return transactions
        .where((t) =>
            t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day)
        .toList();
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    transactions.removeWhere((t) => t.id == transaction.id);
    transactions.add(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    transactions.removeWhere((t) => t.id == id);
  }

  @override
  Future<BudgetSession?> getActiveBudgetSession(DateTime monthYear) async {
    for (final session in sessions) {
      if (session.monthYear.year == monthYear.year &&
          session.monthYear.month == monthYear.month) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<BudgetSession?> getLatestBudgetSession() async {
    if (sessions.isEmpty) return null;
    final sorted = [...sessions]
      ..sort((a, b) => b.monthYear.compareTo(a.monthYear));
    return sorted.first;
  }

  @override
  Future<void> saveBudgetSession(BudgetSession session) async {
    sessions.removeWhere((s) => s.id == session.id);
    sessions.add(session);
  }

  @override
  Future<void> deleteAllData() async {
    sessions.clear();
    transactions.clear();
  }
}

/// Controller memuat data di konstruktor; tunggu sampai state siap.
Future<BudgetController> createLoadedController(
    FakeTransactionRepository repo) async {
  final controller = BudgetController(repo);
  while (controller.state.isLoading) {
    await Future<void>.delayed(Duration.zero);
  }
  return controller;
}

void main() {
  final now = DateTime.now();

  group('pergantian bulan', () {
    test('tanpa sesi sama sekali, pengguna diarahkan ke setup', () async {
      final repo = FakeTransactionRepository();
      final controller = await createLoadedController(repo);

      expect(controller.state.value!.session, isNull);
      expect(repo.sessions, isEmpty);
    });

    test('sesi bulan lalu memicu sesi baru dengan pengeluaran direset',
        () async {
      final repo = FakeTransactionRepository();
      final lastMonth = DateTime(now.year, now.month - 1, 1);
      repo.sessions.add(BudgetSession(
        id: 'sesi-bulan-lalu',
        totalSalary: 8000000,
        savingsGoal: 2000000,
        totalSpent: 4500000,
        monthYear: lastMonth,
      ));

      final controller = await createLoadedController(repo);
      final session = controller.state.value!.session!;

      expect(session.id, isNot('sesi-bulan-lalu'));
      expect(session.totalSalary, 8000000, reason: 'gaji diwarisi');
      expect(session.savingsGoal, 2000000, reason: 'target tabungan diwarisi');
      expect(session.totalSpent, 0, reason: 'pengeluaran direset');
      expect(session.monthYear, DateTime(now.year, now.month, 1));
      expect(repo.sessions.length, 2,
          reason: 'sesi bulan lalu tetap tersimpan sebagai riwayat');
    });

    test('sesi bulan berjalan dipakai apa adanya, tidak dibuat ulang', () async {
      final repo = FakeTransactionRepository();
      repo.sessions.add(BudgetSession(
        id: 'sesi-berjalan',
        totalSalary: 5000000,
        savingsGoal: 1000000,
        totalSpent: 750000,
        monthYear: DateTime(now.year, now.month, 1),
      ));

      final controller = await createLoadedController(repo);

      expect(controller.state.value!.session!.id, 'sesi-berjalan');
      expect(controller.state.value!.session!.totalSpent, 750000);
      expect(repo.sessions.length, 1);
    });
  });

  group('createInitialBudget', () {
    test('menyimpan sesi untuk input yang wajar', () async {
      final repo = FakeTransactionRepository();
      final controller = await createLoadedController(repo);

      await controller.createInitialBudget(5000000, 1000000);

      expect(controller.state.value!.session, isNotNull);
      expect(repo.sessions.single.totalSalary, 5000000);
    });

    test('menolak target tabungan yang melebihi gaji', () async {
      final repo = FakeTransactionRepository();
      final controller = await createLoadedController(repo);

      await controller.createInitialBudget(5000000, 6000000);

      expect(repo.sessions, isEmpty);
      expect(controller.state.value!.session, isNull);
    });

    test('menolak gaji nol', () async {
      final repo = FakeTransactionRepository();
      final controller = await createLoadedController(repo);

      await controller.createInitialBudget(0, 0);

      expect(repo.sessions, isEmpty);
    });
  });

  group('revisi & hapus uang awal', () {
    Future<BudgetController> withActiveSession(
        FakeTransactionRepository repo) async {
      repo.sessions.add(BudgetSession(
        id: 'sesi-berjalan',
        totalSalary: 5000000,
        savingsGoal: 1000000,
        totalSpent: 0,
        monthYear: DateTime(now.year, now.month, 1),
      ));
      return createLoadedController(repo);
    }

    test('revisi gaji & target tabungan mempertahankan pengeluaran', () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);
      await controller.addTransaction(200000, TransactionCategory.food);

      await controller.updateBudget(7000000, 2000000);

      final session = controller.state.value!.session!;
      expect(session.totalSalary, 7000000);
      expect(session.savingsGoal, 2000000);
      expect(session.totalSpent, 200000, reason: 'pengeluaran tidak direset');
      expect(session.id, 'sesi-berjalan', reason: 'sesi yang sama, bukan baru');
      expect(controller.state.value!.todaysTransactions.length, 1);
    });

    test('revisi menolak target tabungan melebihi gaji', () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);

      await controller.updateBudget(5000000, 6000000);

      final session = controller.state.value!.session!;
      expect(session.totalSalary, 5000000, reason: 'nilai lama dipertahankan');
      expect(session.savingsGoal, 1000000);
    });

    test('reset menghapus sesi & transaksi, kembali ke setup', () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);
      await controller.addTransaction(50000, TransactionCategory.food);

      await controller.resetAllData();

      expect(repo.sessions, isEmpty);
      expect(repo.transactions, isEmpty);
      expect(controller.state.value!.session, isNull,
          reason: 'rollover tidak boleh membuat ulang sesi setelah reset');
    });
  });

  group('edit & hapus transaksi', () {
    Future<BudgetController> withActiveSession(
        FakeTransactionRepository repo) async {
      repo.sessions.add(BudgetSession(
        id: 'sesi-berjalan',
        totalSalary: 5000000,
        savingsGoal: 1000000,
        totalSpent: 0,
        monthYear: DateTime(now.year, now.month, 1),
      ));
      return createLoadedController(repo);
    }

    test('hapus mengembalikan nominal ke sisa jatah', () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);

      await controller.addTransaction(50000, TransactionCategory.food);
      expect(controller.state.value!.session!.totalSpent, 50000);

      final tx = controller.state.value!.todaysTransactions.single;
      await controller.deleteTransaction(tx);

      expect(controller.state.value!.session!.totalSpent, 0);
      expect(controller.state.value!.todaysTransactions, isEmpty);
    });

    test('edit menggeser totalSpent sebesar selisih, bukan menambah ulang',
        () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);

      await controller.addTransaction(50000, TransactionCategory.food);
      final tx = controller.state.value!.todaysTransactions.single;

      await controller.updateTransaction(
          tx, 30000, TransactionCategory.transportation);

      final updated = controller.state.value!.todaysTransactions.single;
      expect(controller.state.value!.session!.totalSpent, 30000);
      expect(updated.id, tx.id, reason: 'menimpa, tidak menduplikasi');
      expect(updated.amount, 30000);
      expect(updated.category, TransactionCategory.transportation);
      expect(updated.date, tx.date, reason: 'waktu asli dipertahankan');
      expect(repo.transactions.length, 1);
    });

    test('totalSpent tidak pernah negatif', () async {
      final repo = FakeTransactionRepository();
      final controller = await withActiveSession(repo);

      await controller.addTransaction(20000, TransactionCategory.others);
      final tx = controller.state.value!.todaysTransactions.single;
      // Simulasi data tidak sinkron: nominal transaksi melebihi totalSpent.
      await controller.updateTransaction(
          Transaction(
            id: tx.id,
            amount: 99999999,
            category: tx.category,
            date: tx.date,
          ),
          20000,
          tx.category);

      expect(controller.state.value!.session!.totalSpent, 0);
    });
  });
}
