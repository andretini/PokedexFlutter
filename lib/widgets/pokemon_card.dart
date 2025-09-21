// lib/widgets/pokemon_card.dart
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final String name;
  final int id;
  final VoidCallback? onTap;

  const PokemonCard({super.key, required this.name, required this.id, this.onTap});

  @override
  Widget build(BuildContext context) {
    final sprite = id > 0
        ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png'
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (sprite != null)
                Image.network(
                  sprite,
                  height: 80,
                  width: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error_outline),
                )
              else
                const Icon(Icons.help_outline, size: 56),
              const SizedBox(height: 12),
              Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (id > 0)
                Text('#${id.toString().padLeft(3, '0')}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
