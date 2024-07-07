// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'detalhes_service.dart';

class WordDetailScreen extends StatelessWidget {
  final String word;
  final bool fromHomePage;

  const WordDetailScreen(
      {Key? key, required this.word, required this.fromHomePage});

  Future<void> _addToFavorites(String word, context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && fromHomePage) {
        // Verifica se veio da HomePage
        // Verifica se a palavra já está nos favoritos do usuário
        bool isAlreadyFavorite = await _checkIfFavoriteExists(word, user.uid);

        if (!isAlreadyFavorite) {
          await FirebaseFirestore.instance.collection('favoritos').add({
            'word': word,
            'userId': user.uid,
            'timestamp': DateTime.now(),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$word adicionado aos favoritos')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$word já está nos favoritos')),
          );
        }
      } else {
        throw Exception('Não é possível adicionar aos favoritos.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao adicionar aos favoritos')),
      );
      print('Erro ao adicionar aos favoritos: $e');
    }
  }

  Future<bool> _checkIfFavoriteExists(String word, String userId) async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('favoritos')
          .where('word', isEqualTo: word)
          .where('userId', isEqualTo: userId)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar se favorito já existe: $e');
      return true; // Retorna true para evitar adições erradas em caso de erro
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
                if (fromHomePage)
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
