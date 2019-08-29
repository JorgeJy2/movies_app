import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';
import 'package:movies/src/providers/peliculas_provider.dart';

class SearchMovie extends SearchDelegate {
  final PeliculasProvider _peliculaProvider = new PeliculasProvider();

  final peliculas = [
    'Data..',
    'Spiderman',
    'Batman',
    'Spiderman',
    'Batman',
    'Spiderman',
    'Batman',
    'Spiderman',
    'Batman',
    'Spiderman',
    'Batman'
  ];
  final peliculasRecientes = ['Spiderman', 'Batman'];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final listaSugerida = (query.isEmpty) ?
    //   peliculasRecientes : peliculas.where( (p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    // return ListView.builder(
    //   itemCount: listaSugerida.length,
    //   itemBuilder: (context, i ){
    //     return ListTile(
    //       leading: Icon(Icons.movie),
    //       title: Text(listaSugerida[i]),
    //       subtitle: Text('Reciente'),
    //       onTap: (){

    //       },
    //       );
    //   }, );
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: _peliculaProvider.searchMovie(query),
      builder: (BuildContext conttext, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView(
              children: peliculas.map((pelicula) {
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImgUrl()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(pelicula.title),
              subtitle: Text(pelicula.originalTitle),
              onTap: () {
                close(context, null);
                pelicula.uniqueId = '';
                Navigator.pushNamed(context, 'detalle', arguments: pelicula);
              },
            );
          }).toList());
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
