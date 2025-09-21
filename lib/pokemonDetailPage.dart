import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:provider/provider.dart';
import 'package:pokedex/providers/favorites_provider.dart';

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
    final url = Uri.parse('${api}/pokemon/${widget.pokemonInfo.Name.toLowerCase()}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Garante que o widget ainda está na árvore de widgets antes de atualizar o estado
      if (mounted) {
        setState(() {
          pokemon = Pokemon.fromJson(data);
        });
      }
    } else {
      debugPrint('Falha ao carregar o Pokémon: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonInfo.Name.toUpperCase()),
        // 2. A propriedade 'actions' é onde adicionamos botões à direita na AppBar.
        actions: [
          if (pokemon != null)
            Consumer<FavoritesProvider>(
              builder: (context, favoritesProvider, child) {
                final isFav = favoritesProvider.isFavorite(pokemon!);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.amber : Colors.blueAccent,
                    size: 30,
                  ),
                  onPressed: () {
                    favoritesProvider.toggleFavorite(pokemon!);
                  },
                );
              },
            )
        ],
      ),
      body: Center(
        // Enquanto 'pokemon' for nulo, exibe um indicador de carregamento.
        child: pokemon == null
            ? const CircularProgressIndicator()
            : SingleChildScrollView( // Adicionado para evitar overflow em telas pequenas
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sprite
              Image.network(
                pokemon!.sprites.front_default ?? '',
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 100);
                },
              ),

              const SizedBox(height: 16),

              // Nome e número da Pokédex
              Text(
                pokemon!.name.toUpperCase(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (pokemon!.id != null) // id vem da própria resposta do endpoint
                Text(
                  "#${pokemon!.id.toString()}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),

              const SizedBox(height: 16),

              // Altura e peso
              Text("Altura: ${pokemon!.height / 10} m"),
              Text("Peso: ${pokemon!.weight / 10} kg"),

              const SizedBox(height: 16),

              // Tipos
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tipos:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: pokemon!.types
                    .map((t) => Chip(label: Text(t.type.name)))
                    .toList(),
              ),

              const SizedBox(height: 16),

              // Habilidades
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Habilidades:",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: pokemon!.abilities.map((a) {
                  // OBS: ajuste o nome do campo de "is_hidden" para "isHidden" se seu model usar camelCase.
                  final bool isHidden = (a.is_hidden == true) || (a.is_hidden == true);
                  final label = isHidden ? '${a.ability?.name} (Oculta)' : a.ability?.name;
                  return Chip(label: Text(label!));
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

