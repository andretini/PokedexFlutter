
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
  // 1. Criamos uma variável Future que guardará o resultado da nossa busca na API.
  late Future<List<PokemonListResult>> _pokemonListFuture;

  // 2. Modificamos a função para que ela RETORNE um Future com a lista de Pokémon.
  Future<List<PokemonListResult>> fetchPokemons() async {
    final url = Uri.parse(api + 'pokemon?limit=100');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // O 'return' envia os dados para o FutureBuilder.
      return (data['results'] as List)
          .map((pokemon) => PokemonListResult.fromJson(pokemon))
          .toList();
    } else {
      // Se der erro, lançamos uma exceção que o FutureBuilder vai capturar.
      throw Exception('Falha ao carregar a lista de Pokémon');
    }
  }

  // Função para tentar recarregar os dados em caso de erro.
  void _retryFetch() {
    setState(() {
      _pokemonListFuture = fetchPokemons();
    });
  }

  @override
  void initState() {
    super.initState();
    // 3. No initState, nós iniciamos a busca e atribuímos o Future à nossa variável.
    _pokemonListFuture = fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Buscar Pokémon',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.favorite),
                label: const Text("Ver Favoritos"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              // 4. A lista agora é construída pelo FutureBuilder.
              Expanded(
                child: FutureBuilder<List<PokemonListResult>>(
                  future: _pokemonListFuture,
                  builder: (context, snapshot) {
                    // **ESTADO DE CARREGAMENTO**
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // **ESTADO DE ERRO**
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Ocorreu um erro ao buscar os dados.'),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _retryFetch,
                              child: const Text('Tentar Novamente'),
                            )
                          ],
                        ),
                      );
                    }

                    // **ESTADO DE SUCESSO**
                    if (snapshot.hasData) {
                      final pokemonList = snapshot.data!;
                      return ListView.builder(
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                pokemon.Name,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    // Estado inicial ou caso não tenha dados (pouco provável de acontecer)
                    return const Center(child: Text('Nenhum Pokémon encontrado.'));
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