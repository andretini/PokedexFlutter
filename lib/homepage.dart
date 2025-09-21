// lib/home_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pokedex/favorites_page.dart';
import 'package:pokedex/main.dart';
import 'package:pokedex/models/pokemonModel.dart';
import 'package:pokedex/pokemonDetailPage.dart';

import 'data/pokemon_repository.dart';
import 'widgets/search_favorites_header.dart';
import 'widgets/pokemon_grid.dart';
import 'pokedex_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repo = PokemonRepository();
  static const _pageSize = 40;

  // Paging state
  final List<PokemonListResult> _all = [];
  int _nextOffset = 0; // start at 0
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  Object? _initialError;

  // Search state
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    setState(() {
      _isInitialLoading = true;
      _initialError = null;
      _all.clear();
      _nextOffset = 0;
      _hasMore = true;
    });
    try {
      final page = await _repo.fetchPage(limit: _pageSize, offset: _nextOffset);
      if (!mounted) return;
      setState(() {
        _all.addAll(page.items);
        _nextOffset = page.nextOffset ?? _nextOffset;
        _hasMore = page.nextOffset != null;
        _isInitialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _initialError = e;
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final page = await _repo.fetchPage(limit: _pageSize, offset: _nextOffset);
      if (!mounted) return;
      setState(() {
        _all.addAll(page.items);
        _nextOffset = page.nextOffset ?? _nextOffset;
        _hasMore = page.nextOffset != null;
      });
    } catch (_) {
      // keep hasMore as-is; you could surface a toast/snackbar here
    } finally {
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<void> _refresh() async {
    await _loadFirstPage();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _all
        : _all.where((p) => p.Name.toLowerCase().contains(_query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchFavoritesHeader(
              onQueryChanged: (q) => setState(() => _query = q),
              onFavoritesPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
              },
            ),
            const SizedBox(height: 16),

            if (_isInitialLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_initialError != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Falha ao carregar.'),
                      const SizedBox(height: 8),
                      Text('$_initialError', textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                      const SizedBox(height: 12),
                      FilledButton(onPressed: _loadFirstPage, child: const Text('Tentar novamente')),
                    ],
                  ),
                ),
              )
            else if (filtered.isEmpty)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(child: Text('Nenhum Pokémon encontrado.')),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: PokemonPagedGrid(
                  items: toGridItems(filtered),
                  onPokemonTap: (id, name) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PokemonDetailPage(
                          pokemonInfo: PokemonListResult(Name: name, Url: '$api/pokemon/$id/'),
                        ),
                      ),
                    );
                  },
                  onRefresh: _refresh,
                  loadMore: _loadMore,
                  isLoadingMore: _isLoadingMore,
                  hasMore: _hasMore,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
