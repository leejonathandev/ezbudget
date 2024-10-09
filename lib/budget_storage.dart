import 'dart:convert';
import 'dart:io';
import 'package:ezbudget/budget.dart';
import 'package:path_provider/path_provider.dart';

/// This class is responsible for storing and retrieving budgets from local storage.
/// It uses the path_provider package to get the application documents directory.
/// It uses the json package to encode and decode the budgets to and from JSON.
/// It uses the File class to read and write to the local file.
/// It has methods to read and write a single budget, and to read and write all budgets.
/// It also has a method to initialize the budgets from local storage.
/// If the file does not exist, it creates a new file with an empty list of budgets.
/// If the file exists, it reads the budgets from the file and returns them.
/// The file is named "budgets.json" and is stored in the application documents directory.
/// The budgets are stored as a list of maps, where each map represents a budget.
/// The map contains the following keys:
/// - label: The name of the budget.
/// - remaining: The remaining amount of the budget.
/// - total: The total amount of the budget.
class BudgetStorage {
  /// This method gets the local path of the application documents directory.
  ///
  /// Returns:
  /// - The local path of the application documents directory.
  ///
  /// Example:
  /// ```dart
  /// final path = await BudgetStorage._localPath;
  /// ```
  ///
  /// This method will return the local path of the application documents directory.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  /// This method gets the local path of the application documents directory.
  ///
  /// Returns:
  /// - The local path of the application documents directory.
  ///
  /// Example:
  /// ```dart
  /// final path = await BudgetStorage._localPath;
  /// ```
  ///
  /// This method will return the local path of the application documents directory.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  static Future<File> _localFile() async {
    final path = await _localPath;
    return File('$path/budgets.json');
  }

  /// This method initializes the budgets from local storage.
  /// If the file does not exist, it creates a new file with an empty list of budgets.
  /// If the file exists, it reads the budgets from the file and returns them.
  /// The file is named "budgets.json" and is stored in the application documents directory.
  /// The budgets are stored as a list of maps, where each map represents a budget.
  /// The map contains the following keys:
  /// - label: The name of the budget.
  /// - remaining: The remaining amount of the budget.
  /// - total: The total amount of the budget.
  ///
  /// Returns:
  /// - A list of budgets.
  ///
  /// Example:
  /// ```dart
  /// final budgets = await BudgetStorage.initializeBudgets();
  /// ```
  ///
  /// This method will read the budgets from the file "budgets.json" in the application documents directory.
  /// If the file does not exist, it will create a new file with an empty list of budgets.
  /// The budgets will be returned as a list of Budget objects.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  /// - [File]
  /// - [json]
  /// - [Budget]
  /// - [readAllBudgets]
  /// - [writeAllBudgets]
  static Future<List<Budget>> initializeBudgets() async {
    File budgetsDb = await _localFile();
    if (!await budgetsDb.exists()) {
      writeAllBudgets([]);
      return [];
    } else {
      return readAllBudgets();
    }
  }

  /// This method writes all budgets to local storage.
  /// The budgets are stored as a list of maps, where each map represents a budget.
  /// The map contains the following keys:
  /// - label: The name of the budget.
  /// - remaining: The remaining amount of the budget.
  /// - total: The total amount of the budget.
  /// The budgets are written to the file "budgets.json" in the application documents directory.
  ///
  /// Args:
  /// - budgets: A list of budgets.
  ///
  /// Example:
  /// ```dart
  /// BudgetStorage.writeAllBudgets([
  ///   Budget("Food", 100),
  ///   Budget("Rent", 1000),
  /// ]);
  /// ```
  ///
  /// This method will write the two budgets to the file "budgets.json" in the application documents directory.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  /// - [File]
  /// - [json]
  /// - [Budget]
  /// - [readAllBudgets]
  /// - [writeBudget]
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

  /// This method reads a budget from local storage.
  /// The budget is read from the file "budgets.json" in the application documents directory.
  /// The budget is returned as a Budget object.
  ///
  /// Args:
  /// - budgetName: The name of the budget.
  ///
  /// Returns:
  /// - A Budget object.
  ///
  /// Example:
  /// ```dart
  /// final budget = await BudgetStorage.readBudget("Food");
  /// ```
  ///
  /// This method will read the budget with the name "Food" from the file "budgets.json" in the application documents directory.
  /// The budget will be returned as a Budget object.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  /// - [File]
  /// - [json]
  /// - [Budget]
  /// - [readAllBudgets]
  /// - [writeAllBudgets]
  static Future<Budget> readBudget(String budgetName) async {
    List<Budget> budgets = await readAllBudgets();
    Budget budget =
        budgets.firstWhere((element) => element.label == budgetName);

    return budget;
  }

  /// This method writes a budget to local storage.
  /// The budget is stored as a map, where the keys are the label, remaining, and total.
  /// The values are the corresponding values of the budget.
  /// The budget is written to the file "budgets.json" in the application documents directory.
  ///
  /// Args:
  /// - budgetName: The name of the budget.
  /// - budgetAmount: The total amount of the budget.
  ///
  /// Example:
  /// ```dart
  /// BudgetStorage.writeBudget("Food", 100);
  /// ```
  ///
  /// This method will write a new budget to the file "budgets.json" in the application documents directory.
  /// The budget will have the name "Food" and the total amount of 100.
  ///
  /// See also:
  /// - [getApplicationDocumentsDirectory]
  /// - [File]
  /// - [json]
  /// - [Budget]
  /// - [readAllBudgets]
  /// - [writeAllBudgets]
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
}
