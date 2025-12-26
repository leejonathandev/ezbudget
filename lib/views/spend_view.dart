import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:ezbudget/utils/helpers.dart';

class SpendView extends ConsumerStatefulWidget {
  final Budget selectedBudget;

  const SpendView({
    super.key,
    required this.selectedBudget,
  });

  @override
  ConsumerState<SpendView> createState() => _SpendViewState();
}

class _SpendViewState extends ConsumerState<SpendView> {
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

  void _addDeduction() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text);
      final description = _descriptionController.text;

      if (amount != null) {
        setState(() {
          widget.selectedBudget.spendMoney(amount, description);
          _amountController.clear();
          _descriptionController.clear();
          // Close the keyboard
          FocusScope.of(context).unfocus();
        });
        // Update the provider to sync changes
        await ref
            .read(budgetListProvider.notifier)
            .updateBudget(widget.selectedBudget);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > 600;
              return isLandscape
                  ? _buildLandscapeLayout()
                  : _buildPortraitLayout();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Part 1: Budget Info and Deduction Form (Fixed)
          _buildBudgetSummaryAndForm(),
          const SizedBox(height: 24),
          // Part 2: Transaction History (Scrollable)
          const Text(
            'Transaction History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: _buildTransactionHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Left side: Budget Summary and Form (centered)
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                child: _buildBudgetSummaryAndForm(),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Right side: Transaction History (scrollable)
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: _buildTransactionHistory(),
                ),
              ],
            ),
          ),
        ],
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
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary),
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
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
      return Center(
        child: Text(
          'No transactions yet.',
          style: TextStyle(
              fontSize: 16, color: Theme.of(context).colorScheme.outline),
        ),
      );
    }

    return ListView.builder(
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
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
