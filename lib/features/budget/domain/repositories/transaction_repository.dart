import '../entities/transaction.dart';
import '../entities/budget_session.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(DateTime date);

  /// Menyimpan transaksi baru, atau menimpa yang lama bila `id` sudah ada.
  Future<void> saveTransaction(Transaction transaction);

  Future<void> deleteTransaction(String id);

  Future<BudgetSession?> getActiveBudgetSession(DateTime monthYear);

  /// Sesi terakhir yang tersimpan dari bulan mana pun. Dipakai untuk mewarisi
  /// gaji & target tabungan saat memasuki bulan baru.
  Future<BudgetSession?> getLatestBudgetSession();

  Future<void> saveBudgetSession(BudgetSession session);

  /// Menghapus seluruh sesi budget beserta transaksinya (reset total).
  Future<void> deleteAllData();
}
