// ignore_for_file: unnecessary_const

import 'package:ezbudget/views/spend_view.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final NumberFormat currencyFormatter = NumberFormat.simpleCurrency();

// Maps stored icon name to material icon data; defaults to category.
IconData _iconFromName(String name) {
  const map = {
    'category': Icons.category,
    'shopping_cart': Icons.shopping_cart,
    'local_gas_station': Icons.local_gas_station,
    'fastfood': Icons.fastfood,
    'restaurant': Icons.restaurant,
    'directions_car': Icons.directions_car,
    'home': Icons.home,
    'school': Icons.school,
    'sports_soccer': Icons.sports_soccer,
    'travel_explore': Icons.travel_explore,
    'shopping_bag': Icons.shopping_bag,
    'favorite': Icons.favorite,
    'fitness_center': Icons.fitness_center,
    'theaters': Icons.theaters,
    'music_note': Icons.music_note,
    'pets': Icons.pets,
    'photo_camera': Icons.photo_camera,
    'checkroom': Icons.checkroom,
  };
  return map[name] ?? Icons.category;
}

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
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 6,
              children: [
                SizedBox(
                  width: 44,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color.lerp(
                          const Color(0xFFFFFFFF),
                          const Color(0xFF45AAED),
                          widget.budget.getPercentageRemaining(),
                        ),
                        backgroundColor: Colors.blueGrey,
                        strokeWidth: 4,
                        value: widget.budget.getPercentageRemaining(),
                        strokeCap: StrokeCap.round,
                      ),
                      Icon(
                        _iconFromName(widget.budget.icon),
                        size: 22,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.budget.label,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, height: 1.1),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currencyFormatter.format(widget.budget.remaining),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "of ${currencyFormatter.format(widget.budget.total)}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ],
            ),
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 6,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color.lerp(
                            const Color(0xFFFFFFFF),
                            const Color(0xFF45AAED),
                            widget.budget.getPercentageRemaining(),
                          ),
                          backgroundColor: Colors.blueGrey,
                          strokeWidth: 4,
                          value: widget.budget.getPercentageRemaining(),
                          strokeCap: StrokeCap.round,
                        ),
                        Icon(
                          _iconFromName(widget.budget.icon),
                          size: 22,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.budget.label,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.1),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormatter.format(widget.budget.remaining),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "of ${currencyFormatter.format(widget.budget.total)}",
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white70,
                            fontWeight: FontWeight.normal),
                      )
                    ],
                  ),
                ],
              ),
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
