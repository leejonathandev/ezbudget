import 'package:ezbudget/budget.dart';
import 'package:ezbudget/budget_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency();

class MainView extends StatefulWidget {
  final List<Budget> budgets;

  @override
  State<StatefulWidget> createState() => _MainViewState();

  const MainView({super.key, required this.budgets});
}

class _MainViewState extends State<MainView> {
  late double totalRemainingBudget =
      widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
            child: Column(children: [
          const Text("YOUR REMAINING BUDGET"),
          Text(
            currencyFormatter.format(totalRemainingBudget),
            textScaler: const TextScaler.linear(4),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          GridView.extent(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            shrinkWrap: true,
            maxCrossAxisExtent: 200,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: widget.budgets
                .map((e) => BudgetTile(
                      budget: e,
                      callback: updateRemainingBudget,
                    ))
                .toList(),
          ),
        ]))
      ],
    );
  }

  void updateRemainingBudget() {
    setState(() {
      totalRemainingBudget =
          widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);
    });
  }
}
