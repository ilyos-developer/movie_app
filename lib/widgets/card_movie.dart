import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalog_films/bloc/home/home_bloc.dart';
import 'package:catalog_films/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CardMovie extends StatelessWidget {
  List<Result> movies;
  int index;
  List? favList;

  CardMovie({Key? key, required this.movies, required this.index, this.favList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final snackBar = SnackBar(
          dismissDirection: DismissDirection.horizontal,
          content: Text(movies[index].title),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://image.tmdb.org/t/p/w500/${movies[index].posterPath}",
                  errorWidget: (context, _, err) => Image.network(
                    "https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg",
                    height: 120,
                  ),
                  height: 150,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movies[index].title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        movies[index].overview,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 5),
                          Text(
                            movies[index].releaseDate == DateTime.now()
                                ? ""
                                : DateFormat("dd MMMM yyyy")
                                    .format(movies[index].releaseDate),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<HomeBloc>(context).add(
                                AddFavorite(movies[index].id),
                              );

                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              final snackBar = SnackBar(
                                dismissDirection: DismissDirection.horizontal,
                                content: favList!
                                        .contains(movies[index].id.toString())
                                    ? Text(
                                        "${movies[index].title} удалён из избранного")
                                    : Text(
                                        "${movies[index].title} добавлен в избранное"),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: favList!.contains(movies[index].id.toString())
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Colors.blue,
                                  ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
