import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'detalhes_service.dart';

class WordDetailScreen extends StatefulWidget {
  final String word;
  final bool fromHomePage;

  const WordDetailScreen(
      {Key? key, required this.word, required this.fromHomePage});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    flutterTts
        .setLanguage('en-US'); // Configura o idioma para português brasileiro
  }

  Future<void> _speak(String text) async {
    await flutterTts.setSpeechRate(
        1.0); // Define a taxa de fala (1.0 é a velocidade padrão)
    await flutterTts.setPitch(1.0); // Define o tom da voz (1.0 é o tom padrão)
    await flutterTts
        .speak(text); // Inicia a síntese de voz com o texto fornecido
  }

  Future<void> _addToFavorites(String word, context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && widget.fromHomePage) {
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
        title: Text(widget.word),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchWordDetails(widget.word),
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
                'Nenhum detalhe encontrado para "${widget.word}"',
                style: const TextStyle(fontSize: 18),
              ),
            );
          } else {
            final wordDetails = snapshot.data!;
            return ListView(
              children: [
             ListTile(
  title: const Text('Fonetica'),
  subtitle: Text(
    wordDetails['phonetics'] != null &&
            wordDetails['phonetics'].isNotEmpty
        ? wordDetails['phonetics'][0]['text'] ?? 'N/A'
        : 'N/A',
  ),
  trailing: IconButton(
    icon: const Icon(Icons.volume_up),
    onPressed: () {
      if (wordDetails['phonetics'] != null &&
          wordDetails['phonetics'].isNotEmpty) {
        _speak(wordDetails['phonetics'][0]['text'] ?? '');
      }
    },
  ),
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
                if (widget.fromHomePage)
                  ElevatedButton(
                    onPressed: () => _addToFavorites(widget.word, context),
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
