import 'dart:convert';
import 'package:http/http.dart' as http;

/// =======================
/// Core Models
/// =======================

class Pokemon {
  final int id;
  final String name;
  final int base_experience;
  final int height;
  final bool is_default;
  final int order;
  final int weight;

  final List<PokemonAbility> abilities;
  final List<NamedApiResource> forms;
  final List<VersionGameIndex> game_indices;
  final List<PokemonHeldItem> held_items;
  final String location_area_encounters;
  final List<PokemonMove> moves;
  final List<PokemonTypePast> past_types;
  final List<PokemonAbilityPast> past_abilities;
  final PokemonSprites sprites;
  final PokemonCries cries;
  final NamedApiResource species;
  final List<PokemonStat> stats;
  final List<PokemonType> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.base_experience,
    required this.height,
    required this.is_default,
    required this.order,
    required this.weight,
    required this.abilities,
    required this.forms,
    required this.game_indices,
    required this.held_items,
    required this.location_area_encounters,
    required this.moves,
    required this.past_types,
    required this.past_abilities,
    required this.sprites,
    required this.cries,
    required this.species,
    required this.stats,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      base_experience: (json['base_experience'] ?? 0) as int,
      height: json['height'] as int,
      is_default: json['is_default'] as bool,
      order: json['order'] as int,
      weight: json['weight'] as int,
      abilities: (json['abilities'] as List)
          .map((e) => PokemonAbility.fromJson(e))
          .toList(),
      forms: (json['forms'] as List)
          .map((e) => NamedApiResource.fromJson(e))
          .toList(),
      game_indices: (json['game_indices'] as List)
          .map((e) => VersionGameIndex.fromJson(e))
          .toList(),
      held_items: (json['held_items'] as List)
          .map((e) => PokemonHeldItem.fromJson(e))
          .toList(),
      location_area_encounters: json['location_area_encounters'] as String,
      moves: (json['moves'] as List)
          .map((e) => PokemonMove.fromJson(e))
          .toList(),
      past_types: (json['past_types'] as List)
          .map((e) => PokemonTypePast.fromJson(e))
          .toList(),
      past_abilities: (json['past_abilities'] as List)
          .map((e) => PokemonAbilityPast.fromJson(e))
          .toList(),
      sprites: PokemonSprites.fromJson(json['sprites']),
      cries: PokemonCries.fromJson(json['cries']),
      species: NamedApiResource.fromJson(json['species']),
      stats: (json['stats'] as List)
          .map((e) => PokemonStat.fromJson(e))
          .toList(),
      types: (json['types'] as List)
          .map((e) => PokemonType.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'base_experience': base_experience,
      'height': height,
      'is_default': is_default,
      'order': order,
      'weight': weight,
      'abilities': abilities.map((e) => e.toJson()).toList(),
      'forms': forms.map((e) => e.toJson()).toList(),
      'game_indices': game_indices.map((e) => e.toJson()).toList(),
      'held_items': held_items.map((e) => e.toJson()).toList(),
      'location_area_encounters': location_area_encounters,
      'moves': moves.map((e) => e.toJson()).toList(),
      'past_types': past_types.map((e) => e.toJson()).toList(),
      'past_abilities': past_abilities.map((e) => e.toJson()).toList(),
      'sprites': sprites.toJson(),
      'cries': cries.toJson(),
      'species': species.toJson(),
      'stats': stats.map((e) => e.toJson()).toList(),
      'types': types.map((e) => e.toJson()).toList(),
    };
  }
}

class PokemonAbility {
  final NamedApiResource? ability;
  final bool is_hidden;
  final int slot;

  PokemonAbility({
    required this.ability,
    required this.is_hidden,
    required this.slot,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    final abilityJson = json['ability'];

    return PokemonAbility(
      ability: abilityJson == null
        ? null
        : NamedApiResource.fromJson(abilityJson as Map<String, dynamic>),
      is_hidden: json['is_hidden'] as bool,
      slot: json['slot'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'is_hidden': is_hidden,
    'slot': slot,
    'ability': ability!.toJson(),
  };
}

class PokemonType {
  final int slot;
  final NamedApiResource type;

  PokemonType({required this.slot, required this.type});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      slot: json['slot'] as int,
      type: NamedApiResource.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {'slot': slot, 'type': type.toJson()};
}

class PokemonFormType {
  final int slot;
  final NamedApiResource type;

  PokemonFormType({required this.slot, required this.type});

  factory PokemonFormType.fromJson(Map<String, dynamic> json) {
    return PokemonFormType(
      slot: json['slot'] as int,
      type: NamedApiResource.fromJson(json['type']),
    );
  }

  Map<String, dynamic> toJson() => {'slot': slot, 'type': type.toJson()};
}

class PokemonTypePast {
  /// In the PokéAPI this is actually an object:
  /// { generation: NamedApiResource, types: [...] }
  final NamedApiResource generation;
  final List<PokemonFormType> types;

  PokemonTypePast({required this.generation, required this.types});

  factory PokemonTypePast.fromJson(Map<String, dynamic> json) {
    return PokemonTypePast(
      generation: NamedApiResource.fromJson(json['generation']),
      types: (json['types'] as List)
          .map((e) => PokemonFormType.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'generation': generation.toJson(),
    'types': types.map((e) => e.toJson()).toList(),
  };
}

class PokemonAbilityPast {
  /// Same note as above: generation is a resource object.
  final NamedApiResource generation;
  final List<PokemonAbility> abilities;

  PokemonAbilityPast({required this.generation, required this.abilities});

  factory PokemonAbilityPast.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityPast(
      generation: NamedApiResource.fromJson(json['generation']),
      abilities: (json['abilities'] as List)
          .map((e) => PokemonAbility.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'generation': generation.toJson(),
    'abilities': abilities.map((e) => e.toJson()).toList(),
  };
}

class PokemonHeldItem {
  final NamedApiResource item;
  final List<PokemonHeldItemVersion> version_details;

  PokemonHeldItem({required this.item, required this.version_details});

  factory PokemonHeldItem.fromJson(Map<String, dynamic> json) {
    return PokemonHeldItem(
      item: NamedApiResource.fromJson(json['item']),
      version_details: (json['version_details'] as List)
          .map((e) => PokemonHeldItemVersion.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'item': item.toJson(),
    'version_details': version_details.map((e) => e.toJson()).toList(),
  };
}

class PokemonHeldItemVersion {
  final NamedApiResource version;
  final int rarity;

  PokemonHeldItemVersion({required this.version, required this.rarity});

  factory PokemonHeldItemVersion.fromJson(Map<String, dynamic> json) {
    return PokemonHeldItemVersion(
      version: NamedApiResource.fromJson(json['version']),
      rarity: json['rarity'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'version': version.toJson(),
    'rarity': rarity,
  };
}

class PokemonMove {
  final NamedApiResource move;
  final List<PokemonMoveVersion> version_group_details;

  PokemonMove({required this.move, required this.version_group_details});

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      move: NamedApiResource.fromJson(json['move']),
      version_group_details: (json['version_group_details'] as List)
          .map((e) => PokemonMoveVersion.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'move': move.toJson(),
    'version_group_details': version_group_details
        .map((e) => e.toJson())
        .toList(),
  };
}

class PokemonMoveVersion {
  final NamedApiResource move_learn_method;
  final NamedApiResource version_group;
  final int level_learned_at;

  /// Not all endpoints include an "order"; keep it nullable to be safe.
  final int? order;

  PokemonMoveVersion({
    required this.move_learn_method,
    required this.version_group,
    required this.level_learned_at,
    this.order,
  });

  factory PokemonMoveVersion.fromJson(Map<String, dynamic> json) {
    return PokemonMoveVersion(
      move_learn_method: NamedApiResource.fromJson(json['move_learn_method']),
      version_group: NamedApiResource.fromJson(json['version_group']),
      level_learned_at: (json['level_learned_at'] ?? 0) as int,
      order: json['order'] == null ? null : (json['order'] as int),
    );
  }

  Map<String, dynamic> toJson() => {
    'move_learn_method': move_learn_method.toJson(),
    'version_group': version_group.toJson(),
    'level_learned_at': level_learned_at,
    if (order != null) 'order': order,
  };
}

class PokemonStat {
  final int base_stat;
  final int effort;
  final NamedApiResource stat;

  PokemonStat({
    required this.base_stat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      base_stat: json['base_stat'] as int,
      effort: json['effort'] as int,
      stat: NamedApiResource.fromJson(json['stat']),
    );
  }

  Map<String, dynamic> toJson() => {
    'base_stat': base_stat,
    'effort': effort,
    'stat': stat.toJson(),
  };
}

class PokemonSprites {
  final String? front_default;
  final String? front_shiny;
  final String? front_female;
  final String? front_shiny_female;
  final String? back_default;
  final String? back_shiny;
  final String? back_female;
  final String? back_shiny_female;

  PokemonSprites({
    this.front_default,
    this.front_shiny,
    this.front_female,
    this.front_shiny_female,
    this.back_default,
    this.back_shiny,
    this.back_female,
    this.back_shiny_female,
  });

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      front_default: json['front_default'] as String?,
      front_shiny: json['front_shiny'] as String?,
      front_female: json['front_female'] as String?,
      front_shiny_female: json['front_shiny_female'] as String?,
      back_default: json['back_default'] as String?,
      back_shiny: json['back_shiny'] as String?,
      back_female: json['back_female'] as String?,
      back_shiny_female: json['back_shiny_female'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'front_default': front_default,
    'front_shiny': front_shiny,
    'front_female': front_female,
    'front_shiny_female': front_shiny_female,
    'back_default': back_default,
    'back_shiny': back_shiny,
    'back_female': back_female,
    'back_shiny_female': back_shiny_female,
  };
}

class PokemonCries {
  final String? latest;
  final String? legacy;

  PokemonCries({this.latest, this.legacy});

  factory PokemonCries.fromJson(Map<String, dynamic> json) {
    return PokemonCries(
      latest: json['latest'] as String?,
      legacy: json['legacy'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'latest': latest, 'legacy': legacy};
}

class VersionGameIndex {
  final int game_index;
  final NamedApiResource version;

  VersionGameIndex({required this.game_index, required this.version});

  factory VersionGameIndex.fromJson(Map<String, dynamic> json) {
    return VersionGameIndex(
      game_index: json['game_index'] as int,
      version: NamedApiResource.fromJson(json['version']),
    );
  }

  Map<String, dynamic> toJson() => {
    'game_index': game_index,
    'version': version.toJson(),
  };
}

class NamedApiResource {
  final String name;
  final String url;

  NamedApiResource({required this.name, required this.url});

  factory NamedApiResource.fromJson(Map<String, dynamic> json) {
    return NamedApiResource(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}

class PokemonListResult {
  String Name;
  String Url;

  PokemonListResult({required this.Name, required this.Url});
  factory PokemonListResult.fromJson(Map<String, dynamic> json) {
    return PokemonListResult(
      Name: json['name'] as String,
      Url: json['url'] as String,
    );
  }
  Map<String, dynamic> toJson() => {'name': Name, 'url': Url};
}
