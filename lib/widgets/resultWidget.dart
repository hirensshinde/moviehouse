import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/screens/movieDetail.dart';
import 'package:moviehouse/screens/seriesDetail.dart';
// import 'package:movie_house4/models/movies.dart';

class ResultWidget extends StatelessWidget {
  final List results;
  final ScrollController controller;

  ResultWidget({this.results, this.controller});

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
            physics: ScrollPhysics(),
            controller: controller,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              childAspectRatio: width / (height / 1.5),
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
                            builder: (context) => (result.type == 'movie')
                                ? MovieDetail(movie: result)
                                : SeriesDetail(series: result),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://api.moviehouse.download/admin/movie/image/' +
                                result.poster,
                        imageBuilder: (context, imageProvider) => Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 150,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2.0,
                                right: 0.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  color: Colors.yellow,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 12.0),
                                      Text(
                                        (result.ratings == null)
                                            ? '7.8'
                                            : result.ratings.toString(),
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.0, vertical: 1.0),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  color: Colors.black87,
                                  child: Text(result.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.center),
                                  padding: EdgeInsets.all(5.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 150,
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/poster_placeholder.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: 150,
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/nopreview.jpg'),
                                fit: BoxFit.fill),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 2.0,
                                right: 0.0,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10.0),
                                  color: Colors.yellow,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, size: 14.0),
                                      Text(
                                        '7.8 ',
                                        style: TextStyle(
                                          fontSize: 10.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  color: Colors.black87,
                                  child: Text(result.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.center),
                                  padding: EdgeInsets.all(5.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
