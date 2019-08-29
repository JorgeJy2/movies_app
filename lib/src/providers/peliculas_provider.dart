import 'package:movies/src/models/actors_model.dart';
import 'package:movies/src/models/pelicula_model.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class PeliculasProvider {
  final _API_KEY = '92ff0c88ca89e47716552f4d625135dc';
  final _LANGUAGE = 'es-ES';
  final _UR = 'api.themoviedb.org';

  int _popularesPage = 0;

  bool _loadingPopular = false;

  List<Pelicula> _populares = new List();

  final _popularesStremController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStremController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStremController.stream;

  void disponseStream() {
    _popularesStremController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Peliculas.fromJsonList(decodedData['results']);
    return movies.movies;
  }

  Future<List<Pelicula>> getInCinemas() async {
    final url = Uri.https(_UR, '3/movie/now_playing',
        {'api_key': _API_KEY, 'language': _LANGUAGE});

    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    _popularesPage++;
    if (_loadingPopular) return [];

    _loadingPopular = true;

    print('Catgando siguientes....');

    final url = Uri.https(_UR, '3/movie/popular', {
      'api_key': _API_KEY,
      'language': _LANGUAGE,
      'page': _popularesPage.toString()
    });
    final response = await _procesarRespuesta(url);
    _populares.addAll(response);
    popularesSink(_populares);
    _loadingPopular = false;
    return response;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_UR, '3/movie/$peliId/credits',
        {'api_key': _API_KEY, 'language': _LANGUAGE});
    final resp = await http.get(url);

    final decodedData = json.decode(resp.body);

    final cast = Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> searchMovie(String query) async {
    final url = Uri.https(_UR, '3/search/movie',
        {'api_key': _API_KEY, 'language': _LANGUAGE, 'query': query});

    return await _procesarRespuesta(url);
  }
}
