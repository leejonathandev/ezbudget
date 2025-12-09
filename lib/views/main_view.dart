import 'dart:convert';
import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/widgets/create_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/widgets/budget_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainView extends StatefulWidget {
  const MainView({
    super.key,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Budget> budgets = [];
  double totalBudget = 0;
  double totalRemaining = 0;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  void _loadBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetStrings = prefs.getStringList('budgets');

    if (budgetStrings != null) {
      budgets = budgetStrings.map((b) => Budget.fromJson(jsonDecode(b))).toList();
    } else {
      budgets = [
        Budget("Groceries", 200),
        Budget("Gas", 50),
        Budget("Entertainment", 100)
      ];
    }
    _updateTotals();
    setState(() {});
  }

  void _saveBudgets() async {
    final prefs = await SharedPreferences.getInstance();
    final budgetStrings = budgets.map((b) => jsonEncode(b.toJson())).toList();
    await prefs.setStringList('budgets', budgetStrings);
  }

  void _updateTotals() {
    totalBudget = budgets.fold(0, (sum, item) => sum + item.total);
    totalRemaining = budgets.fold(0, (sum, item) => sum + item.remaining);
    _saveBudgets();
    setState(() {});
  }

  void _deleteBudget(Budget budget) {
    setState(() {
      budgets.remove(budget);
      _updateTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ezBudget",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateBudgetDialog(
                    budgets: budgets,
                    refreshBudgetsCallback: _updateTotals,
                  );
                },
              );
            },
            icon: const Icon(Icons.add, size: 32),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool useWideLayout = constraints.maxWidth > 600;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Total Budget: \$${totalBudget.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Remaining: \$${totalRemaining.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: useWideLayout
                    ? GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 1,
                        ),
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          return BudgetTile(
                            budget: budgets[index],
                            updateTotalCallback: _updateTotals,
                            useWideLayout: useWideLayout,
                            onDeleteBudget: _deleteBudget,
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: budgets.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: BudgetTile(
                              budget: budgets[index],
                              updateTotalCallback: _updateTotals,
                              useWideLayout: useWideLayout,
                              onDeleteBudget: _deleteBudget,
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
