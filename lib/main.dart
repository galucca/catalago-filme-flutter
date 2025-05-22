import 'package:flutter/material.dart';
import 'movie_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Filmes',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieService _service = MovieService();
  late Future<List<Map<String, String>>> _filmes;

  @override
  void initState() {
    super.initState();
    _filmes = _service.getPopularMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmes Populares')),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _filmes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final filmes = snapshot.data!;
          return ListView.builder(
            itemCount: filmes.length,
            itemBuilder: (context, index) {
              final filme = filmes[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(
                    filme['imagem']!,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(filme['titulo']!),
                  subtitle: Text(
                    filme['descricao']!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalhesPage(filme: filme),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  final Map<String, String> filme;

  const DetalhesPage({super.key, required this.filme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(filme['titulo']!)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(filme['imagem']!),
            const SizedBox(height: 20),
            Text(
              filme['descricao']!,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
