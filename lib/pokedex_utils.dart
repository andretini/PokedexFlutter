// lib/pokedex_utils.dart
int pokemonIdFromUrl(String url) {
  final parts = url.split('/').where((s) => s.isNotEmpty).toList();
  final idStr = parts.isNotEmpty ? parts.last : '';
  return int.tryParse(idStr) ?? -1;
}

String spritePngUrl(int id) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
