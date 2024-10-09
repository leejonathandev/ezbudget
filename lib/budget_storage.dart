import 'dart:convert';
import 'dart:io';
import 'package:ezbudget/budget.dart';
import 'package:path_provider/path_provider.dart';

class BudgetStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  static Future<File> _localFile() async {
    final path = await _localPath;
    return File('$path/budgets.json');
  }

  static Future<List<Budget>> initializeBudgets() async {
    File budgetsDb = await _localFile();
    if (!await budgetsDb.exists()) {
      writeAllBudgets([]);
      return [];
    } else {
      return readAllBudgets();
    }
  }

  static Future<Budget> readBudget(String budgetName) async {
    List<Budget> budgets = await readAllBudgets();
    Budget budget =
        budgets.firstWhere((element) => element.label == budgetName);

    return budget;
  }

  static void writeBudget(String budgetName, double budgetAmount) async {
    var budgets = await readAllBudgets();

    // Check to see if a budget already exists with budgetName
    if (budgets.any((element) => element.label == budgetName)) {
      // If it does, update the budget amount
      budgets.firstWhere((element) => element.label == budgetName).total =
          budgetAmount;
    } else {
      // If it doesn't, add a new budget
      budgets.add(Budget(budgetName, budgetAmount));
    }

    writeAllBudgets(budgets);
  }

  static void updateBudget(String budgetName, double budgetAmount) async {
    var budgets = await readAllBudgets();

    // Find the budget with the matching name
    budgets.firstWhere((element) => element.label == budgetName).total =
        budgetAmount;

    // Set new value for that budget

    writeAllBudgets(budgets);
  }

  static void writeAllBudgets(List<Budget> budgets) async {
    final file = await _localFile();

    // Overwrite contents of the file
    String contents = json.encode(budgets);
    file.writeAsString(contents);
  }

  static Future<List<Budget>> readAllBudgets() async {
    final file = await _localFile();

    String contents = await file.readAsString();
    List<dynamic> dynamicBudgets = json.decode(contents);
    List<Budget> budgets =
        dynamicBudgets.map((e) => Budget.fromJson(e)).toList();

    return budgets;
  }
}
