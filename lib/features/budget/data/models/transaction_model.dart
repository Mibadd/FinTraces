import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late int amount;
  
  @Index()
  late DateTime date;

  @enumerated
  late TransactionCategoryModel category;
}

enum TransactionCategoryModel {
  food,
  transportation,
  entertainment,
  utilities,
  others
}
