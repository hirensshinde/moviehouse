import 'package:flutter/material.dart';
import 'package:movie_house4/models/moviex.dart';
import 'package:movie_house4/screens/movieDetail.dart';
import 'package:movie_house4/screens/seriesDetail.dart';
// import 'package:movie_house4/models/movies.dart';

class ResultWidget extends StatelessWidget {
  final List results;

  ResultWidget({this.results});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (results != null && results.length > 0) {
      return Container(
        padding: EdgeInsets.all(10.0),
        child: GridView.builder(
            // scrollDirection: Axis.
            shrinkWrap: true,
            itemCount: results.length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: width / (height / 1.2),
            ),
            itemBuilder: (context, index) {
              // print(movies[index].posterPath);
              // print(movies);
              var result = results[index];

              return Column(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        return Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (result.poster != null)
                                ? MovieDetail(movie: result)
                                : SeriesDetail(series: result),
                          ),
                        );
                      },
                      child: Container(
                        height: 120.0,
                        width: 100.0,
                        // margin: EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: (result.poster != null)
                                ? NetworkImage(
                                    'https://api.moviehouse.download/admin/movie/image/' +
                                        result.poster)
                                : NetworkImage(
                                    "https://imgc.allpostersimages.com/img/print/u-g-F4S5Z90.jpg?w=900&h=900&p=0"),
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
                    result.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            }),
      );
    } else {
      return Center(
          child:
              Text("No Result Found", style: TextStyle(color: Colors.white)));
    }
  }
}