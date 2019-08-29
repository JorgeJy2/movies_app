import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> movies;

  CardSwiper({@required this.movies});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          final image = FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(movies[index].getPosterImgUrl()),
            fit: BoxFit.cover,
          );
          movies[index].uniqueId = '${movies[index].id}-tarjeta';
          return Hero(
            tag: movies[index].uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  child: image,
                  onTap: () => Navigator.pushNamed(context, 'detalle',
                      arguments: movies[index]),
                )),
          );
        },
        layout: SwiperLayout.STACK,
        itemCount: movies.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}
