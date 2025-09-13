import 'package:flutter/material.dart';
import 'package:pokedex/homepage.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

const api = "https://pokeapi.co/api/v2/";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(), // Cria uma instância do nosso provider
      child: const MainApp(), // O nosso app original se torna filho do provider
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
      debugShowCheckedModeBanner: false, // remove o banner de debug
    );
  }
}

