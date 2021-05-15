import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/movies.dart';
import 'package:movie_house4/models/moviex.dart';
import 'package:movie_house4/models/webseries.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:movie_house4/screens/movieDetail.dart';
import 'package:movie_house4/screens/searchScreen.dart';
import 'package:movie_house4/widgets/moviesWidget.dart';
import 'package:movie_house4/widgets/seriesWidget.dart';
import 'package:movie_house4/widgets/sidebarWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  String title;
  int id;

  HomeScreen({this.title, this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _movies;
  List<WebSeries> _series;

  @override
  void initState() {
    super.initState();
    _populateAllResults();
  }

  void _populateAllResults() async {
    try {
      final movies = await _fetchAllMovies();
      final series = await _fetchAllSeries();

      if (this.mounted) {
        setState(() {
          _movies = movies;
          _series = series;
        });
      }
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  Future<List<WebSeries>> _fetchAllSeries() async {
    String api = "https://api.moviehouse.download/api/web-series";

    final response = await http.get(api);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result;
      return list.map((json) => WebSeries.fromJson(json)).toList();
    } else {
      throw Exception('Failed load Web-Series');
    }
  }

  //
  Future<List<Movie>> _fetchAllMovies() async {
    // final String apiUrl =
    //     "https://api.themoviedb.org/3/movie/now_playing?api_key=a8d93a34b26202fd9917272a3535e340";

    if (widget.id != null) {
      final String apiUrl =
          "https://api.moviehouse.download/api/all/category/${widget.id}";
      var url = Uri.parse(apiUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // List list = result["movie"];
        return result;
        // print(list);
        // return list.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load movies!");
      }
    } else {
      final String apiUrl = "https://api.moviehouse.download/api/movies";
      var url = Uri.parse(apiUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final List list = result["data"];
        // print(list);
        return list.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception("Failed to load movies!");
      }
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _populateAllResults();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/Back.svg',
            height: 40.0,
            width: 40.0,
          ),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/Download.svg',
                height: 25.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadsScreen(
                      movie: _movies[0],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: SvgPicture.asset(
          'assets/icons/Search.svg',
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: refreshList,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: Text(
                  'Movies',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                // height: MediaQuery.of(context).size.height,
                child: MoviesWidget(movies: _movies),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                child: Text(
                  'Series',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: SeriesWidget(webSeries: _series),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
