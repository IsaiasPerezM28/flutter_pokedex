import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonDetailScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Hero(
            tag: 'pokemon_${pokemon.id}',
            child: Image.network(
              pokemon.imageUrl,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            pokemon.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Attack Power: ${pokemon.attack}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Este Pokémon es uno de los tantos disponibles en la Pokédex. '
              'Puedes usar su poder de ataque para enfrentarte a otros entrenadores.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
