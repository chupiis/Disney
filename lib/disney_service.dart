import 'dart:convert';
import 'package:http/http.dart' as http;
import 'character.dart';

class DisneyService {
  static const String baseUrl = 'https://api.disneyapi.dev/character';

  Future<List<DisneyCharacter>> fetchCharacters() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List characters = data['data'];

      return characters
          .map((json) => DisneyCharacter.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}