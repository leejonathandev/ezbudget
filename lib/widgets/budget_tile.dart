// ignore_for_file: unnecessary_const

import 'package:ezbudget/views/spend_view.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NumberFormat currencyFormatter = NumberFormat.simpleCurrency();

class BudgetTile extends ConsumerStatefulWidget {
  final Budget budget;
  final bool useWideLayout;
  final Function(Budget) onDeleteBudget;

  const BudgetTile({
    super.key,
    required this.budget,
    required this.useWideLayout,
    required this.onDeleteBudget,
  });

  @override
  ConsumerState<BudgetTile> createState() => _BudgetTile();
}

class _BudgetTile extends ConsumerState<BudgetTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.useWideLayout) {
      return Card(
        color: Colors.blueGrey,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpendView(
                selectedBudget: widget.budget,
              ),
            ),
          ),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Manage ${widget.budget.label}'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.refresh),
                        title: const Text('Reset Budget'),
                        onTap: () async {
                          widget.budget.resetBudget();
                          await ref
                              .read(budgetListProvider.notifier)
                              .updateBudget(widget.budget);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        title: Text(
                          'Delete Budget',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                        onTap: () {
                          widget.onDeleteBudget(widget.budget);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.budget.label,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormatter.format(widget.budget.remaining),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "of ${currencyFormatter.format(widget.budget.total)}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              LinearProgressIndicator(
                color: Color.lerp(
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                  widget.budget.getPercentageRemaining(),
                ),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                minHeight: 8,
                value: widget.budget.getPercentageRemaining(),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        child: Card(
          color: Colors.blueGrey,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpendView(
                    selectedBudget: widget.budget,
                  ),
                )),
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Manage ${widget.budget.label}'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text('Reset Budget'),
                          onTap: () async {
                            widget.budget.resetBudget();
                            await ref
                                .read(budgetListProvider.notifier)
                                .updateBudget(widget.budget);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete,
                              color: Theme.of(context).colorScheme.error),
                          title: Text(
                            'Delete Budget',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                          onTap: () {
                            widget.onDeleteBudget(widget.budget);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(widget.budget.label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    " ${currencyFormatter.format(widget.budget.remaining)} / ${currencyFormatter.format(widget.budget.total)} "),
                const SizedBox(height: 5),
                LinearProgressIndicator(
                  color: Color.lerp(
                      const Color(0xFFFFFFFF),
                      const Color(0xFF45AAED),
                      widget.budget.getPercentageRemaining()),
                  backgroundColor: Colors.blueGrey,
                  minHeight: 10,
                  value: widget.budget.getPercentageRemaining(),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  void spendMoney(double cost) {
    setState(() {
      widget.budget.spendMoney(cost);
    });
  }
}
