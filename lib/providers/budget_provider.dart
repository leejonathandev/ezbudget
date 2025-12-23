import 'dart:convert';
import 'package:ezbudget/models/budget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final budgetListProvider =
    NotifierProvider<BudgetNotifier, AsyncValue<List<Budget>>>(() {
  return BudgetNotifier();
});

final totalBudgetProvider = Provider<double>((ref) {
  final budgetsAsync = ref.watch(budgetListProvider);
  return budgetsAsync.maybeWhen(
    data: (budgets) => budgets.fold(0, (sum, item) => sum + item.total),
    orElse: () => 0,
  );
});

final totalRemainingProvider = Provider<double>((ref) {
  final budgetsAsync = ref.watch(budgetListProvider);
  return budgetsAsync.maybeWhen(
    data: (budgets) => budgets.fold(0, (sum, item) => sum + item.remaining),
    orElse: () => 0,
  );
});

class BudgetNotifier extends Notifier<AsyncValue<List<Budget>>> {
  @override
  AsyncValue<List<Budget>> build() {
    _loadBudgets();
    return const AsyncValue.loading();
  }

  Future<void> _loadBudgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budgetStrings = prefs.getStringList('budgets');

      late List<Budget> budgets;
      if (budgetStrings != null) {
        budgets =
            budgetStrings.map((b) => Budget.fromJson(jsonDecode(b))).toList();
      } else {
        budgets = [
          Budget("Groceries", 200),
          Budget("Gas", 50),
          Budget("Entertainment", 100)
        ];
        await _saveBudgets(budgets);
      }
      state = AsyncValue.data(budgets);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> _saveBudgets(List<Budget> budgets) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budgetStrings = budgets.map((b) => jsonEncode(b.toJson())).toList();
      await prefs.setStringList('budgets', budgetStrings);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addBudget(Budget budget) async {
    state.whenData((budgets) async {
      final updatedBudgets = [...budgets, budget];
      await _saveBudgets(updatedBudgets);
      state = AsyncValue.data(updatedBudgets);
    });
  }

  Future<void> deleteBudget(Budget budget) async {
    state.whenData((budgets) async {
      final updatedBudgets = budgets.where((b) => b != budget).toList();
      await _saveBudgets(updatedBudgets);
      state = AsyncValue.data(updatedBudgets);
    });
  }

  Future<void> updateBudget(Budget updatedBudget) async {
    state.whenData((budgets) async {
      final updatedBudgets =
          budgets.map((b) => b == updatedBudget ? updatedBudget : b).toList();
      await _saveBudgets(updatedBudgets);
      state = AsyncValue.data(updatedBudgets);
    });
  }
}
