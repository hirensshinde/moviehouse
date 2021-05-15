import 'package:flutter/material.dart';
import 'package:movie_house4/models/moviex.dart';
import 'package:movie_house4/screens/movieDetail.dart';
// import 'package:movie_house4/models/movies.dart';

class MoviesWidget extends StatelessWidget {
  final List<Movie> movies;

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
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 15.0,
            childAspectRatio: width / (height / 1.2),
          ),
          itemBuilder: (context, index) {
            // print(movies[index].posterPath);
            // print(movies);
            var movie = movies[index];

            return Column(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetail(movie: movie),
                        ),
                      );
                    },
                    child: Container(
                      height: 120.0,
                      width: 90.0,
                      // margin: EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://api.moviehouse.download/admin/movie/image/' +
                                  movie.poster),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  movie.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
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
