import 'package:flutter/material.dart';
import 'package:pokedex/homepage.dart';

const api = "https://pokeapi.co/api/v2/";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}