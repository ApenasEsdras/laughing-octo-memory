import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchWordDetails(String word) async {
  print("Fetching details for word: $word");
  try {
    final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else if (response.statusCode == 404) {
      throw Exception('Palavra não encontrada.');
    } else {
      throw Exception('Erro ao carregar os detalhes da palavra: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching word details: $e');
    throw Exception('Erro ao carregar os detalhes da palavra: $e');
  }
}
