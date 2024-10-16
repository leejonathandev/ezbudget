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

  DateTime resetDate;
  ResetInterval resetInterval;

  Budget(this.label, this.total, [double? remaining])
      : remaining = remaining ?? total,
        resetDate = DateTime(DateTime.now().year, DateTime.now().month + 1),
        resetInterval = ResetInterval.monthly;

  void resetBudget() {
    remaining = total;
  }

  void spendMoney(double cost) {
    remaining -= cost;
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
        resetDate = DateTime(resetDate.year, resetDate.month, resetDate.day + 7);
        break;
      case ResetInterval.daily:
        resetDate = DateTime(resetDate.year, resetDate.month, resetDate.day + 1);
        break;
    }
  }

  Budget.fromJson(Map<String, dynamic> json)
      : label = json['label'] as String,
        remaining = json['remaining'] as double,
        total = json['total'] as double,
        resetDate = DateTime.parse(json['resetDate'] as String),
        resetInterval = ResetInterval.values[json['resetInterval'] as int];

  Map<String, dynamic> toJson() => {
        'label': label,
        'remaining': remaining,
        'total': total,
        'resetDate': resetDate.toIso8601String(),
        'resetInterval': resetInterval.index,
      };
}
