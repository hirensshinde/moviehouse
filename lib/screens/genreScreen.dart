import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/movies.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:moviehouse/screens/searchScreen.dart';
import 'package:moviehouse/widgets/resultWidget.dart';

class GenreScreen extends StatefulWidget {
  final String title;
  final int id;

  GenreScreen({this.title, this.id});

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List _results;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  ScrollController _genreController = ScrollController();
  static int page = 1;

  @override
  void initState() {
    super.initState();
    _populateAllResults(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("====>> >>>>> >>>>> >>>");
        _populateAllResults(page);
        if (!isLoading) {
          isLoading = !isLoading;
          print('Reached to end of the screen');
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _results.clear();
    page = 1;

    super.dispose();
  }

  void _populateAllResults(page) async {
    try {
      final results = await _fetchAllResults(page);
      print(results.length);

      if (_results == null) {
        setState(() {
          _results = results;
        });
      } else {
        setState(() {
          _results.addAll(results);
        });
      }
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  //
  Future<List> _fetchAllResults(int index) async {
    // final String apiUrl =
    //     "https://api.themoviedb.org/3/movie/now_playing?api_key=a8d93a34b26202fd9917272a3535e340";
    isLoading = false;
    final String apiUrl =
        "https://api.moviehouse.download/api/all/genre/${widget.id}?page=$index";
    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result['movie'].length > 0 && result['web_series'].length > 0) {
        final movies = result['movie'];
        final webseries = result['web_series'];
        List moviesResult =
            movies.map((movie) => Movie.fromJson(movie)).toList();
        List seriesResult =
            webseries.map((series) => WebSeries.fromJson(series)).toList();
        page++;
        return List.from(moviesResult)..addAll(seriesResult);
      } else if (result['movie'].length > 0) {
        final data = result['movie'];
        page++;
        return data.map((series) => Movie.fromJson(series)).toList();
      } else if (result['web_series'].length > 0) {
        final data = result['web_series'];
        page++;
        return data.map((series) => WebSeries.fromJson(series)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movies!");
    }
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
          splashRadius: 25.0,
          icon: SvgPicture.asset(
            'assets/icons/Back.svg',
            height: 40.0,
            width: 40.0,
          ),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: "NEXA", fontWeight: FontWeight.bold),
        ),
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
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(top: 10.0),
                width: double.infinity,
                // height: MediaQuery.of(context).size.height,
                child: ResultWidget(
                  results: _results,
                  controller: _genreController,
                )),
          ],
        ),
      ),
    );
  }
}
