import 'package:ezbudget/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ezbudget/utils/helpers.dart';

class SpendView extends StatefulWidget {
  final Budget selectedBudget;
  final Function() updateTotalCallback;

  @override
  State<StatefulWidget> createState() => _SpendViewState();

  const SpendView({
    super.key,
    required this.selectedBudget,
    required this.updateTotalCallback,
  });
}

class _SpendViewState extends State<SpendView> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final currencyFormatter = NumberFormat.simpleCurrency();

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addDeduction() {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      final description = _descriptionController.text;

      if (amount != null) {
        setState(() {
          widget.selectedBudget.spendMoney(amount, description);
          widget.updateTotalCallback();
          _amountController.clear();
          _descriptionController.clear();
          // Close the keyboard
          FocusScope.of(context).unfocus();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort deductions by date, newest first
    widget.selectedBudget.deductions.sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedBudget.label),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Part 1: Budget Info and Deduction Form
            _buildBudgetSummaryAndForm(),
            const SizedBox(height: 24),
            // Part 2: Transaction History
            const Text(
              'Transaction History',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryAndForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Remaining Budget',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormatter.format(widget.selectedBudget.remaining),
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Item/Deduction Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: r'$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (!isNumeric(value)) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addDeduction,
                icon: const Icon(Icons.add),
                label: const Text('Add Deduction'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ], 
    );
  }

  Widget _buildTransactionHistory() {
    final deductions = widget.selectedBudget.deductions;

    if (deductions.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No transactions yet.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: deductions.length,
        itemBuilder: (context, index) {
          final deduction = deductions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              title: Text(deduction.description),
              subtitle: Text(DateFormat.yMMMd().format(deduction.date)),
              trailing: Text(
                '- ${currencyFormatter.format(deduction.amount)}',
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
