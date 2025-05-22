import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  static const String _apiKey = '3d73b6a82ff3bf818acbf21c080c1e30';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  Future<List<Map<String, String>>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List movies = data['results'];

      return movies.map<Map<String, String>>((movie) {
        return {
          'titulo': movie['title'],
          'descricao': movie['overview'],
          'imagem': '$_imageBaseUrl${movie['poster_path']}',
        };
      }).toList();
    } else {
      throw Exception('Falha ao carregar filmes');
    }
  }
}
