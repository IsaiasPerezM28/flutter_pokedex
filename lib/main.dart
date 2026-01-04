import 'package:flutter/material.dart';
import 'models/pokemon.dart';
import 'services/pokemon_service.dart';
import 'screens/pokemon_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const PokemonListScreen(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokemonService _service = PokemonService();
  late Future<List<Pokemon>> _futurePokemons;

  @override
  void initState() {
    super.initState();
    _futurePokemons = _service.fetchPokemons(limit: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex')),
      body: FutureBuilder<List<Pokemon>>(
        future: _futurePokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay Pokémon'));
          }

          final pokemons = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: pokemons[index]);
            },
          );
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PokemonDetailScreen(pokemon: pokemon),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 8,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'pokemon_${pokemon.id}',
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/pokeball.png',
                    image: pokemon.imageUrl,
                    fit: BoxFit.contain,
                    // ⏱️ AQUÍ está el cambio importante
                    fadeInDuration: const Duration(milliseconds: 1500),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pokemon.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Attack: ${pokemon.attack}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
