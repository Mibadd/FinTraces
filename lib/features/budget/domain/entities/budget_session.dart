class BudgetSession {
  final String id;
  final int totalSalary;
  final int savingsGoal;
  final int totalSpent;
  final DateTime monthYear;

  BudgetSession({
    required this.id,
    required this.totalSalary,
    required this.savingsGoal,
    required this.totalSpent,
    required this.monthYear,
  });

  BudgetSession copyWith({
    int? totalSalary,
    int? savingsGoal,
    int? totalSpent,
  }) {
    return BudgetSession(
      id: id,
      totalSalary: totalSalary ?? this.totalSalary,
      savingsGoal: savingsGoal ?? this.savingsGoal,
      totalSpent: totalSpent ?? this.totalSpent,
      monthYear: monthYear,
    );
  }

  /// (Total Salary - Savings Goal - Total Spent) / Remaining Days in Month
  int get remainingDailyLimit {
    final now = DateTime.now();
    final daysInMonth = DateTime(monthYear.year, monthYear.month + 1, 0).day;
    final remainingDays = daysInMonth - now.day + 1;

    final remainingBudget = totalSalary - savingsGoal - totalSpent;
    if (remainingBudget <= 0) return 0;
    
    return remainingBudget ~/ remainingDays; 
  }

  int get remainingMonthlyBudget {
    final remaining = totalSalary - savingsGoal - totalSpent;
    return remaining > 0 ? remaining : 0;
  }
}
