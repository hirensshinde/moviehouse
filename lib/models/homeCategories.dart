import 'package:moviehouse/models/movies.dart';
import 'package:moviehouse/models/webseries.dart';

class HomeCategories {
  int id;
  String name;
  // List<Movie> movie;
  // List<WebSeries> webseries;
  List<dynamic> contents;

  HomeCategories({
    this.id,
    this.name,
    this.contents,
    // this.movie,
    // this.webseries,
  });

  factory HomeCategories.fromJson(Map<String, dynamic> json) {
    List movies = List<Movie>.from(json["movie"].map((x) => Movie.fromJson(x)));
    List webseries = List<WebSeries>.from(
        json["web_series"].map((x) => WebSeries.fromJson(x)));

    List contents = [...movies, ...webseries];

    return HomeCategories(
      id: json['id'],
      name: json['name'],
      contents: contents,
      // movie: List<Movie>.from(json["movie"].map((x) => Movie.fromJson(x))),
      // webseries: List<WebSeries>.from(
      //     json["web_series"].map((x) => WebSeries.fromJson(x))),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name,
  //       "movie": List<dynamic>.from(movie.map((x) => x.toJson())),
  //       "web_series": List<dynamic>.from(webseries.map((x) => x.toJson())),
  //     };
}
