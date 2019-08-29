import 'package:flutter/material.dart';
import 'package:movies/src/providers/peliculas_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();

    return Scaffold(
        appBar: AppBar(
          title: Text('Películas en cines'),
          backgroundColor: Colors.red,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchMovie());
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperTarjetas(), _footer(context)],
          ),
        ));
  }

  Widget _swiperTarjetas() {
    //   peliculasProvider.getInCinemas();
    //   return CardSwiper(movies: [1,2,3,4]);
    // }
    return FutureBuilder(
      future: peliculasProvider.getInCinemas(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData)
          return CardSwiper(movies: snapshot.data);
        else {
          return Container(
            height: 400,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
            child: Text(
              'Películas populares',
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  nextMovies: peliculasProvider.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )
        ],
      ),
    );
  }
}
