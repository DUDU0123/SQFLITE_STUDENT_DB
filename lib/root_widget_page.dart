import 'package:database_practice/screens/home_page.dart';
import 'package:flutter/material.dart';

class RootWidgetPage extends StatelessWidget {
  const RootWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 116, 113, 116),
        ),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}