// ignore_for_file: unnecessary_const

import 'package:ezbudget/spend_view.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/budget.dart';
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.simpleCurrency();

class BudgetTile extends StatefulWidget {
  final Budget budget;
  final Function() updateTotalCallback;
  final bool useWideLayout;

  const BudgetTile(
      {super.key,
      required this.budget,
      required this.updateTotalCallback,
      required this.useWideLayout});

  @override
  State<StatefulWidget> createState() => _BudgetTile();
}

class _BudgetTile extends State<BudgetTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.useWideLayout) {
      return SizedBox(
        child: Card(
          color: Colors.blueGrey,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpendView(
                      selectedBudget: widget.budget,
                      updateTotalCallback: widget.updateTotalCallback,
                    ),
                  )),
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
    } else {
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
  }

  spendMoney(double cost) {
    setState(() {
      widget.budget.spendMoney(cost);
    });
    widget.updateTotalCallback();
  }
}
