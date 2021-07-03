import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/banners.dart';
import 'package:moviehouse/models/categories.dart';
import 'package:http/http.dart' as http;
import 'package:moviehouse/models/homeCategories.dart';
import 'package:moviehouse/models/movies.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:moviehouse/screens/movieDetail.dart';
import 'package:moviehouse/screens/requestmovie.dart';
import 'package:moviehouse/screens/searchScreen.dart';
import 'package:moviehouse/screens/seriesDetail.dart';
import 'package:moviehouse/widgets/sidebarWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();
  int page = 1;
  var _results;
  bool isLoading = false;
  List _categories;
  int selectedIndex = 0;
  int selectedCategoryId;
  List _categoryBanners;
  int _current;
  List<HomeCategories> _homeCategories;

  @override
  void initState() {
    super.initState();
    // _results = null;
    // selectedCategoryId = 2;
    _populateAllCategories();
    // setState(() {});
    // getBanner();
  }

  Future<List<Category>> _fetchAllCategories() async {
    // final String apiUrl =
    //     "https://api.themoviedb.org/3/movie/now_playing?api_key=a8d93a34b26202fd9917272a3535e340";
    final String apiUrl = "https://api.moviehouse.download/api/category";

    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List list = result["data"];
      // print(_results);
      return list.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception("Failed to load genres!");
    }
  }

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
        return banners.map((banner) => Banners.fromJson(banner)).toList();
      }
    }
    return [];
  }

  Future<List> _homeScreenCategories() async {
    final String apiurl = "https://api.moviehouse.download/api/top-category";

    final response = await http.get(Uri.parse(apiurl));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      List data = result['data'];
      print('Printed Result ===>>> $data');
      return data.map((category) => HomeCategories.fromJson(category)).toList();
    }
    return null;
  }

  Future<List> getCategoryBanners(id) async {
    String url =
        'https://api.moviehouse.download/api/banners/home?category_id=$id';

    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var data = result['data'];

      // print("Received banners data from category API ==> $data");
      if (data.length > 0) {
        List modelList = await data
            .map((banner) => (banner['type'] == 'movie')
                ? Movie.fromJson(banner)
                : WebSeries.fromJson(banner))
            .toList();
        // print("Received Model list ==> $modelList");
        return modelList;
      }

      return null;
    }
    return null;
  }

  Future<List> _fetchAllResults(int id) async {
    isLoading = false;
    final String apiUrl =
        "https://api.moviehouse.download/api/all/category/$id?page=$page";
    var url = Uri.parse(apiUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // totalPages = result.total;
      if (result["movie"].length > 0 ?? []) {
        List movies = result["movie"];
        page++;
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else if (result["web_series"].length > 0) {
        List webSeries = result["web_series"];
        page++;

        return webSeries.map((series) => WebSeries.fromJson(series)).toList();
      }
    } else {
      throw Exception("Failed to load movies!");
    }
    return null;
  }

  void _populateAllCategories() async {
    try {
      final List<Category> categories = await _fetchAllCategories();
      // final banners = await getBanner();
      final homeCategories = await _homeScreenCategories();

      final newCategoryList = [Category(id: 1, category: 'All')];
      categories.forEach((category) => newCategoryList.add(category));

      setState(() {
        _categories = newCategoryList;
        // _banners = banners;
        _homeCategories = homeCategories;
      });
    } on Exception catch (_) {
      print('Data Not arrived yet');
      // throw Exception('Data not arrived yet');
    }
  }

  _populateCategoryListing(id) async {
    try {
      final results = await _fetchAllResults(id);
      if (_results == null) {
        setState(() {
          _results = results;
        });
      } else {
        setState(() {
          if (results != null) {
            _results.addAll(results);
          }
        });
        // print(_results);
      }
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  // Pagination on Scroll Movie Series Listing on Categories
  void _populateListings(int id) async {
    print('==>Called First time');
    _populateCategoryListing(id);
    // _categoryBanners = await getCategoryBanners(id);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // if (!isLoading) {
        //   isLoading = !isLoading;
        // // }
        // setState(() {
        //   isBottomReached = true;
        // });
        _populateCategoryListing(id);
        print('==>Called Second time');
        // print(_results);
        print(page);
      }
    });
  }

  // Banners for All Category Function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 25, 27, 45),
        leading: Builder(
          builder: (context) => IconButton(
              splashRadius: 30.0,
              padding: EdgeInsets.all(0.0),
              icon: SvgPicture.asset(
                'assets/icons/Drawer2.svg',
                height: 40.0,
              ),
              onPressed: () => Scaffold.of(context).openDrawer()),
        ),

        // fit: BoxFit.fitHeight,

        title: Text('Movie House',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: "NEXA",
            )),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: ElevatedButton(
                onPressed: () {
                  return Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RequestMovie()));
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  primary: Color.fromARGB(255, 235, 170, 73),
                ),
                child: Text(
                  'Request Movie',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "NEXA",
                  ),
                )),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(55.0),
          child: Container(
            color: Color.fromARGB(255, 25, 27, 45),
            width: double.infinity,
            height: 55.0,
            padding: EdgeInsets.only(bottom: 5.0),
            child: (_categories != null)
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            page = 1;
                            _results = [];
                            _categoryBanners = [];
                            setState(() {
                              selectedIndex = index;
                            });
                            if (selectedIndex == 0) {
                              _populateAllCategories();
                              // _scrollController.dispose();
                            } else {
                              _populateListings(_categories[index].id);
                              selectedCategoryId = _categories[index].id;
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: selectedIndex == index
                                  ? Colors.blue[800]
                                  : Colors.transparent,
                            ),
                            margin: EdgeInsets.only(
                                left: (index == 0) ? 10 : 0,
                                right:
                                    index == (_categories.length - 1) ? 10 : 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            height: 55.0,
                            // width: 90.0,
                            child: Center(
                              child: Text(
                                '${_categories[index].category}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "NEXA",
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Container(
                      child: Text(
                        'Loading Categories...',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "NEXA",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
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
      body: (_homeCategories != null)
          ? CustomScrollView(
              controller: _scrollController,
              slivers: [
                _bannerView(),
                (selectedIndex == 0)
                    ? _popularLatestCategory()
                    : _categoryGrid(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _bannerView() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      // snap: ,
      expandedHeight: 200.0,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .30,
              child: FutureBuilder(
                  future: selectedIndex == 0
                      ? getBanner()
                      : getCategoryBanners(selectedCategoryId),
                  initialData: [],
                  builder: (context, AsyncSnapshot snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: CircularProgressIndicator());
                      default:
                        return (snapshot.hasData)
                            ? CarouselSlider.builder(
                                itemCount: (snapshot.hasData == null)
                                    ? 0
                                    : snapshot.data.length,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height:
                                      MediaQuery.of(context).size.height * .35,
                                  viewportFraction: 1.0,
                                  disableCenter: true,
                                  autoPlayInterval: Duration(seconds: 10),
                                  autoPlayCurve: Curves.easeInOut,
                                  initialPage: 0,
                                  onPageChanged: (index, _) {
                                    _current = index;
                                  },
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  scrollDirection: Axis.horizontal,
                                ),
                                itemBuilder: (BuildContext context, int index,
                                        int pageItemIndex) =>
                                    CachedNetworkImage(
                                      imageUrl: (snapshot.hasData == null)
                                          ? 'https://via.placeholder.com/600x350.png?text=No+Preview+available'
                                          : 'https://api.moviehouse.download/admin/movie/image/' +
                                              snapshot.data[index].banner,
                                      imageBuilder: (context, imageProvider) =>
                                          GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      (snapshot.data[index]
                                                                  .type ==
                                                              'movie')
                                                          ? MovieDetail(
                                                              movie: snapshot
                                                                  .data[index])
                                                          : SeriesDetail(
                                                              series:
                                                                  snapshot.data[
                                                                      index])));
                                        },
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          margin: EdgeInsets.all(10.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                              image: imageProvider,

                                              fit: BoxFit.fill,

                                              // alignment: Alignment.topLeft,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // placeholder: (context, url) => Center(
                                      //     child: CircularProgressIndicator()),
                                    ))
                            : CarouselSlider.builder(
                                itemCount: 3,
                                options: CarouselOptions(
                                  autoPlay: true,
                                  height:
                                      MediaQuery.of(context).size.height * .35,
                                  viewportFraction: 1.0,
                                  disableCenter: true,
                                  autoPlayInterval: Duration(seconds: 10),
                                  autoPlayCurve: Curves.easeInOut,
                                  initialPage: 0,
                                  onPageChanged: (index, _) {
                                    _current = index;
                                  },
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  scrollDirection: Axis.horizontal,
                                ),
                                itemBuilder: (BuildContext context, int index,
                                        int pageItemIndex) =>
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https://via.placeholder.com/600x350.png?text=No+Preview+available',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .5,
                                        margin: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          image: DecorationImage(
                                            image: imageProvider,

                                            fit: BoxFit.fill,

                                            // alignment: Alignment.topLeft,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                    ));
                    }
                  }),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: (selectedCategoryId == 0 ) ? _categoryBanners.map(
            //     (image) {
            //       //these two lines
            //       int index = _categoryBanners.indexOf(image); //are changed
            //       return Container(
            //         width: 5.0,
            //         height: 5.0,
            //         margin:
            //             EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: _current == index
            //                 ? Color.fromRGBO(255, 255, 255, 0.9)
            //                 : Color.fromRGBO(255, 255, 255, 0.6)),
            //       );
            //     },
            //   ).toList(),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _popularLatestCategory() {
    return SliverToBoxAdapter(
      child: Column(
        children: _homeCategories.map((category) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    category.name,
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: "NEXA",
                        ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 150.0,
                  child: ListView.builder(
                    itemCount: category.contents.length,
                    // shrinkWrap: true,

                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      dynamic result = category.contents[index];
                      return GestureDetector(
                        onTap: () {
                          return Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return (category.contents[index].type == "movie")
                                  ? MovieDetail(movie: result)
                                  : SeriesDetail(series: result);
                            }),
                          );
                        },
                        child: CachedNetworkImage(
                          placeholderFadeInDuration:
                              Duration(milliseconds: 500),
                          imageUrl:
                              'https://api.moviehouse.download/admin/movie/image/' +
                                  result.poster,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 110.0,
                            // height: 130.0,
                            margin: EdgeInsets.only(
                                left: (index == 0) ? 10.0 : 8.0),
                            // padding: EdgeInsets.all(10.0),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,

                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fill),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 2.0,
                                  right: 0.0,
                                  child: (result.ratings != null)
                                      ? Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          color: Colors.yellow,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.star, size: 12.0),
                                              Text(
                                                result.ratings.toString(),
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                ),
                                              )
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0, vertical: 1.0),
                                        )
                                      : Container(),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    color: Colors.black87,
                                    child: Text(result.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontFamily: 'NEXA',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center),
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          placeholder: (context, url) => Container(
                            width: 110,
                            // height: 140,
                            margin: EdgeInsets.only(
                                left: (index == 0) ? 10.0 : 8.0),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/poster_placeholder.png'),
                                  fit: BoxFit.fill),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.33,
                                    color: Colors.black87,
                                    child: Text(result.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontFamily: 'NEXA',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center),
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 110,
                            // height: 140,
                            margin: EdgeInsets.only(
                                left: (index == 0) ? 10.0 : 8.0),
                            decoration: BoxDecoration(
                              // shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/nopreview.jpg'),
                                  fit: BoxFit.fill),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 2.0,
                                  right: 0.0,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 5.0),
                                    color: Colors.yellow,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.star, size: 13.0),
                                        Text(
                                          '7.8 ',
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            // fontFamily: 'NEXA',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    color: Colors.black87,
                                    child: Text(result.title,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontFamily: 'NEXA',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center),
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _categoryGrid() {
    var size = MediaQuery.of(context).size;

    if ((_results != null)) {
      return SliverGrid.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 5.0,
          // mainAxisExtent: 150.0,
          childAspectRatio: size.width / (size.height / 1.5),
          children: _results
              .map<Widget>(
                (result) => Container(
                  child: GestureDetector(
                    onTap: () {
                      return Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (result.type == 'movie')
                              ? MovieDetail(movie: result)
                              : SeriesDetail(series: result),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      placeholderFadeInDuration: Duration(milliseconds: 500),
                      imageUrl:
                          'https://api.moviehouse.download/admin/movie/image/' +
                              result.poster,
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 150,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.fill),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 2.0,
                              right: 0.0,
                              child: (result.ratings != null)
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10.0),
                                      color: Colors.yellow,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.star, size: 12.0),
                                          Text(
                                            result.ratings.toString(),
                                            style: TextStyle(
                                              fontSize: 10.0,
                                            ),
                                          )
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.0, vertical: 1.0),
                                    )
                                  : Container(),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                color: Colors.black87,
                                child: Text(result.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontFamily: 'NEXA',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                                padding: EdgeInsets.all(5.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 150,
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/poster_placeholder.png'),
                              fit: BoxFit.fill),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.33,
                                color: Colors.black87,
                                child: Text(result.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontFamily: 'NEXA',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                                padding: EdgeInsets.all(5.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 150,
                        decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: AssetImage('assets/images/nopreview.jpg'),
                              fit: BoxFit.fill),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 2.0,
                              right: 0.0,
                              child: Container(
                                margin: EdgeInsets.only(top: 10.0),
                                color: Colors.yellow,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, size: 14.0),
                                    Text(
                                      '7.8 ',
                                      style: TextStyle(
                                        fontSize: 10.0,
                                        fontFamily: 'NEXA',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Row(children: [
                                Container(
                                  // width: MediaQuery.of(context).size.width * 0.33,
                                  color: Colors.lightBlue,
                                  child: Text(result.title,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.center),
                                  padding: EdgeInsets.all(5.0),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList());
    } else {
      return SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()));
    }
  }
}
