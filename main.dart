import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:show_app_backend/providers/show_provider.dart'; // Chemin vers votre provider

void main() {
  runApp(
    MultiProvider( // Utilisez MultiProvider si vous avez plusieurs providers
      providers: [
        ChangeNotifierProvider(create: (context) => ShowProvider()),
        // Ajoutez d'autres providers ici si nécessaire
        // ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(), // Votre widget d'application principal
    ),
  );
}
// Pour rafraîchir
context.read<ShowProvider>().fetchShows();

// Pour accéder aux données
final shows = context.watch<ShowProvider>().shows;
static Future<Map<String, String>> _getHeaders() async {
  final token = await AuthService.getToken();
  return {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };
}

// Utilisation :
final response = await http.get(
  Uri.parse(url),
  headers: await _getHeaders(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        // Ajoutez d'autres routes ici
      },
    );
  }
}