import 'package:flutter/material.dart';
import 'package:movie_house4/models/webseries.dart';

class SeriesWidget extends StatelessWidget {
  final List<WebSeries> webSeries;

  SeriesWidget({this.webSeries});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (webSeries != null && webSeries.length > 0) {
      return GridView.builder(
          // scrollDirection: Axis.
          shrinkWrap: true,
          itemCount: webSeries.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 15.0,
            childAspectRatio: width / (height / 1.2),
          ),
          itemBuilder: (context, index) {
            // print(movies[index].posterPath);
            // print(movies);
            var series = webSeries[index];

            return Column(
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => Series(movie: movie),
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
                              'https://imgc.allpostersimages.com/img/print/u-g-F4S5Z90.jpg?w=900&h=900&p=0'),
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
                  series.title,
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
