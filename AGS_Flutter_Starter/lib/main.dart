import 'package:flutter/material.dart';
import 'services/team_crud_template.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibraryLokal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 174, 86, 28)),
        useMaterial3: true,
      ),
      home: const TeamCrudScreen(),
      // TODO (Week 6): We will add routes here for KantinKu Menu Navigation!
    );
  }
}
