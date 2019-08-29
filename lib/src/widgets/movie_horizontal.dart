import 'package:flutter/material.dart';
import 'package:movies/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function nextMovies;

  MovieHorizontal({@required this.peliculas, @required this.nextMovies});

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextMovies();
      }
    });

    return Container(
        height: _screenSize.height * 0.2,
        child: PageView.builder(
            pageSnapping: false,
            controller: _pageController,
            itemCount: peliculas.length,
            itemBuilder: (context, i) => builCard(context, peliculas[i])
            //children: _tarjetas(context),
            ));
  }

  Widget builCard(BuildContext context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-popular';
    final cardMovie = Container(
      child: Column(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImgUrl()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
          ),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: pelicula),
      child: cardMovie,
    );
  }

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImgUrl()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 140.0,
              ),
            ),
            Text(
              pelicula.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }
}
