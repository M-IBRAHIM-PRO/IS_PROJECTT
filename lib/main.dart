import 'package:flutter/material.dart';
import 'package:is_project/home.dart';
import 'package:is_project/suggestions.dart';
import 'package:is_project/testfile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Microphone Checker'),
      home: HomePage()
    );
  }
}
