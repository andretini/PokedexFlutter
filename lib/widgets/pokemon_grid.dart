// lib/widgets/pokemon_paged_grid.dart
import 'package:flutter/material.dart';
import 'package:pokedex/pokedex_utils.dart';
import 'package:pokedex/widgets/pokemon_card.dart';

typedef PokemonTap = void Function(int id, String name);

class PokemonPagedGrid extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Future<void> Function() loadMore; // triggers loading next page
  final bool isLoadingMore;
  final bool hasMore;
  final List<_PokemonGridItem> items;

  /// If null, grid adapts by width; if set, uses fixed columns.
  final int? crossAxisCount;
  final PokemonTap onPokemonTap;

  const PokemonPagedGrid({
    super.key,
    required this.onRefresh,
    required this.loadMore,
    required this.isLoadingMore,
    required this.hasMore,
    required this.items,
    required this.onPokemonTap,
    this.crossAxisCount,
  });

  @override
  State<PokemonPagedGrid> createState() => _PokemonPagedGridState();
}

class _PokemonPagedGridState extends State<PokemonPagedGrid> {
  final _scrollCtrl = ScrollController();
  static const _pixelThreshold = 600.0; // how close to bottom before loading

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients || widget.isLoadingMore || !widget.hasMore) return;
    final max = _scrollCtrl.position.maxScrollExtent;
    final offset = _scrollCtrl.offset;
    if (max - offset <= _pixelThreshold) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final autoCount = (constraints.maxWidth / 180).floor().clamp(2, 6);
          final columns = widget.crossAxisCount ?? autoCount;

          return CustomScrollView(
            controller: _scrollCtrl,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3 / 4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final it = widget.items[index];
                      return PokemonCard(
                        name: it.name,
                        id: it.id,
                        onTap: () => widget.onPokemonTap(it.id, it.name),
                      );
                    },
                    childCount: widget.items.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: widget.isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : (!widget.hasMore
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: Text('— Sem mais resultados —')),
                            )
                          : const SizedBox.shrink()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PokemonGridItem {
  final String name;
  final int id;

  const _PokemonGridItem({required this.name, required this.id});
}

List<_PokemonGridItem> toGridItems(Iterable<dynamic> list) {
  return list
      .map((p) => _PokemonGridItem(name: p.Name, id: pokemonIdFromUrl(p.Url)))
      .toList();
}
