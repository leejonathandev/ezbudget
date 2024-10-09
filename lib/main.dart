import 'package:ezbudget/budget.dart';
import 'package:ezbudget/budget_storage.dart';
import 'package:ezbudget/main_view.dart';
import 'package:flutter/material.dart';

void main() async {
  final List<Budget> budgets = await BudgetStorage.initializeBudgets();
  runApp(MyApp(budgets: budgets));
}

ThemeData myTheme = ThemeData(
  fontFamily: "Ubuntu",
  useMaterial3: true,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(
        allowEnterRouteSnapshotting: false,
      ),
    },
  ),
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey, brightness: Brightness.dark),
);

class MyApp extends StatefulWidget {
  final List<Budget> budgets;

  const MyApp({super.key, required this.budgets});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(Object context) {
    String appTitle = "ezBudget";
    return MaterialApp(
      title: appTitle,
      theme: myTheme,
      home: MainView(budgets: widget.budgets),
      debugShowCheckedModeBanner: true,
    );
  }
}
