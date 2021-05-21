import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_house4/models/webseries.dart';
import 'package:movie_house4/screens/NewDownloadScreen.dart';
// import 'package:movie_house4/screens/downloadsScreen.dart';
// import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

class SeriesDetail extends StatefulWidget {
  final WebSeries series;

  SeriesDetail({this.series});

  @override
  _SeriesDetailState createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  List<Season> _seasons;
  List<Part> _allEpisodes;
  List<Part> listEpisodes;

  @override
  initState() {
    super.initState();
    _populateAllResults();
  }

  _populateAllResults() async {
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

  Future _fetchAllSeasons() async {
    try {
      List seasonsList = widget.series.season;
      // print(seasonsList);
      return seasonsList
          .map((season) => Season.fromJson(season))
          .cast<Season>()
          .toList();
    } on Exception catch (_) {
      print('No Seasons');
    }
  }

  Future _fetchAllParts(episodes) async {
    final partList = episodes;
    print(partList);
    if (partList != null) {
      listEpisodes =
          partList.map((part) => Part.fromJson(part)).cast<Part>().toList();

      setState(() {
        _allEpisodes = listEpisodes;
      });
    } else {
      print('No Episodes');
    }
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
                        (_seasons != null)
                            ? Container(
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
                                          final parts = _seasons[index].parts;
                                          _fetchAllParts(parts);

                                          setState(() {
                                            selectedIndex = index;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            color: selectedIndex == index
                                                ? Colors.blue[800]
                                                : Color.fromARGB(
                                                    255, 25, 27, 45),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10.0),
                                          height: 55.0,
                                          width: 90.0,
                                          child: Center(
                                            child: Text(
                                              "Season " +
                                                  _seasons[index].seasonName,
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
                              )
                            : Center(
                                child: Text('No Seasons',
                                    style: TextStyle(color: Colors.white)),
                              ),
                        (_allEpisodes != null)
                            ? Expanded(
                                child: ListView.builder(
                                    itemCount: _allEpisodes.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        tileColor:
                                            Color.fromARGB(255, 25, 27, 45),
                                        title: Text(
                                          _allEpisodes[index].partName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                        trailing: IconButton(
                                            icon: SvgPicture.asset(
                                              'assets/icons/Download.svg',
                                              height: 25.0,
                                              width: 25.0,
                                            ),
                                            onPressed: () async {
                                              return Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlayScreen(
                                                              link: _allEpisodes[
                                                                      index]
                                                                  .downloadLink)));
                                            }),
                                      );
                                    }),
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text('No Episodes',
                                      style: TextStyle(color: Colors.white)),
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
