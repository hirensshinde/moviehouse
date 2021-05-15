import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/categories.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:movie_house4/screens/homescreen.dart';
import 'package:movie_house4/screens/searchScreen.dart';
import 'package:movie_house4/widgets/sidebarWidget.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Category> _categories;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2));
    _populateAllCategories();
  }

  void _populateAllCategories() async {
    try {
      final categories = await _fetchAllCategories();

      setState(() {
        _categories = categories;
      });
    } on Exception catch (_) {
      print('Data Not arrived yet');
      // throw Exception('Data not arrived yet');
    }
  }

  //
  Future<List<Category>> _fetchAllCategories() async {
    // final String apiUrl =
    //     "https://api.themoviedb.org/3/movie/now_playing?api_key=a8d93a34b26202fd9917272a3535e340";
    final String apiUrl = "https://api.moviehouse.download/api/category";

    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["data"];
      // print(list);
      return list.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Failed to load genres!");
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _populateAllCategories();

    return null;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/aquaman.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(
              top: size.height * 0.45,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              color: Colors.black,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    // horizontal: 20.0,
                    top: 20.0,
                    bottom: 30.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    child: Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Search1.svg',
                              height: 20.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            Text('Global Search',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  // padding: EdgeInsets.all(8.0),
                  // color: Colors.blue,
                  child: _categories != null && _categories.length > 0
                      ? Expanded(
                          child: GridView.builder(
                            // scrollDirection: Axis.
                            shrinkWrap: true,
                            itemCount: _categories.length,
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              // mainAxisExtent: ,
                              mainAxisSpacing: 12.0,
                              crossAxisSpacing: 12.0,
                              childAspectRatio: size.width / (size.height / 5),
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  return Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            title:
                                                _categories[index].category)),
                                  );
                                },
                                child: Container(
                                  // height: 25.0,
                                  // width: 60.0,
                                  // margin: EdgeInsets.symmetric(horizontal:),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Color.fromARGB(255, 25, 27, 45),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _categories[index].category,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white70,
                                      ),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
