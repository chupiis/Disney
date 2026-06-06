import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_ce/hive.dart';
import 'character.dart';

class DisneyService {
  static const String baseUrl =
      'https://api.disneyapi.dev/character';

  final Box cacheBox = Hive.box('characters');

  Future<List<DisneyCharacter>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        await cacheBox.put(
          'characters',
          jsonEncode(data['data']),
        );

        return (data['data'] as List)
            .map((e) => DisneyCharacter.fromJson(e))
            .toList();
      }

      throw Exception();
    } catch (e) {
      final cached = cacheBox.get('characters');

      if (cached != null) {
        final List decoded = jsonDecode(cached);

        return decoded
            .map((e) => DisneyCharacter.fromJson(e))
            .toList();
      }

      rethrow;
    }
  }

  Future<DisneyCharacter> fetchCharacterDetails(int id) async {
    final response =
    await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return DisneyCharacter.fromJson(data);
    }

    throw Exception('Failed to load character details');
  }
}