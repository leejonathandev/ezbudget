import 'package:ezbudget/budget.dart';
import 'package:flutter/material.dart';

class CreateBudgetView extends StatefulWidget {
  final List<Budget> budgets;

  @override
  State<StatefulWidget> createState() => _CreateBudgetViewState();

  const CreateBudgetView({super.key, required this.budgets});
}

class _CreateBudgetViewState extends State<CreateBudgetView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Budget'),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "Budget Name"),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Budget Amount"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () => {},
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }
}
