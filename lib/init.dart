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
        seedColor: Colors.blueGrey, brightness: Brightness.dark));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

List<Budget> myBudgets = [
  Budget("Test Budget 1", 101.23),
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
        home: Scaffold(
            appBar: AppBar(
              title: Text("${appTitle}2"),
              scrolledUnderElevation: 0.2,
              toolbarHeight: 50,
            ),
            body: MainView(budgets: myBudgets)));
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter App Demo",
      theme: myTheme,
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Flutter layout demo"),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatefulText(),
              ],
            ),
          )),
    );
  }
}

class StatefulText extends StatefulWidget {
  const StatefulText({super.key});

  @override
  State<StatefulWidget> createState() => _StatefulTextState();
}

class _StatefulTextState extends State {
  final String _text = "Hello ";
  String _name = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        '$_text$_name!',
        textScaler: const TextScaler.linear(3),
      ),
      const SizedBox(height: 30),
      SizedBox(
        width: 250,
        child: TextField(
          style: const TextStyle(fontSize: 30),
          onChanged: ((value) => changeName(value)),
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
              floatingLabelStyle: TextStyle(fontSize: 20)),
        ),
      )
    ]);
  }

  void changeName(String newName) {
    setState(() {
      _name = newName;
    });
  }
}
*/
