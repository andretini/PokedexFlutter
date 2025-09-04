import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/homepage.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/pokemonModel.dart';

import 'package:http/http.dart' as http;

class PokemonDetailPage extends StatefulWidget {
  const PokemonDetailPage({super.key, required this.pokemonInfo});
  final PokemonListResult pokemonInfo;

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  Pokemon? pokemon;

  void fetchPokemon() async {
    final url = Uri.parse(api + 'pokemon/' + widget.pokemonInfo.Name);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemon = Pokemon.fromJson(data);
      });
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchPokemon();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonInfo.Name.toUpperCase()),
      ),
      body: Center(
        child: pokemon == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(pokemon!.sprites.front_default!),
                  Text(
                    pokemon!.name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text("Height: ${pokemon!.height}"),
                  Text("Weight: ${pokemon!.weight}"),
                  const SizedBox(height: 16),
                  const Text(
                    "Types:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: pokemon!.types
                        .map((typeInfo) => Chip(
                              label: Text(typeInfo.type.name),
                            ))
                        .toList(),
                  ),
                ],
              ),
      ),
    );
  }
}