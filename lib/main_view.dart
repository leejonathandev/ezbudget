import 'package:ezbudget/budget.dart';
import 'package:ezbudget/budget_tile.dart';
import 'package:ezbudget/create_budget_screen.dart';
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

  Widget buildBudgetLayout([bool useWideLayout = true]) {
    if (useWideLayout) {
      // convert to ListView.builder
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 10,
        ),
        padding: const EdgeInsets.all(15),
        itemCount: widget.budgets.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.budgets.length) {
            return BudgetTile(
              budget: widget.budgets[index],
              updateTotalCallback: updateRemainingBudget,
              useWideLayout: useWideLayout,
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
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateBudgetView()),
                    )
                  },
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
}
