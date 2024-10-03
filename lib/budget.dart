class Budget {
  String label;
  double remaining;
  double total;

  Budget(this.label, this.total) : remaining = total;

  void resetBudget() {
    remaining = total;
  }

  void spendMoney(double cost) {
    remaining -= cost;
  }

  double getPercentageRemaining() {
    if (remaining == total) {
      return 1;
    }
    double percentage = remaining / total;
    if (percentage < 0) {
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
}
