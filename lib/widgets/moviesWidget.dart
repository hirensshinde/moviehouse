import 'package:flutter/material.dart';
import 'package:movie_house4/models/movies.dart';

class MoviesWidget extends StatelessWidget {
  final List<Result> movies;

  MoviesWidget({this.movies});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (movies != null && movies.length > 0) {
      return GridView.builder(
          // scrollDirection: Axis.
          shrinkWrap: true,
          itemCount: movies.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: width / (height),
          ),
          itemBuilder: (context, index) {
            // print(movies[index].posterPath);
            // print(movies);
            var movie = movies[index];

            return Column(
              children: [
                Container(
                  height: 100.0,
                  width: 80.0,
                  // margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://image.tmdb.org/t/p/w300/' +
                          movie.posterPath),
                      fit: BoxFit.fitHeight,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                )
              ],
            );
          });
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
