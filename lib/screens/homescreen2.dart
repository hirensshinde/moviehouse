import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/movies.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:moviehouse/screens/searchScreen.dart';
import 'package:moviehouse/widgets/resultWidget.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  final int id;

  HomeScreen({this.title, this.id});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _results;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  ScrollController controller = ScrollController();
  static int page = 1;

  @override
  void initState() {
    super.initState();
    _populateAllResults(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          isLoading = !isLoading;
          _populateAllResults(page);
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
    isLoading = false;
    final String apiUrl =
        "https://api.moviehouse.download/api/all/category/${widget.id}?page=$index";
    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      if (result["movie"].length > 0) {
        List movies = result["movie"];
        page++;
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else if (result["web_series"].length > 0) {
        List webSeries = result["web_series"];
        page++;

        return webSeries.map((series) => WebSeries.fromJson(series)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movies!");
    }
  }

  // Future<Null> refreshList() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   _populateAllResults(page);

  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
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
        // controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: EdgeInsets.only(bottom: 50.0),
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: (!isLoading)
                  ? ResultWidget(
                      results: _results, controller: _scrollController)
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
