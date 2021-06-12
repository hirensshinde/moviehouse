import 'package:expandable_card/expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moviehouse/models/webseries.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adcolony_flutter/adcolony_flutter.dart';
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
  // RewardedAd rewardedAd;
  // InterstitialAd _interstitialAd;
  // int _numInterstitialLoadAttempts = 5;

  List<Season> _seasons;
  List<Part> _allEpisodes;

  final zones = [
    'vzfcb0fc4cffec44f78d',
  ];

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
      print('Data Not arrived yet');
      throw Exception('Data not arrived yet');
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
            body: ExpandableCardPage(
              page: Container(
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
              expandableCard: ExpandableCard(
                // hasHandle: false,
                hasHandle: true,
                backgroundColor: Colors.black,
                padding: EdgeInsets.only(top: 5, left: 10, right: 10),
                // maxHeight: MediaQuery.of(context).size.height - 100,
                minHeight: MediaQuery.of(context).size.height * 0.55,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
                hasRoundedCorners: true,
                hasShadow: true,
                children: <Widget>[
                  // SizedBox(height: 25.0),
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
                                      style: TextStyle(color: Colors.white)),
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
                          margin: EdgeInsets.only(bottom: 10.0),
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
                        )
                      : Center(
                          child: Text('No Seasons',
                              style: TextStyle(color: Colors.white)),
                        ),
                  (_allEpisodes != null)
                      ? Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.only(
                                  bottom: 50.0, left: 5.0, right: 5.0),
                              itemCount: _allEpisodes.length,
                              // shrinkWrap: true,
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                print("UI rendering");
                                return Card(
                                  elevation: 0.0,
                                  shadowColor: Colors.black,
                                  child: ListTile(
                                    visualDensity: VisualDensity.standard,
                                    tileColor: Color.fromARGB(255, 25, 27, 45),
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15.0),
                                    title: Text(
                                      _allEpisodes[index].partName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    trailing: IconButton(
                                      icon: SvgPicture.asset(
                                        'assets/icons/Download.svg',
                                        height: 25.0,
                                      ),
                                      onPressed: () {
                                        listener(AdColonyAdListener event,
                                            int reward) async {
                                          print(event);
                                          if (event ==
                                              AdColonyAdListener
                                                  .onRequestFilled) {
                                            if (await AdColony.isLoaded()) {
                                              AdColony.show();
                                            }
                                          }
                                          if (event ==
                                              AdColonyAdListener.onReward) {
                                            print('ADCOLONY: $reward');
                                          }
                                          if (event ==
                                              AdColonyAdListener.onClosed) {
                                            print('closed ad');
                                            return _downloadLink(index);
                                          }
                                        }

                                        return AdColony.request(
                                            this.zones[0], listener);
                                      },
                                    ),
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
          )
        : Center(child: Text('Something Went Wrong!'));
  }
}
