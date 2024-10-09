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
        title: const Text('Oh noes! How much monee gone?!'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textAlign: TextAlign.center,
                controller: spentAmountInputController,
                decoration: const InputDecoration(labelText: "Amount Spent"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || !isNumeric(value)) {
                    return 'how much did you SPEENND!?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                child: const Text('Confirm Spent!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
