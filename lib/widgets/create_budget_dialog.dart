import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/utils/helpers.dart';
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
      title: const Text(
        "Create Budget",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: budgetNameInputController,
              decoration: InputDecoration(
                labelText: "Budget Name",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget name';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: budgetAmountInputController,
              decoration: InputDecoration(
                labelText: "Budget Amount",
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                prefixText: "\$ ",
                hintText: "0.00",
              ),
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget amount';
                }
                if (!isNumeric(value)) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Create Budget"),
              ),
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
