import 'package:ezbudget/budget.dart';
import 'package:ezbudget/budget_storage.dart';
import 'package:ezbudget/budget_tile.dart';
import 'package:ezbudget/create_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency();

class MainView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainViewState();

  const MainView({super.key});
}

class _MainViewState extends State<MainView> {
  List<Budget> budgets = [];
  double totalRemainingBudget = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the budgets from local storage.
    BudgetStorage.initializeBudgets().then((value) {
      setState(() {
        budgets.addAll(value);
        totalRemainingBudget =
            budgets.fold<double>(0, (a, b) => a + b.remaining);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ezBudget"),
      ),
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
          child: buildBudgetLayout(),
        )
      ]),
    );
  }

  Widget buildBudgetLayout() {
    // Use MediaQuery to determine the layout based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600; // threshold for wide layout

    if (!isWideScreen) {
      // convert to ListView.builder
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
        padding: const EdgeInsets.all(15),
        itemCount: budgets.length + 1,
        itemBuilder: (context, index) {
          if (index < budgets.length) {
            return BudgetTile(
              budget: budgets[index],
              updateTotalCallback: updateRemainingBudget,
              useWideLayout: isWideScreen,
              onDeleteBudget: deleteBudget,
            );
          } else {
            /*
            This below is the code for the extra tile 
            at the bottom of the screen to add another budget.
            */
            return SizedBox(
              child: Card(
                // Styling for the card
                color: Color.lerp(
                    Theme.of(context).primaryColor, Colors.white, 0.1),
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                  // This is what changes the screen
                  // when you press the button
                  onTap: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => CreateBudgetDialog(
                        budgets: budgets,
                        refreshBudgetsCallback: updateRemainingBudget),
                  ),
                  // This is for the icon in the middle
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Icon(
                          size: 50,
                          color: Colors.white24,
                          Icons.add_circle_outline),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    } else {
      // convert to GridView.builder
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, // Reduced from 400
          mainAxisSpacing: 10, // Reduced from 15
          crossAxisSpacing: 10, // Reduced from 15
          childAspectRatio:
              1.2, // Width:Height ratio (slightly wider than tall)
        ),
        padding: const EdgeInsets.all(15),
        itemCount: budgets.length + 1,
        itemBuilder: (context, index) {
          if (index < budgets.length) {
            return BudgetTile(
              budget: budgets[index],
              updateTotalCallback: updateRemainingBudget,
              useWideLayout: true,
              onDeleteBudget: deleteBudget,
            );
          } else {
            return Card(
              color:
                  Color.lerp(Theme.of(context).primaryColor, Colors.white, 0.1),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CreateBudgetDialog(
                      budgets: budgets,
                      refreshBudgetsCallback: updateRemainingBudget),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Icon(
                        size: 50,
                        color: Colors.white24,
                        Icons.add_circle_outline),
                  ),
                ),
              ),
            );
          }
        },
      );
    }
  }

  /// This method updates the total remaining budget.
  /// It is called whenever a budget is updated.
  /// It updates the total remaining budget by adding the remaining amount of each budget.
  /// It then updates the state of the widget to reflect the new total remaining budget.
  void updateRemainingBudget() {
    BudgetStorage.writeAllBudgets(budgets);
    setState(() {
      totalRemainingBudget =
          budgets.map((e) => e.remaining).reduce((a, b) => a + b);
    });
  }

  void deleteBudget(Budget budget) {
    setState(() {
      budgets.remove(budget);
      if (budgets.isNotEmpty) {
        totalRemainingBudget =
            budgets.map((e) => e.remaining).reduce((a, b) => a + b);
      } else {
        totalRemainingBudget = 0;
      }
    });
    BudgetStorage.writeAllBudgets(budgets);
  }
}
