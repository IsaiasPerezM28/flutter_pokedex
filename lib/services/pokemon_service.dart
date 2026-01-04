import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons({int limit = 20}) async {
    final url = Uri.parse('$baseUrl/pokemon?limit=$limit');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Error al cargar Pokémon');
    }

    final data = json.decode(response.body);
    final List results = data['results'];

    final List<Future<Pokemon>> futures =
        results.map<Future<Pokemon>>((item) {
      return fetchPokemonDetail(item['url']);
    }).toList();

    return await Future.wait(futures);
  }

  Future<Pokemon> fetchPokemonDetail(String urlDetail) async {
    final response = await http.get(Uri.parse(urlDetail));
    final data = json.decode(response.body);
    return Pokemon.fromJson(data);
  }
}

