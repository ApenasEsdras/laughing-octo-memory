import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../detalhes/detalhes_das_frases.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({Key? key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Faça login para ver seus favoritos'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favoritos')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar favoritos: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Nenhum favorito encontrado'),
            );
          } else {
            // Ordenar os documentos alfabeticamente pelo campo 'word'
            List<DocumentSnapshot> sortedDocs = snapshot.data!.docs;
            sortedDocs.sort((a, b) {
              Map<String, dynamic> dataA = a.data() as Map<String, dynamic>;
              Map<String, dynamic> dataB = b.data() as Map<String, dynamic>;
              return (dataA['word'] as String)
                  .compareTo(dataB['word'] as String);
            });

            return ListView(
              children: sortedDocs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WordDetailScreen(word: data['word'],fromHomePage: false,),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(data['word'] as String),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
