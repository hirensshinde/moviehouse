import 'dart:async';
import 'dart:convert';

import 'package:expandable_card/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:http/http.dart' as http;

const int maxFailedLoadAttempts = 3;

class SeriesDetail extends StatefulWidget {
  final WebSeries series;
  final String apiKey;

  SeriesDetail({this.series, this.apiKey});

  @override
  _SeriesDetailState createState() => _SeriesDetailState();
}

class _SeriesDetailState extends State<SeriesDetail> {
  // RewardedAd rewardedAd;
  // InterstitialAd _interstitialAd;
  // int _numInterstitialLoadAttempts = 5;

  List<Season> _seasons;
  List<Part> _allEpisodes;

  final zones = [
    'vzfcb0fc4cffec44f78d',
  ];

  int selectedEpisode;
  bool buttonClicked = false;
  Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            buttonClicked = false;
            _start = 5;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) _timer.cancel();
  }

  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: "ca-app-pub-1527057564066862/9641981646",
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           print('$ad loaded');
  //           _interstitialAd = ad;
  //           _numInterstitialLoadAttempts = 3;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('InterstitialAd failed to load: $error.');
  //           _numInterstitialLoadAttempts += 1;
  //           _interstitialAd = null;
  //           if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
  //             _createInterstitialAd();
  //           }
  //         },
  //       ));
  // }

  // void _showInterstitialAdfromDownload(index) {
  //   if (_interstitialAd == null) {
  //     print('Warning: attempt to show interstitial before loaded.');
  //     return;
  //   }
  //   _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad) =>
  //         print('ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       ad.dispose();
  //       _createInterstitialAd();
  //       return _downloadLink(index);
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   _interstitialAd.show();
  //   _interstitialAd = null;
  // }

  Future<void> _downloadLink(index) async {
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
    // print(partList);
    if (partList != null) {
      List<Part> listEpisodes =
          partList.map((part) => Part.fromJson(part)).cast<Part>().toList();

      setState(() {
        _allEpisodes = listEpisodes;
      });
    } else {
      print('No Episodes');
    }
  }

  _populateAllResults() async {
    try {
      final seasons = await _fetchAllSeasons();
      if (seasons.length > 0 && seasons[0].parts.length > 0) {
        setState(() {
          _seasons = seasons;
          _fetchAllParts(_seasons[0].parts);
        });
      }
    } on Exception catch (_) {
      print('Waiting Time');
      throw Exception('Data not arrived yet');
    }
  }

  Future _downloadCount() async {
    var url =
        "https://api.moviehouse.download/api/downloads/add?type=web_series&id=${widget.series.id}&api_key=${widget.apiKey}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      print("Download count status: ${result['message']}");
    } else {
      throw Exception('Failed API request to Download count');
    }
  }

  @override
  initState() {
    super.initState();
    _populateAllResults();
    AdColony.init(AdColonyOptions('appdbb93c3885d94a2697', '0', this.zones));
    Future.delayed(Duration(seconds: 2), () => setState(() {}));
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return (widget.series != null)
        ? Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            // floatingActionButtonAnimator: ,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndTop,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () async {
                Share.share(
                    "Watch or download ${widget.series.title} on MovieHouse app for Absolutely FREE. Get this app from this link \n" +
                        "http://moviehouse.download/Moviehouse-v1.0.apk");
              },
              child: SvgPicture.asset(
                'assets/icons/Share.svg',
                height: 25.0,
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                splashRadius: 25.0,
                icon: SvgPicture.asset('assets/icons/Back.svg'),
                onPressed: () {
                  return Navigator.pop(context);
                },
              ),
            ),
            body: SizedBox.expand(
              child: Stack(children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.transparent,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://api.moviehouse.download/admin/movie/image/' +
                            widget.series.poster,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox.expand(
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.5,
                    minChildSize: 0.5,
                    maxChildSize: 0.75,
                    expand: false,
                    builder: (_, controller) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 5,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text(
                                  widget.series.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "NEXA",
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
                                        color:
                                            Color.fromARGB(255, 151, 169, 170),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "NEXA",
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      child: Icon(Icons.brightness_1,
                                          size: 6.0, color: Colors.white),
                                    ),
                                    Row(
                                      children: widget.series.genres
                                          .map((genre) => Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5.0),
                                                child: Text(genre,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 151, 169, 170),
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: "NEXA",
                                                    )),
                                              ))
                                          .toList(),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 5.0),
                                      child: Icon(Icons.brightness_1,
                                          size: 6.0, color: Colors.white),
                                    ),
                                    Row(
                                      children: (widget.series.language.length >
                                              0)
                                          ? widget.series.language
                                              .map((language) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text(
                                                      language,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 151, 169, 170),
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "NEXA",
                                                      ),
                                                    ),
                                                  ))
                                              .toList()
                                          : [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.0),
                                                child: Text(
                                                  'No Language',
                                                  style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 151, 169, 170),
                                                    fontSize: 14.0,
                                                    fontFamily: "NEXA",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                (_seasons != null)
                                    ? Container(
                                        width: double.infinity,
                                        height: 55.0,
                                        margin: EdgeInsets.only(bottom: 10.0),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: _seasons.length,
                                          controller: controller,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  final parts =
                                                      _seasons[index].parts;

                                                  setState(() {
                                                    selectedIndex = index;
                                                    _fetchAllParts(parts);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    color: selectedIndex ==
                                                            index
                                                        ? Colors.blue[800]
                                                        : Color.fromARGB(
                                                            255, 25, 27, 45),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10.0),
                                                  height: 55.0,
                                                  width: 90.0,
                                                  child: Center(
                                                    child: Text(
                                                      "Season " +
                                                          _seasons[index]
                                                              .seasonName,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "NEXA",
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                              ],
                            ),
                            (_allEpisodes != null)
                                ? Expanded(
                                    child: ListView.builder(
                                        padding: EdgeInsets.only(
                                            bottom: 50.0,
                                            left: 10.0,
                                            right: 10.0),
                                        itemCount: _allEpisodes.length,
                                        shrinkWrap: true,
                                        physics: ScrollPhysics(),
                                        controller: controller,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          // print("UI rendering");
                                          return Container(
                                            color:
                                                Color.fromARGB(255, 25, 27, 45),
                                            margin:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: GestureDetector(
                                              child: ListTile(
                                                visualDensity:
                                                    VisualDensity.standard,
                                                tileColor: Color.fromARGB(
                                                    255, 25, 27, 45),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                title: Text(
                                                  _allEpisodes[index].partName,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.0,
                                                    fontFamily: "NEXA",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                trailing: (buttonClicked &&
                                                        selectedEpisode ==
                                                            index)
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5.0),
                                                        child: Text("$_start",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    "NEXA",
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )
                                                    : SvgPicture.asset(
                                                        'assets/icons/Download.svg',
                                                        height: 20.0,
                                                      ),
                                              ),
                                              onTap: () {
                                                startTimer();
                                                setState(() {
                                                  buttonClicked = true;
                                                  selectedEpisode = index;
                                                  _start = 5;
                                                });
                                                _downloadCount();
                                                listener(
                                                    AdColonyAdListener event,
                                                    int reward) async {
                                                  print(event);
                                                  if (event ==
                                                      AdColonyAdListener
                                                          .onRequestFilled) {
                                                    if (await AdColony
                                                        .isLoaded()) {
                                                      AdColony.show();
                                                    }
                                                  }
                                                  if (event ==
                                                      AdColonyAdListener
                                                          .onReward) {
                                                    print('ADCOLONY: $reward');
                                                  }
                                                  if (event ==
                                                      AdColonyAdListener
                                                          .onClosed) {
                                                    print('closed ad');
                                                    return _downloadLink(index);
                                                  }
                                                  if (event ==
                                                      AdColonyAdListener
                                                          .onRequestNotFilled) {
                                                    print('ad failed');
                                                    return _downloadLink(index);
                                                  }
                                                }

                                                return AdColony.request(
                                                    this.zones[0], listener);
                                              },
                                            ),
                                          );
                                        }),
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text('No Episodes',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "NEXA",
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          )
        : Center(child: Text('Something Went Wrong!'));
  }
}
