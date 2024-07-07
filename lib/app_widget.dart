import 'package:flutter/material.dart';
import 'src/core/controllers/pages_controlles.dart';
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
        '/main': (context) => const MainScreen(), 
      },
    );
  }
}
