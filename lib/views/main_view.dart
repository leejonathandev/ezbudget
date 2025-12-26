import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:ezbudget/widgets/create_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/widgets/budget_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final NumberFormat currencyFormatter = NumberFormat.simpleCurrency();
const EdgeInsets _pageHorizontalPadding =
    EdgeInsets.symmetric(horizontal: 16.0);
const EdgeInsets _listItemPadding =
    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
const EdgeInsets _landscapeListItemPadding =
    EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0);
const EdgeInsets _landscapeColumnPadding = EdgeInsets.all(24.0);
const EdgeInsets _portraitHeaderPadding = EdgeInsets.all(12.0);

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool usePortraitLayout =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final budgetsAsync = ref.watch(budgetListProvider);
    final totalBudget = ref.watch(totalBudgetProvider);
    final totalRemaining = ref.watch(totalRemainingProvider);

    return budgetsAsync.when(
      data: (budgets) => _buildContent(
        context,
        ref,
        budgets,
        totalBudget,
        totalRemaining,
        usePortraitLayout,
      ),
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
    bool usePortraitLayout,
  ) {
    return Scaffold(
      appBar: usePortraitLayout
          ? AppBar(
              title: const Text(
                "ezBudget",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            )
          : null,
      floatingActionButton: null,
      body: SafeArea(
        child: Padding(
          padding: _pageHorizontalPadding,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return usePortraitLayout
                  ? _buildPortraitLayout(context, ref, budgets, totalRemaining)
                  : _buildLandscapeLayout(context, ref, budgets, totalRemaining,
                      totalBudget, constraints);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    WidgetRef ref,
    List<Budget> budgets,
    double totalRemaining,
  ) {
    return Column(
      children: [
        _buildTotalHeader(totalRemaining),
        Expanded(
          child: ListView.builder(
            itemCount: budgets.length + 1,
            itemBuilder: (context, index) {
              // Last item is the "add budget" card
              if (index == budgets.length) {
                return Padding(
                  padding: _listItemPadding,
                  child: _buildAddBudgetCard(context),
                );
              }
              return Padding(
                padding: _listItemPadding,
                child: BudgetTile(
                  key: ValueKey(budgets[index].label),
                  budget: budgets[index],
                  useWideLayout: true,
                  onDeleteBudget: (budget) {
                    ref.read(budgetListProvider.notifier).deleteBudget(budget);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    WidgetRef ref,
    List<Budget> budgets,
    double totalRemaining,
    double totalBudget,
    BoxConstraints constraints,
  ) {
    return SizedBox.expand(
      child: Row(
        children: [
          // Left column: summary
          SizedBox(
            width: constraints.maxWidth * 0.35,
            child: Padding(
              padding: _landscapeColumnPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TOTAL REMAINING BUDGET",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currencyFormatter.format(totalRemaining),
                    style: const TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "of ${currencyFormatter.format(totalBudget)} total",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Budget'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const CreateBudgetDialog();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Right column: list of budgets
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0,
              ),
              child: ListView.builder(
                itemCount: budgets.length + 1,
                itemBuilder: (context, index) {
                  if (index == budgets.length) {
                    return Padding(
                      padding: _landscapeListItemPadding,
                      child: _buildAddBudgetCard(context),
                    );
                  }
                  return Padding(
                    padding: _landscapeListItemPadding,
                    child: BudgetTile(
                      key: ValueKey(budgets[index].label),
                      budget: budgets[index],
                      useWideLayout: false,
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
          ),
        ],
      ),
    );
  }

  Widget _buildTotalHeader(double totalRemaining) {
    return Padding(
      padding: _portraitHeaderPadding,
      child: Column(
        children: [
          const Text(
            "TOTAL REMAINING BUDGET",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
          Text(
            currencyFormatter.format(totalRemaining),
            style: const TextStyle(
              fontSize: 55,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
