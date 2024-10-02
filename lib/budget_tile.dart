import 'package:flutter/material.dart';
import 'package:ezbudget/budget.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency();

class BudgetTile extends StatefulWidget {
  final Budget budget;
  final Function() updateTotalCallback;

  const BudgetTile(
      {super.key, required this.budget, required this.updateTotalCallback});

  @override
  State<StatefulWidget> createState() => _BudgetTile();
}

class _BudgetTile extends State<BudgetTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Colors.blueGrey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(widget.budget.label),
        Text(currencyFormatter.format(widget.budget.remaining)),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () => spendMoney(10), child: const Text("Spend \$10"))
      ]),
    );
  }

  spendMoney(double cost) {
    setState(() {
      widget.budget.remaining -= cost;
    });
    widget.updateTotalCallback();
  }
}
