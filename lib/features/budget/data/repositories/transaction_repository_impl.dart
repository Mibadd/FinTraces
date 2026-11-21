import 'package:isar/isar.dart';

import '../../domain/entities/budget_session.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/budget_session_model.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Isar isar;

  TransactionRepositoryImpl(this.isar);

  @override
  Future<List<Transaction>> getTransactions(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final models = await isar.transactionModels
        .filter()
        .dateBetween(startOfDay, endOfDay)
        .sortByDateDesc()
        .findAll();

    return models.map((e) => _mapToEntity(e)).toList();
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final model = TransactionModel()
      ..uuid = transaction.id
      ..amount = transaction.amount
      ..category = _mapCategoryToModel(transaction.category)
      ..date = transaction.date;

    await isar.writeTxn(() async {
      await isar.transactionModels.put(model);
    });
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await isar.writeTxn(() async {
      await isar.transactionModels.deleteByUuid(id);
    });
  }

  @override
  Future<BudgetSession?> getActiveBudgetSession(DateTime monthYear) async {
    final startOfMonth = DateTime(monthYear.year, monthYear.month, 1);
    final endOfMonth = DateTime(monthYear.year, monthYear.month + 1, 0, 23, 59, 59);

    final model = await isar.budgetSessionModels
        .filter()
        .monthYearBetween(startOfMonth, endOfMonth)
        .findFirst();

    if (model == null) return null;

    return _mapSessionToEntity(model);
  }

  @override
  Future<BudgetSession?> getLatestBudgetSession() async {
    final model = await isar.budgetSessionModels
        .where()
        .sortByMonthYearDesc()
        .findFirst();

    if (model == null) return null;

    return _mapSessionToEntity(model);
  }

  @override
  Future<void> saveBudgetSession(BudgetSession session) async {
    final model = BudgetSessionModel()
      ..uuid = session.id
      ..totalSalary = session.totalSalary
      ..savingsGoal = session.savingsGoal
      ..totalSpent = session.totalSpent
      ..monthYear = session.monthYear;

    await isar.writeTxn(() async {
      await isar.budgetSessionModels.put(model);
    });
  }

  @override
  Future<void> deleteAllData() async {
    await isar.writeTxn(() async {
      await isar.transactionModels.clear();
      await isar.budgetSessionModels.clear();
    });
  }

  BudgetSession _mapSessionToEntity(BudgetSessionModel model) {
    return BudgetSession(
      id: model.uuid,
      totalSalary: model.totalSalary,
      savingsGoal: model.savingsGoal,
      totalSpent: model.totalSpent,
      monthYear: model.monthYear,
    );
  }

  Transaction _mapToEntity(TransactionModel model) {
    return Transaction(
      id: model.uuid,
      amount: model.amount,
      category: _mapModelToCategory(model.category),
      date: model.date,
    );
  }

  TransactionCategoryModel _mapCategoryToModel(TransactionCategory category) {
    return TransactionCategoryModel.values.firstWhere(
      (e) => e.name == category.name,
      orElse: () => TransactionCategoryModel.others,
    );
  }

  TransactionCategory _mapModelToCategory(TransactionCategoryModel modelCategory) {
    return TransactionCategory.values.firstWhere(
      (e) => e.name == modelCategory.name,
      orElse: () => TransactionCategory.others,
    );
  }
}
