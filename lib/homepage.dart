import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/pokemonDetailPage.dart';
import 'package:pokedex/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PokemonListResult> pokemonList = [];

  void fetchPokemons() async {
    final url = Uri.parse(api + 'pokemon?limit=100');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemonList = (data['results'] as List)
            .map((pokemon) => PokemonListResult.fromJson(pokemon))
            .toList();
      });
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Pokedex App",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Search by Pokemon Name',
                      ),
                    ),
                  ),

                  SizedBox(width: 8),

                  IconButton(icon: Icon(Icons.search), onPressed: () {}),
                ],
              ),

              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.favorite),
                label: Text("Ver Favoritos"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: pokemonList.length,
                  itemBuilder: (context, index) {
                    final pokemon = pokemonList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailPage(pokemonInfo: pokemon),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          pokemon.Name,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
