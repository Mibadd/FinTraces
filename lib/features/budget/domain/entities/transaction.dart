enum TransactionCategory {
  food('Makanan'),
  transportation('Transportasi'),
  entertainment('Hiburan'),
  utilities('Tagihan'),
  others('Lainnya');

  final String label;
  const TransactionCategory(this.label);
}

class Transaction {
  final String id;
  final int amount; // Rupiah utuh
  final TransactionCategory category;
  final DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
}
