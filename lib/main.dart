import 'package:ezbudget/budget.dart';
import 'package:ezbudget/main_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

ThemeData myTheme = ThemeData(
  fontFamily: GoogleFonts.ubuntu().fontFamily,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey, brightness: Brightness.dark),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

List<Budget> myBudgets = [
  Budget("Test Budget 1", 101.23),
  Budget("Test Budget 2", 102.45),
  Budget("Test Budget 3", 103.67),
  Budget("Test Budget 2", 102.45),
  Budget("Test Budget 3", 103.67),
  Budget("Test Budget 2", 102.45),
  Budget("Test Budget 3", 103.67),
];

class _MyAppState extends State<MyApp> {
  @override
  Widget build(Object context) {
    String appTitle = "ezBudget";
    return MaterialApp(
      title: "${appTitle}1",
      theme: myTheme,
      home: MainView(budgets: myBudgets),
      debugShowCheckedModeBanner: true,
    );
  }
}
