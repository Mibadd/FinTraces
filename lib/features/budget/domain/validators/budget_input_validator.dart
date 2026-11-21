/// Aturan validasi input budget, dipisah dari widget agar bisa diuji
/// tanpa merender UI dan dipakai ulang saat edit gaji/target tabungan.
class BudgetInputValidator {
  const BudgetInputValidator._();

  /// Batas atas yang masih masuk akal untuk gaji bulanan (Rp 999.999.999).
  /// Juga menjaga nilai tetap aman saat dikalkulasi sebagai int.
  static const int maxAmount = 999999999;

  /// Membaca nominal rupiah dari input mentah. Titik, koma, dan spasi
  /// diabaikan agar "1.500.000" tetap terbaca sebagai 1500000.
  /// Mengembalikan null bila kosong atau mengandung karakter lain
  /// (huruf, tanda minus, dsb).
  static int? parseAmount(String? raw) {
    final text = (raw ?? '').trim();
    if (text.isEmpty) return null;

    final cleaned = text.replaceAll(RegExp(r'[.,\s]'), '');
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) return null;

    return int.tryParse(cleaned);
  }

  static String? validateSalary(String? raw) {
    final value = parseAmount(raw);
    if (value == null) return 'Masukkan gaji bulanan dalam angka.';
    if (value <= 0) return 'Gaji harus lebih besar dari 0.';
    if (value > maxAmount) return 'Nominal terlalu besar.';
    return null;
  }

  /// [salaryRaw] adalah isi field gaji saat ini — target tabungan tidak boleh
  /// melebihi gaji, karena sisa jatah harian akan langsung menjadi nol.
  static String? validateSavingsGoal(String? raw, {String? salaryRaw}) {
    final value = parseAmount(raw);
    if (value == null) return 'Masukkan target tabungan dalam angka.';
    if (value > maxAmount) return 'Nominal terlalu besar.';

    final salary = parseAmount(salaryRaw);
    if (salary != null && value > salary) {
      return 'Target tabungan tidak boleh melebihi gaji.';
    }
    return null;
  }

  /// Validasi tingkat domain: dipakai controller sebagai pengaman terakhir
  /// bila nilai datang dari jalur selain form setup.
  static bool isValidBudget(int salary, int savings) {
    return salary > 0 &&
        salary <= maxAmount &&
        savings >= 0 &&
        savings <= salary;
  }
}
