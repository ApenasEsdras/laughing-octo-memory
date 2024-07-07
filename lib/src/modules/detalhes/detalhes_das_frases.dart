// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detalhes_service.dart';

class WordDetailScreen extends StatelessWidget {
  final String word;

  const WordDetailScreen({super.key, required this.word});
  Future<void> _addToFavorites(String word, BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('favoritos').add({
          'word': word,
          'userId': user.uid,
          'timestamp': DateTime.now(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$word adicionado aos favoritos')),
        );
      } else {
        throw Exception('Usuário não autenticado');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar aos favoritos')),
      );
      print('Erro ao adicionar aos favoritos: $e');
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            String errorMessage =
                'Erro ao carregar os detalhes. Tente outra palavra.';
            if (snapshot.error.toString().contains('Palavra não encontrada')) {
              errorMessage = 'Palavra não encontrada. Tente outra palavra.';
            } else if (snapshot.error
                .toString()
                .contains('Detalhes da palavra vazios')) {
              errorMessage = 'Detalhes da palavra não encontrados.';
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    errorMessage,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Tente outra palavra'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Nenhum detalhe encontrado para "$word"',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else {
            final wordDetails = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  title: const Text('Fonética'),
                  subtitle: Text(wordDetails['phonetics'] != null &&
                          wordDetails['phonetics'].isNotEmpty
                      ? wordDetails['phonetics'][0]['text'] ?? 'N/A'
                      : 'N/A'),
                ),
                ListTile(
                  title: const Text('Significado'),
                  subtitle: Text(wordDetails['meanings'] != null &&
                          wordDetails['meanings'].isNotEmpty
                      ? wordDetails['meanings'][0]['definitions'] != null &&
                              wordDetails['meanings'][0]['definitions']
                                  .isNotEmpty
                          ? wordDetails['meanings'][0]['definitions'][0]
                                  ['definition'] ??
                              'N/A'
                          : 'N/A'
                      : 'N/A'),
                ),
                ElevatedButton(
                  onPressed: () => _addToFavorites(word, context),
                  child: const Text('Adicionar aos Favoritos'),
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
