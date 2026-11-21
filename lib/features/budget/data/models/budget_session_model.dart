import 'package:isar/isar.dart';

part 'budget_session_model.g.dart';

@collection
class BudgetSessionModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late int totalSalary;
  late int savingsGoal;
  late int totalSpent;

  @Index()
  late DateTime monthYear;
}
