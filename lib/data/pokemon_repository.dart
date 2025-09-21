// lib/data/pokemon_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/main.dart';
import 'package:pokedex/models/pokemonModel.dart';

class PokemonPage {
  final List<PokemonListResult> items;
  final int? nextOffset;

  PokemonPage({required this.items, required this.nextOffset});
}

class PokemonRepository {
  final http.Client _client;
  PokemonRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<PokemonPage> fetchPage({required int limit, required int offset}) async {
    final url = Uri.parse('$api/pokemon?limit=$limit&offset=$offset');
    final res = await _client.get(url);
    if (res.statusCode != 200) {
      throw Exception('Falha ao buscar página: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final results = (data['results'] as List)
        .map((p) => PokemonListResult.fromJson(p))
        .toList();

    final next = data['next'] as String?;
    int? nextOffset;
    if (next != null) {
      final u = Uri.parse(next);
      nextOffset = int.tryParse(u.queryParameters['offset'] ?? '');
    }
    return PokemonPage(items: results, nextOffset: nextOffset);
  }
}
