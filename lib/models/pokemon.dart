class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final int attack;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.attack,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as List<dynamic>;
    final attackStat = stats.firstWhere(
      (s) => s['stat']['name'] == 'attack',
      orElse: () => {'base_stat': 0},
    )['base_stat'] as int;

    final sprites = json['sprites'];
    final image = sprites['other']?['official-artwork']?['front_default']
        ?? sprites['front_default'];

    return Pokemon(
      id: json['id'],
      name: json['name'].toUpperCase(),
      imageUrl: image ?? '',
      attack: attackStat,
    );
  }
}
