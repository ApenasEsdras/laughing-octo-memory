import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WordDetailScreen extends StatelessWidget {
  final String word;

  const WordDetailScreen({Key? key, required this.word}) : super(key: key);

  Future<Map<String, dynamic>?> fetchWordDetails(String word) async {
    print("Fetching details for word: $word");
    try {
      final response = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data[0];
        } else {
          throw Exception('Detalhes da palavra vazios.');
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchWordDetails(word),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            String errorMessage = 'Erro ao carregar os detalhes. Tente outra palavra.';
            if (snapshot.error.toString().contains('Palavra não encontrada')) {
              errorMessage = 'Palavra não encontrada. Tente outra palavra.';
            } else if (snapshot.error.toString().contains('Detalhes da palavra vazios')) {
              errorMessage = 'Detalhes da palavra não encontrados.';
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Tente outra palavra'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Nenhum detalhe encontrado para "$word"',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            final wordDetails = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: Text('Fonética'),
                  subtitle: Text(wordDetails['phonetics'] != null && wordDetails['phonetics'].isNotEmpty
                      ? wordDetails['phonetics'][0]['text'] ?? 'N/A'
                      : 'N/A'),
                ),
                ListTile(
                  title: Text('Significado'),
                  subtitle: Text(wordDetails['meanings'] != null && wordDetails['meanings'].isNotEmpty
                      ? wordDetails['meanings'][0]['definitions'] != null && wordDetails['meanings'][0]['definitions'].isNotEmpty
                          ? wordDetails['meanings'][0]['definitions'][0]['definition'] ?? 'N/A'
                          : 'N/A'
                      : 'N/A'),
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
