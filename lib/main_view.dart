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
  bool useWideLayout = true;
  late double totalRemainingBudget =
      widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ezBudget"), actions: [
        IconButton(
            onPressed: toggleBudgetLayout, icon: const Icon(Icons.swap_horiz))
      ]),
      body: Column(children: [
        const SizedBox(height: 20),
        const Text("TOTAL REMAINING BUDGET"),
        Text(
          currencyFormatter.format(totalRemainingBudget),
          textScaler: const TextScaler.linear(4),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: buildBudgetLayout(useWideLayout),
        )
      ]),
    );
  }

  void updateRemainingBudget() {
    setState(() {
      totalRemainingBudget =
          widget.budgets.map((e) => e.remaining).reduce((a, b) => a + b);
    });
  }

  void toggleBudgetLayout() {
    setState(() {
      useWideLayout = !useWideLayout;
    });
  }

  Widget buildBudgetLayout([bool useWideLayout = true]) {
    if (useWideLayout) {
      // convert to ListView.builder
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
        padding: const EdgeInsets.all(15),
        itemCount: widget.budgets.length,
        itemBuilder: (context, index) {
          return BudgetTile(
            budget: widget.budgets[index],
            updateTotalCallback: updateRemainingBudget,
            useWideLayout: useWideLayout,
          );
        },
      );
    } else {
      // convert to GridView.builder
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        padding: const EdgeInsets.all(15),
        itemCount: widget.budgets.length,
        itemBuilder: (context, index) {
          return BudgetTile(
            budget: widget.budgets[index],
            updateTotalCallback: updateRemainingBudget,
            useWideLayout: false,
          );
        },
      );
    }
  }
}
