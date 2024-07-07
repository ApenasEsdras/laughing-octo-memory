import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({super.key});

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
            .where('userId', isEqualTo: user.uid)
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
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['word']),
                  // Implemente outras funcionalidades conforme necessário
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
