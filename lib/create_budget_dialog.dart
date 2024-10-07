import 'package:ezbudget/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateBudgetDialog extends StatefulWidget {
  final List<Budget> budgets;
  final Function() refreshBudgetsCallback;

  const CreateBudgetDialog(
      {super.key, required this.budgets, required this.refreshBudgetsCallback});

  @override
  State<StatefulWidget> createState() => _CreateBudgetDialogState();
}

class _CreateBudgetDialogState extends State<CreateBudgetDialog> {
  final budgetNameInputController = TextEditingController();
  final budgetAmountInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Create Budget"),
      content:
          // A Form ancestor is not required. The Form simply makes it
          // easier to save, reset, or validate multiple fields at once.
          Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: budgetNameInputController,
              decoration: const InputDecoration(labelText: "Budget Name"),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'pls gimee a NAMEE!!';
                }
                return null;
              },
            ),
            TextFormField(
              controller: budgetAmountInputController,
              decoration: const InputDecoration(labelText: "Budget Amount"),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'pls i need LIMIIT!!';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => {
                if (_formKey.currentState!.validate())
                  {
                    widget.budgets.add(
                      Budget(
                        budgetNameInputController.text,
                        double.parse(budgetAmountInputController.text),
                      ),
                    ),
                    widget.refreshBudgetsCallback(),
                    Navigator.pop(context, "create-action")
                  },
              },
              child: const Text("Create"),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    budgetNameInputController.dispose();
    budgetAmountInputController.dispose();
    super.dispose();
  }
}
