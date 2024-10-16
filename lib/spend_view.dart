import 'package:ezbudget/budget.dart';
import 'package:flutter/material.dart';
import 'package:ezbudget/helpers.dart';

class SpendView extends StatefulWidget {
  final Budget selectedBudget;
  final Function() updateTotalCallback;

  @override
  State<StatefulWidget> createState() => _SpendViewState();

  const SpendView(
      {super.key,
      required this.selectedBudget,
      required this.updateTotalCallback});
}

class _SpendViewState extends State<SpendView> {
  final spentAmountInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oh noes! Monee gone?!'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 40),
                maxLines: 1,
                enableSuggestions: false,
                autocorrect: false,
                autofocus: false,
                textAlign: TextAlign.center,
                controller: spentAmountInputController,
                decoration: const InputDecoration(
                    labelText: "Amount Spent", border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || !isNumeric(value)) {
                    return 'how much did you SPEENND!?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      widget.selectedBudget.spendMoney(
                        double.parse(spentAmountInputController.text),
                      ),
                      widget.updateTotalCallback(),
                      Navigator.pop(context),
                    }
                },
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.surfaceContainerHigh,
                  ),
                  foregroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primaryFixed,
                  ),
                ),
                child: const Text(
                  'CONFIRM',
                  style: TextStyle(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
