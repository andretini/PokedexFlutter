import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/pokemonDetailPage.dart';
import 'package:pokedex/providers/favorites_provider.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favorites = favoritesProvider.favorites;

          // Verifica se a lista de favoritos está vazia
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não favoritou nenhum Pokémon.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          }

          // Se não estiver vazia, exibe a lista de Pokémon
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final pokemon = favorites[index];
              return ListTile(
                // Exibe a imagem do Pokémon
                leading: Image.network(
                  pokemon.sprites.front_default ?? '',
                  // Adiciona um placeholder em caso de erro na imagem
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                title: Text(pokemon.name.toUpperCase()),
                subtitle: Text('#${pokemon.id.toString().padLeft(3, '0')}'),
                onTap: () {
                  // Ao tocar, navega para a tela de detalhes
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailPage(
                        // Precisamos passar um PokemonListResult, então criamos um
                        pokemonInfo: PokemonListResult(Name: pokemon.name, Url: ''),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
