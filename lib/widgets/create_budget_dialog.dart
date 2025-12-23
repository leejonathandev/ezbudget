import 'package:ezbudget/models/budget.dart';
import 'package:ezbudget/providers/budget_provider.dart';
import 'package:ezbudget/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Available icon options the user can pick.
const Map<String, IconData> iconOptions = {
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

class CreateBudgetDialog extends ConsumerStatefulWidget {
  const CreateBudgetDialog({super.key});

  @override
  ConsumerState<CreateBudgetDialog> createState() => _CreateBudgetDialogState();
}

class _CreateBudgetDialogState extends ConsumerState<CreateBudgetDialog> {
  final budgetNameInputController = TextEditingController();
  final budgetAmountInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String selectedIcon = 'category';

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
            // Icon picker
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select Icon',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: iconOptions.entries.map((entry) {
                final isSelected = selectedIcon == entry.key;
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      selectedIcon = entry.key;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.outline,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surface,
                    ),
                    child: Icon(
                      entry.value,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newBudget = Budget(
                      budgetNameInputController.text,
                      double.parse(budgetAmountInputController.text),
                      null,
                      null,
                      selectedIcon,
                    );
                    await ref
                        .read(budgetListProvider.notifier)
                        .addBudget(newBudget);
                    if (context.mounted) {
                      Navigator.pop(context, "create-action");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
