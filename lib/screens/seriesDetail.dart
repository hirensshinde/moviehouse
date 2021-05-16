import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/webseries.dart';

class SeriesDetail extends StatefulWidget {
  final WebSeries series;

  SeriesDetail({this.series});

  @override
  _SeriesDetailState createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  List<Season> _seasons;

  void initState() {
    super.initState();
    _populateAllSeason();
  }

  _populateAllSeason() async {
    try {
      final seasons = await _fetchAllSeasons();

      if (this.mounted) {
        setState(() {
          _seasons = seasons;
        });
      }
    } on Exception catch (_) {
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
    }
  }

  Future<List<Season>> _fetchAllSeasons() async {
    List seasonsList = widget.series.season;
    print(seasonsList);
    return seasonsList
        .map((season) => Season.fromJson(season))
        .cast<Season>()
        .toList();
  }

  Future<List<Season>> _fetchAllParts() async {
    List seasonsList = widget.series.season;
    print(seasonsList);
    return seasonsList
        .map((season) => Season.fromJson(season))
        .cast<Season>()
        .toList();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.series != null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/Back.svg'),
            onPressed: () {
              return Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            // alignment: Alignment.bottomCenter,
            // fit: StackFit.expand,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Colors.transparent,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://imgc.allpostersimages.com/img/print/u-g-F4S5Z90.jpg?w=900&h=900&p=0',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  color: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 4, 6, 22),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 25.0),
                        Text(
                          widget.series.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "2016 Drama Action",
                          style: TextStyle(
                            color: Color.fromARGB(255, 151, 169, 170),
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          width: double.infinity,
                          height: 55.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _seasons.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: selectedIndex == index
                                          ? Colors.blue[800]
                                          : Color.fromARGB(255, 25, 27, 45),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    height: 55.0,
                                    width: 90.0,
                                    child: Center(
                                      child: Text(
                                        "Season " + _seasons[index].seasonName,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
