import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/budget/data/models/transaction_model.dart';
import '../../features/budget/data/models/budget_session_model.dart';

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden in main.dart');
});

class IsarDatabase {
  static Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        TransactionModelSchema,
        BudgetSessionModelSchema,
      ],
      directory: dir.path,
    );
  }
}
