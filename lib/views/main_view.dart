import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:ezbudget/widgets/create_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/widgets/budget_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainView extends ConsumerWidget {
  const MainView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetListProvider);
    final totalBudget = ref.watch(totalBudgetProvider);
    final totalRemaining = ref.watch(totalRemainingProvider);

    return budgetsAsync.when(
      data: (budgets) =>
          _buildContent(context, ref, budgets, totalBudget, totalRemaining),
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text(
            "ezBudget",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "ezBudget",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Budget> budgets,
    double totalBudget,
    double totalRemaining,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ezBudget",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      floatingActionButton: null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool useWideLayout = constraints.maxWidth > 600;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      "TOTAL REMAINING BUDGET",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${totalRemaining.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: useWideLayout
                    ? GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: budgets.length + 1,
                        itemBuilder: (context, index) {
                          // Last item is the "add budget" card
                          if (index == budgets.length) {
                            return _buildAddBudgetCard(context);
                          }
                          return BudgetTile(
                            key: ValueKey(budgets[index].label),
                            budget: budgets[index],
                            useWideLayout: useWideLayout,
                            onDeleteBudget: (budget) {
                              ref
                                  .read(budgetListProvider.notifier)
                                  .deleteBudget(budget);
                            },
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: budgets.length + 1,
                        itemBuilder: (context, index) {
                          // Last item is the "add budget" card
                          if (index == budgets.length) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: _buildAddBudgetCard(context),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: BudgetTile(
                              key: ValueKey(budgets[index].label),
                              budget: budgets[index],
                              useWideLayout: useWideLayout,
                              onDeleteBudget: (budget) {
                                ref
                                    .read(budgetListProvider.notifier)
                                    .deleteBudget(budget);
                              },
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

  Widget _buildAddBudgetCard(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CreateBudgetDialog();
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Icon(
              Icons.add_circle_outline,
              size: 36,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
