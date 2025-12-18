import 'package:ezbudget/views/main_view.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
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
  const MyApp({super.key});

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
      home: const MainView(),
      debugShowCheckedModeBanner: true,
    );
  }
}
