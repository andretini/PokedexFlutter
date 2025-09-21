// lib/widgets/search_favorites_header.dart
import 'dart:async';
import 'package:flutter/material.dart';

class SearchFavoritesHeader extends StatefulWidget {
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onFavoritesPressed;
  final String initialQuery;

  const SearchFavoritesHeader({
    super.key,
    required this.onQueryChanged,
    required this.onFavoritesPressed,
    this.initialQuery = '',
  });

  @override
  State<SearchFavoritesHeader> createState() => _SearchFavoritesHeaderState();
}

class _SearchFavoritesHeaderState extends State<SearchFavoritesHeader> {
  late final TextEditingController _ctrl;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialQuery);
    _ctrl.addListener(_handleChanged);
  }

  void _handleChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onQueryChanged(_ctrl.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Buscar Pokémon',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: widget.onFavoritesPressed,
          icon: const Icon(Icons.favorite),
          label: const Text('Favoritos'),
        ),
      ],
    );
  }
}
