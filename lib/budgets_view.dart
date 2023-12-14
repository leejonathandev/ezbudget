import 'package:ezbudget/budget.dart';
import 'package:ezbudget/budget_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency();

class BudgetsView extends StatefulWidget {
  final List<Budget> budgets;
  const BudgetsView({super.key, required this.budgets});

  @override
  State<StatefulWidget> createState() => _BudgetsViewState();
}

class _BudgetsViewState extends State<BudgetsView> {
  late double totalRemainingBudget =
      widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      const Text("YOUR REMAINING BUDGET"),
      Text(
        currencyFormatter.format(totalRemainingBudget),
        textScaler: const TextScaler.linear(4),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 20),
      Flexible(
        child: GridView.extent(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          maxCrossAxisExtent: 200,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: widget.budgets.map((e) => BudgetTile(budget: e)).toList(),
        ),
      )
    ]));
  }

  void updateRemainingBudget() {
    setState(() {
      totalRemainingBudget =
          widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);
    });
  }
}
