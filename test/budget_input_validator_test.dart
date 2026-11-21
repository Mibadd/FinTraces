import 'package:flutter_test/flutter_test.dart';

import 'package:fintrace/features/budget/domain/validators/budget_input_validator.dart';

void main() {
  group('parseAmount', () {
    test('membaca angka polos', () {
      expect(BudgetInputValidator.parseAmount('1500000'), 1500000);
    });

    test('mengabaikan pemisah ribuan gaya Indonesia', () {
      expect(BudgetInputValidator.parseAmount('1.500.000'), 1500000);
      expect(BudgetInputValidator.parseAmount('1 500 000'), 1500000);
    });

    test('menolak input kosong, huruf, dan nilai negatif', () {
      expect(BudgetInputValidator.parseAmount(''), isNull);
      expect(BudgetInputValidator.parseAmount('   '), isNull);
      expect(BudgetInputValidator.parseAmount(null), isNull);
      expect(BudgetInputValidator.parseAmount('lima juta'), isNull);
      expect(BudgetInputValidator.parseAmount('100rb'), isNull);
      expect(BudgetInputValidator.parseAmount('-5000'), isNull);
    });
  });

  group('validateSalary', () {
    test('gaji wajar lolos', () {
      expect(BudgetInputValidator.validateSalary('5000000'), isNull);
    });

    test('kosong, nol, dan bukan angka ditolak', () {
      expect(BudgetInputValidator.validateSalary(''), isNotNull);
      expect(BudgetInputValidator.validateSalary('0'), isNotNull);
      expect(BudgetInputValidator.validateSalary('abc'), isNotNull);
    });

    test('nominal di atas batas ditolak', () {
      expect(BudgetInputValidator.validateSalary('1000000000'), isNotNull);
      expect(BudgetInputValidator.validateSalary('999999999'), isNull);
    });
  });

  group('validateSavingsGoal', () {
    test('target di bawah gaji lolos', () {
      expect(
        BudgetInputValidator.validateSavingsGoal('2000000',
            salaryRaw: '5000000'),
        isNull,
      );
    });

    test('target sama dengan gaji masih boleh', () {
      expect(
        BudgetInputValidator.validateSavingsGoal('5000000',
            salaryRaw: '5000000'),
        isNull,
      );
    });

    test('target melebihi gaji ditolak dengan pesan yang jelas', () {
      final error = BudgetInputValidator.validateSavingsGoal('6000000',
          salaryRaw: '5000000');
      expect(error, 'Target tabungan tidak boleh melebihi gaji.');
    });

    test('perbandingan tetap jalan meski gaji ditulis dengan titik', () {
      expect(
        BudgetInputValidator.validateSavingsGoal('6.000.000',
            salaryRaw: '5.000.000'),
        isNotNull,
      );
    });

    test('target nol boleh, target kosong tidak', () {
      expect(BudgetInputValidator.validateSavingsGoal('0', salaryRaw: '5000000'),
          isNull);
      expect(BudgetInputValidator.validateSavingsGoal('', salaryRaw: '5000000'),
          isNotNull);
    });

    test('gaji belum diisi: target tidak dibandingkan, hanya dicek formatnya',
        () {
      expect(BudgetInputValidator.validateSavingsGoal('2000000', salaryRaw: ''),
          isNull);
    });
  });

  group('isValidBudget', () {
    test('menerima kombinasi yang wajar', () {
      expect(BudgetInputValidator.isValidBudget(5000000, 1000000), isTrue);
      expect(BudgetInputValidator.isValidBudget(5000000, 0), isTrue);
    });

    test('menolak gaji nol/negatif dan tabungan melebihi gaji', () {
      expect(BudgetInputValidator.isValidBudget(0, 0), isFalse);
      expect(BudgetInputValidator.isValidBudget(-1000, 0), isFalse);
      expect(BudgetInputValidator.isValidBudget(5000000, 6000000), isFalse);
      expect(BudgetInputValidator.isValidBudget(5000000, -1), isFalse);
    });
  });
}
