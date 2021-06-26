import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/genres.dart';
import 'package:http/http.dart' as http;
import 'package:moviehouse/models/movies.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:moviehouse/screens/genreScreen.dart';
import 'package:moviehouse/widgets/resultWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  // ScrollController _scrollController = ScrollController();
  // static int page = 1;
  List _results;
  List searchResult;

  List<Genre> _genres;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateAllGenres();
  }

  void _populateAllGenres() async {
    try {
      final genres = await _fetchAllGenres();

      setState(() {
        _genres = genres;
      });
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  //
  Future<List<Genre>> _fetchAllGenres() async {
    // final String apiUrl =
    final String apiUrl = "https://api.moviehouse.download/api/genre";

    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["data"];
      // print(list);
      return list.map((genre) => Genre.fromJson(genre)).toList();
    } else {
      throw Exception("Failed to load genres!");
    }
  }

  Future<List> _fetchSearchResult(query) async {
    final String apiUrl =
        "https://api.moviehouse.download/api/search?query=$query";
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
        return List.from(moviesResult)..addAll(seriesResult);
      } else if (result['movie'].length > 0) {
        final data = result['movie'];
        return data.map((series) => Movie.fromJson(series)).toList();
      } else if (result['web_series'].length > 0) {
        final data = result['web_series'];
        return data.map((series) => WebSeries.fromJson(series)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load movie");
    }
  }

  Future pagination(String query) async {
    final results = await _fetchSearchResult(query);
    setState(() {
      _results = results;
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _populateAllGenres();

    return null;
  }

  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // toolbarHeight: 40.0,

        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          splashRadius: 25.0,
          icon: SvgPicture.asset('assets/icons/Back.svg'),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
        title: Container(
          // width: size.width * 0.8,
          // margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Color.fromARGB(255, 25, 27, 45),
          ),
          child: TextField(
            controller: textController,
            onChanged: (String value) {
              if (value.isEmpty) {}
            },
            onSubmitted: (String value) async {
              if (value.isNotEmpty) {
                await pagination(value);
                _isSearching = true;
                // textController.clear();
              } else {
                setState(() {
                  _results.clear();
                  _isSearching = false;
                });
              }
            },
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  height: 5.0,
                  width: 5.0,
                  child: SvgPicture.asset(
                    'assets/icons/Search1.svg',
                    color: Colors.white24,
                    height: 5.0,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              prefixStyle: TextStyle(color: Colors.red),
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white24),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            (_isSearching || _results != null)
                ? (_results.isNotEmpty)
                    ? Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: ResultWidget(results: _results),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(
                          child: Text('No search result found',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                : (_isSearching || _genres != null && _genres.length > 0)
                    ? Container(
                        // margin: EdgeInsets.only(top: 50.0),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        child: GridView.builder(
                          // scrollDirection: Axis.
                          shrinkWrap: true,
                          itemCount: _genres.length,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                            childAspectRatio: size.width / (size.height / 4),
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                // print(_categories[index].id);
                                return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenreScreen(
                                        title: _genres[index].genre,
                                        id: _genres[index].id),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Color.fromARGB(255, 25, 27, 45),
                                ),
                                child: Center(
                                  child: Text(
                                    _genres[index].genre,
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ))
                    : Container(
                        height: size.height,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
