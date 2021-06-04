import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/movies.dart';
import 'package:movie_house4/models/webseries.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:movie_house4/screens/movieDetail.dart';
import 'package:movie_house4/screens/searchScreen.dart';
import 'package:movie_house4/widgets/resultWidget.dart';
import 'package:movie_house4/widgets/seriesWidget.dart';
import 'package:movie_house4/widgets/sidebarWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenreScreen extends StatefulWidget {
  final String title;
  final int id;

  GenreScreen({this.title, this.id});

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List _results;

  @override
  void initState() {
    super.initState();
    _populateAllResults();
  }

  void _populateAllResults() async {
    try {
      final results = await _fetchAllResults();

      if (this.mounted) {
        setState(() {
          _results = results;
        });
      }
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  //
  Future<List> _fetchAllResults() async {
    // final String apiUrl =
    //     "https://api.themoviedb.org/3/movie/now_playing?api_key=a8d93a34b26202fd9917272a3535e340";

    final String apiUrl =
        "https://api.moviehouse.download/api/all/genre/${widget.id}";
    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result["movie"].length > 0) {
        List movies = result["movie"];
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else if (result["web_series"].length > 0) {
        List webSeries = result["web_series"];
        return webSeries.map((series) => WebSeries.fromJson(series)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movies!");
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
              Container(
                padding: EdgeInsets.only(top: 20.0),
                width: double.infinity,
                // height: MediaQuery.of(context).size.height,
                child: ResultWidget(results: _results),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
