import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, int>> loadWordsFromJson() async {
  final String response = await rootBundle.loadString('lib/data/words_dictionary.json');
  final Map<String, int> words = json.decode(response).cast<String, int>();
  return words;
}
