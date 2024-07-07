import 'package:flutter/material.dart';

import 'src/modules/detalhes/detalhes_das_frases.dart';
import 'src/modules/favoritos/favoritos_page.dart';
import 'src/modules/home/home_page.dart';
import 'src/modules/login/login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seu Aplicativo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomePage(),
        '/favorites': (context) => const FavoritosPage(),
        '/detail': (context) => const WordDetailScreen(word: '',),
      },
    );
  }
}
