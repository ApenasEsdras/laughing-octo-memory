import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordDetailScreen extends StatelessWidget {
  final String word;

  const WordDetailScreen({super.key, required this.word});

  Future<Map<String, dynamic>> fetchWordDetails() async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load word details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchWordDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final wordDetails = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: const Text('Phonetics'),
                  subtitle: Text(wordDetails['phonetics'][0]['text'] ?? 'N/A'),
                ),
                ListTile(
                  title: const Text('Meaning'),
                  subtitle: Text(wordDetails['meanings'][0]['definitions'][0]['definition'] ?? 'N/A'),
                ),
                // Adicionar mais detalhes conforme necessário
              ],
            );
          }
        },
      ),
    );
  }
}
