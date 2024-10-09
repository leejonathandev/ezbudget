/// This is the Budget class.
/// It contains the label, remaining amount, and total amount of the budget.
/// It also has methods to reset the budget, spend money, and get the percentage remaining.
class Budget {
  String label;
  double remaining;
  double total;

  Budget(this.label, this.total, [double? remaining])
      : remaining = remaining ?? total;

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

  Budget.fromJson(Map<String, dynamic> json)
      : label = json['label'] as String,
        remaining = json['remaining'] as double,
        total = json['total'] as double;

  Map<String, dynamic> toJson() => {
        'label': label,
        'remaining': remaining,
        'total': total,
      };
}
