import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_house4/models/webseries.dart';
import 'package:movie_house4/screens/NewDownloadScreen.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:movie_house4/screens/downloadsScreen.dart';
// import 'package:progress_indicators/progress_indicators.dart';
// import 'package:url_launcher/url_launcher.dart';

const int maxFailedLoadAttempts = 3;

class SeriesDetail extends StatefulWidget {
  final WebSeries series;

  SeriesDetail({this.series});

  @override
  _SeriesDetailState createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  RewardedAd rewardedAd;
  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd(index) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
        return Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PlayScreen(link: _allEpisodes[index].downloadLink)));
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  void _showInterstitialAdfromDownload(index) {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
        return _downloadLink(index);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }

  void _downloadLink(index) async {
    var url = _allEpisodes[index].downloadLink;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  List<Season> _seasons;
  List<Part> _allEpisodes;
  List<Part> listEpisodes;

  @override
  initState() {
    super.initState();
    _populateAllResults();
    _createInterstitialAd();
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
                      'https://api.moviehouse.download/admin/movie/image/' +
                          widget.series.poster,
                    ),
                    fit: BoxFit.fitHeight,
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
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.series.year.toString(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 151, 169, 170),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Row(
                              children: widget.series.genres
                                  .map((genre) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: Text(genre,
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ))
                                  .toList(),
                            ),
                          ],
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

                                          setState(() {
                                            selectedIndex = index;
                                            _fetchAllParts(parts);
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
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
                                        trailing: Wrap(
                                          children: [
                                            IconButton(
                                              icon: SvgPicture.asset(
                                                'assets/icons/Download.svg',
                                                height: 25.0,
                                              ),
                                              onPressed: () async {
                                                return _showInterstitialAdfromDownload(
                                                    index);
                                              },
                                            ),
                                          ],
                                        ),
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
