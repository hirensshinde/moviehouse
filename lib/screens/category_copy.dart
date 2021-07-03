import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_card/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/categories.dart';
import 'package:moviehouse/screens/homescreen2.dart';
import 'package:moviehouse/screens/searchScreen.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:moviehouse/models/banners.dart';
import 'package:http/http.dart' as http;

class CategoryCopyScreen extends StatefulWidget {
  @override
  _CategoryCopyScreenState createState() => _CategoryCopyScreenState();
}

class _CategoryCopyScreenState extends State<CategoryCopyScreen> {
  List<Category> _categories;
  List<Banners> _banners;

  // List posters = [
  //   'assets/images/image1.jpg',
  //   'assets/images/image2.jpg',
  //   'assets/images/image3.jpg',
  //   'assets/images/image4.jpg',
  // ];

  Future<List<Banners>> getBanner() async {
    final apikey = "45293422347apQ8ob9hR9ITXS6YikayOc5iA2";
    final url = Uri.parse(
        "https://api.moviehouse.download/api/banners?api_key=${apikey}");
    final response = await http.get(url);
    List banners;
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result.length > 0) {
        banners = result['data'];
      }
    }
    return banners.map((banner) => Banners.fromJson(banner)).toList();
  }

  @override
  void initState() {
    super.initState();
    _populateAllCategories();
    getBanner();
  }

  void _populateAllCategories() async {
    try {
      final categories = await _fetchAllCategories();
      final banners = await getBanner();

      setState(() {
        _categories = categories;
        _banners = banners;
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

  Widget _body() => Column(
        children: [
          (_banners != null)
              ? CarouselSlider.builder(
                  itemCount: _banners?.length ?? 0,
                  options: CarouselOptions(
                    autoPlay: true,
                    height: MediaQuery.of(context).size.height * .40,
                    viewportFraction: 1.0,
                    disableCenter: true,
                    autoPlayInterval: Duration(seconds: 10),
                    autoPlayCurve: Curves.easeInOut,
                    initialPage: 0,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int pageItemIndex) =>
                          CachedNetworkImage(
                    imageUrl:
                        'https://api.moviehouse.download/admin/movie/image/' +
                            _banners[index].banner,
                    imageBuilder: (context, imageProvider) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                          // alignment: Alignment.topLeft,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                  ),
                )
              : Container(
                  child: Center(child: CircularProgressIndicator()),
                  height: MediaQuery.of(context).size.height * .40),
          Container(height: MediaQuery.of(context).size.height * .60),
        ],
      );

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: ExpandableCardPage(
        page: _body(),
        expandableCard: ExpandableCard(
          hasHandle: false,
          backgroundColor: Colors.black,
          padding: EdgeInsets.only(top: 5, left: 20, right: 20),
          // maxHeight: MediaQuery.of(context).size.height - 100,

          minHeight: MediaQuery.of(context).size.height * 0.65,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
          hasRoundedCorners: true,
          hasShadow: true,
          children: <Widget>[
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
                      MaterialPageRoute(
                        builder: (context) => SearchScreen(),
                      ));
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
              // color: Colors.grey,
              child: (_categories != null && _categories.length > 0)
                  ? GridView.builder(
                      // scrollDirection: Axis.
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0.0),
                      itemCount: _categories.length,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 50,
                        crossAxisCount: 2,

                        // mainAxisExtent: ,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 12.0,
                        childAspectRatio: size.width / (size.height / 5),
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // print(_categories[index].id);
                            return Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                    title: _categories[index].category,
                                    id: _categories[index].id),
                              ),
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
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
