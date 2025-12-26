import 'package:ezbudget/models/deduction.dart';

/// This is the Budget class.
/// It contains the label, remaining amount, and total amount of the budget.
/// It also has methods to reset the budget, spend money, and get the percentage remaining.
enum ResetInterval {
  yearly,
  monthly,
  weekly,
  daily,
}

class Budget {
  String label;
  double remaining;
  double total;
  List<Deduction> deductions;

  /// Icon name identifier (e.g., 'shopping_cart'). Defaults to 'category'.
  String icon;

  DateTime resetDate;
  ResetInterval resetInterval;

  Budget(this.label, this.total,
      [double? remaining, List<Deduction>? deductions, String? icon])
      : remaining = remaining ?? total,
        deductions = deductions ?? [],
        resetDate = DateTime(DateTime.now().year, DateTime.now().month + 1),
        resetInterval = ResetInterval.monthly,
        icon = icon ?? 'category';

  void resetBudget() {
    remaining = total;
    deductions = [];
  }

  void spendMoney(double amount, [String? description, DateTime? date]) {
    remaining -= amount;
    deductions.add(Deduction(
        description ?? "Unnamed Deduction", amount, date ?? DateTime.now()));
  }

  double getPercentageRemaining() {
    double percentage = remaining / total;
    if (percentage <= 0) {
      return 0;
    } else {
      return percentage;
    }
  }

  bool isOverBudget() {
    if (remaining < 0) {
      return true;
    } else {
      return false;
    }
  }

  Duration getTimeRemaining() {
    return resetDate.difference(DateTime.now());
  }

  void setResetDate() {
    switch (resetInterval) {
      case ResetInterval.yearly:
        resetDate = DateTime(resetDate.year + 1, resetDate.month);
        break;
      case ResetInterval.monthly:
        resetDate = DateTime(resetDate.year, resetDate.month + 1);
        break;
      case ResetInterval.weekly:
        resetDate =
            DateTime(resetDate.year, resetDate.month, resetDate.day + 7);
        break;
      case ResetInterval.daily:
        resetDate =
            DateTime(resetDate.year, resetDate.month, resetDate.day + 1);
        break;
    }
  }

  Budget.fromJson(Map<String, dynamic> json)
      : label = json['label'] as String,
        remaining = json['remaining'] as double,
        total = json['total'] as double,
        deductions = (json['deductions'] as List)
            .map((d) => Deduction.fromJson(d))
            .toList(),
        resetDate = DateTime.parse(json['resetDate'] as String),
        resetInterval = ResetInterval.values[json['resetInterval'] as int],
        icon = (json['icon'] as String?) ?? 'category';

  Map<String, dynamic> toJson() => {
        'label': label,
        'remaining': remaining,
        'total': total,
        'deductions': deductions.map((d) => d.toJson()).toList(),
        'resetDate': resetDate.toIso8601String(),
        'resetInterval': resetInterval.index,
        'icon': icon,
      };
}
