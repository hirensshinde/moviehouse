import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviehouse/screens/movieDetail.dart';
import 'package:moviehouse/screens/seriesDetail.dart';
// import 'package:movie_house4/models/movies.dart';

class ResultWidget extends StatelessWidget {
  final List results;
  final ScrollController controller;

  // String imagePath = "https://ik.imagekit.io/vwvj9cugtq1/";
  final String imagePath = "https://d1wj9w86uhhpjg.cloudfront.net/";

  ResultWidget({this.results, this.controller});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return (results == null)
        ? Container(
            child: Center(child: CircularProgressIndicator()),
            height: MediaQuery.of(context).size.height,
          )
        : (results.length > 0)
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: GridView.builder(
                    // scrollDirection: Axis.
                    scrollDirection: Axis.vertical,
                    // addSemanticIndexes: true,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 100.0),
                    itemCount: results.length,
                    // physics: NeverScrollableScrollPhysics(),
                    controller: controller,
                    // cacheExtent: 20.0,
                    // addRepaintBoundaries: ,
                    // addAutomaticKeepAlives: true,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 5.0,
                      mainAxisExtent: 150.0,
                      childAspectRatio: size.width / (size.height / 1.5),
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
                                    builder: (context) =>
                                        (result.type == 'movie')
                                            ? MovieDetail(movie: result)
                                            : SeriesDetail(series: result),
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                placeholderFadeInDuration:
                                    Duration(milliseconds: 500),
                                imageUrl: imagePath + result.smallPoster,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
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
                                        child: (result.ratings != null)
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 10.0),
                                                color: Colors.yellow,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.star,
                                                        size: 12.0),
                                                    Text(
                                                      result.ratings.toString(),
                                                      style: TextStyle(
                                                        fontSize: 10.0,
                                                        fontFamily: "NEXA",
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.0,
                                                    vertical: 1.0),
                                              )
                                            : Container(),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          color: Colors.black87,
                                          child: Text(result.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontFamily: "NEXA",
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center),
                                          padding: EdgeInsets.all(5.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 150,
                                  alignment: Alignment.topRight,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color.fromRGBO(74, 74, 74, 1),
                                    // image: DecorationImage(
                                    //     image: AssetImage(
                                    //         'assets/images/poster_placeholder.png'),
                                    //     fit: BoxFit.fill),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
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
                                errorWidget: (context, url, error) => Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    // shape: BoxShape.circle,
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/nopreview.jpg'),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
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
              )
            : Center(
                child: Text(
                  "No Result Found",
                  style: TextStyle(color: Colors.white),
                ),
              );
  }
}
