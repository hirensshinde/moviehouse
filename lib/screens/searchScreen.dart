import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/genres.dart';
import 'package:http/http.dart' as http;
import 'package:movie_house4/models/movies.dart';
import 'package:movie_house4/models/webseries.dart';
import 'package:movie_house4/screens/genreScreen.dart';
import 'package:movie_house4/screens/homescreen.dart';
import 'package:movie_house4/screens/movieDetail.dart';
import 'package:movie_house4/widgets/resultWidget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Genre> _genres;
  List<dynamic> _searchResult;

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

  Future<void> _fetchSearchResult(query) async {
    final String apiUrl =
        "http://api.moviehouse.download/api/search?query=$query";
    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["data"];

      if (list.length > 0 && list[0]['type'] == 'movie') {
        List newList = list.map((movie) => Movie.fromJson(movie)).toList();
        try {
          setState(() {
            _searchResult = newList;
          });

          print(_searchResult);
        } on Exception catch (_) {
          print('Data Not arrived yet');
          throw Exception('Data not arrived yet');
        }
      } else {
        List newList =
            list.map((series) => WebSeries.fromJson(series)).toList();
        try {
          setState(() {
            _searchResult = newList;
          });

          print(_searchResult);
        } on Exception catch (_) {
          print('Data Not arrived yet');
          throw Exception('Data not arrived yet');
        }
        return _searchResult;
      }
    } else {
      throw Exception("Failed to load movie");
    }
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
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // toolbarHeight: 40.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/Back.svg'),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
        title: Container(
          // width: size.width * 0.8,
          // margin: EdgeInsets.only(left: 50.0, right: 10.0, top: 60.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Color.fromARGB(255, 25, 27, 45),
          ),
          child: TextField(
            controller: textController,
            onSubmitted: (String value) async {
              if (value.isNotEmpty) {
                _fetchSearchResult(value);
                // textController.clear();
              } else {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }
            },
            style: TextStyle(color: Colors.white24, fontSize: 18.0),
            decoration: InputDecoration(
              border: InputBorder.none,
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
            (_searchResult != null && _searchResult.length > 0)
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    child: ResultWidget(results: _searchResult),
                  )
                : (_genres != null && _genres.length > 0)
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
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
