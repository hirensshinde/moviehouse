import 'dart:async';
import 'dart:convert';

import 'package:adcolony_flutter/adcolony_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moviehouse/models/movies.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

const int maxFailedLoadAttempts = 3;

class MovieDetail extends StatefulWidget {
  final Movie movie;
  final String apiKey;

  MovieDetail({this.movie, this.apiKey});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  // static final AdRequest request = AdRequest(
  //   keywords: <String>['foo', 'bar'],
  //   contentUrl: 'http://foo.com/bar.html',
  //   nonPersonalizedAds: true,
  // );

  // RewardedAd rewardedAd;
  // InterstitialAd _interstitialAd;
  // int _numInterstitialLoadAttempts = 5;

  final zones = [
    'vzfcb0fc4cffec44f78d',
  ];
  bool buttonClicked = false;

  @override
  initState() {
    super.initState();
    AdColony.init(AdColonyOptions('appdbb93c3885d94a2697', '0', this.zones));
    print("=====#####################>>>>>>> ${widget.movie}");
  }

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
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: 'ca-app-pub-1527057564066862/9641981646',
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           print('$ad loaded');
  //           _interstitialAd = ad;
  //           _numInterstitialLoadAttempts = 0;
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

  // void _showInterstitialAdfromDownload() {
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
  //       return _downloadLink();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //       _createInterstitialAd();
  //     },
  //   );
  //   print(_interstitialAd.adUnitId);
  //   _interstitialAd.show();
  //   _interstitialAd = null;
  // }

  void _downloadLink() async {
    var url = widget.movie.downloadLink;
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

  void _downloadCount() async {
    var url =
        "https://api.moviehouse.download/api/downloads/add?type=movie&id=${widget.movie.id}&api_key=${widget.apiKey}";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map result = jsonDecode(response.body);
      print("Download Count Status: ${result['message']}");
    } else {
      throw Exception('Failed to Request Download Count API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.black,
            heroTag: 'btn2',
            onPressed: () async {
              Share.share(
                  "Watch or download ${widget.movie.title} on MovieHouse app for completely FREE. Get this app from this link \n" +
                      "http://moviehouse.download/Moviehouse-v1.0.apk");
            },
            child: SvgPicture.asset(
              'assets/icons/Share.svg',
              height: 30.0,
            ),
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            backgroundColor: Colors.blue[800],
            heroTag: 'btn1',
            onPressed: () async {
              startTimer();
              setState(() {
                buttonClicked = true;
              });
              _downloadCount();
              listener(AdColonyAdListener event, int reward) async {
                print(event);
                if (event == AdColonyAdListener.onRequestFilled) {
                  if (await AdColony.isLoaded()) {
                    AdColony.show();
                  }
                }
                if (event == AdColonyAdListener.onReward) {
                  print('ADCOLONY: $reward');
                }
                if (event == AdColonyAdListener.onClosed) {
                  print('closed ad');
                  return _downloadLink();
                }
                if (event == AdColonyAdListener.onRequestNotFilled) {
                  print('ad failed');
                  return _downloadLink();
                }
              }

              return AdColony.request(this.zones[0], listener);
            },
            child: (buttonClicked)
                ? Text("$_start")
                : SvgPicture.asset(
                    'assets/icons/Download.svg',
                    height: 20.0,
                  ),
          ),
        ],
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          splashRadius: 25.0,
          icon: SvgPicture.asset('assets/icons/Back.svg'),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width,
            // color: Colors.transparent,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://api.moviehouse.download/admin/movie/image/' +
                      widget.movie.poster,
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
                            widget.movie.title,
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
                                widget.movie.year.toString(),
                                style: TextStyle(
                                  color: Color.fromARGB(255, 151, 169, 170),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "NEXA",
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(Icons.brightness_1,
                                    size: 6.0, color: Colors.white),
                              ),
                              Row(
                                children: widget.movie.genreList
                                    .map((genre) => Padding(
                                          padding:
                                              const EdgeInsets.only(right: 5.0),
                                          child: Text(genre,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 151, 169, 170),
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "NEXA",
                                              )),
                                        ))
                                    .toList(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Icon(Icons.brightness_1,
                                    size: 6.0, color: Colors.white),
                              ),
                              Row(
                                children: (widget.movie.language.length > 0)
                                    ? widget.movie.language
                                        .map((language) => Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text(
                                                language,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 151, 169, 170),
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              widget.movie.description,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "NEXA",
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 7,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // SingleChildScrollView(
                  //         child: Stack(
                  //           // alignment: Alignment.bottomCenter,
                  //           // fit: StackFit.expand,
                  //           children: [
                  //             Container(
                  //               height: MediaQuery.of(context).size.height,
                  //               width: MediaQuery.of(context).size.width,
                  //               // color: Colors.transparent,
                  //               decoration: BoxDecoration(
                  //                 image: DecorationImage(
                  //                   image: (widget.movie.poster != null)
                  //                       ? NetworkImage(
                  //                           'https://api.moviehouse.download/admin/movie/image/' +
                  //                               widget.movie.poster,
                  //                         )
                  //                       : AssetImage(
                  //                           'assets/images/poster_placeholder.png'),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 // backgroundBlendMode: BlendMode.
                  //               ),
                  //             ),
                  //             Positioned(
                  //               bottom: 0.0,
                  //               left: 0.0,
                  //               right: 0.0,
                  //               child: Container(
                  //                 color: Colors.transparent,
                  //                 child: Container(
                  //                   height: MediaQuery.of(context).size.height / 2,
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.black,
                  //                     borderRadius: BorderRadius.only(
                  //                       topLeft: Radius.circular(40.0),
                  //                       topRight: Radius.circular(40.0),
                  //                     ),
                  //                   ),
                  //                   child: Column(
                  //                     children: [
                  //                       SizedBox(height: 40.0),
                  //                       Text(
                  //                         widget.movie.title,
                  //                         textAlign: TextAlign.center,
                  //                         style: TextStyle(
                  //                           color: Colors.white,
                  //                           fontSize: 26.0,
                  //                           fontWeight: FontWeight.bold,
                  //                           fontFamily: "NEXA",
                  //                         ),
                  //                       ),
                  //                       SizedBox(height: 10.0),
                  //                       Row(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         children: [
                  //                           Text(
                  //                             widget.movie.year.toString(),
                  //                             style: TextStyle(
                  //                               color: Color.fromARGB(255, 151, 169, 170),
                  //                               fontSize: 14.0,
                  //                               fontWeight: FontWeight.bold,
                  //                               fontFamily: "NEXA",
                  //                             ),
                  //                             textAlign: TextAlign.center,
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 5.0),
                  //                             child: Icon(Icons.brightness_1,
                  //                                 size: 6.0, color: Colors.white),
                  //                           ),
                  //                           Row(
                  //                             children: (widget.movie.genreList.length > 0)
                  //                                 ? widget.movie.genreList
                  //                                     .map((genre) => Padding(
                  //                                           padding: const EdgeInsets.only(
                  //                                               right: 5.0),
                  //                                           child: Text(genre,
                  //                                               style: TextStyle(
                  //                                                 color: Color.fromARGB(
                  //                                                     255, 151, 169, 170),
                  //                                                 fontSize: 14.0,
                  //                                                 fontWeight:
                  //                                                     FontWeight.bold,
                  //                                                 fontFamily: "NEXA",
                  //                                               )),
                  //                                         ))
                  //                                     .toList()
                  //                                 : Padding(
                  //                                     padding: EdgeInsets.symmetric(
                  //                                         horizontal: 5.0),
                  //                                     child: Text('No Genres',
                  //                                         style: TextStyle(
                  //                                           color: Color.fromARGB(
                  //                                               255, 151, 169, 170),
                  //                                           fontSize: 14.0,
                  //                                           fontWeight: FontWeight.bold,
                  //                                           fontFamily: "NEXA",
                  //                                         )),
                  //                                   ),
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.only(right: 5.0),
                  //                             child: Icon(Icons.brightness_1,
                  //                                 size: 6.0, color: Colors.white),
                  //                           ),
                  //                           Row(
                  //                               children: (widget.movie.language.length > 0)
                  //                                   ? widget.movie.language
                  //                                       .map((language) => Padding(
                  //                                             padding:
                  //                                                 const EdgeInsets.only(
                  //                                                     right: 5.0),
                  //                                             child: Text(language,
                  //                                                 style: TextStyle(
                  //                                                   color: Color.fromARGB(
                  //                                                       255, 151, 169, 170),
                  //                                                   fontSize: 14.0,
                  //                                                   fontWeight:
                  //                                                       FontWeight.bold,
                  //                                                   fontFamily: "NEXA",
                  //                                                 )),
                  //                                           ))
                  //                                       .toList()
                  //                                   : [
                  //                                       Padding(
                  //                                         padding: EdgeInsets.symmetric(
                  //                                             horizontal: 5.0),
                  //                                         child: Text('No Language',
                  //                                             style: TextStyle(
                  //                                               color: Color.fromARGB(
                  //                                                   255, 151, 169, 170),
                  //                                               fontSize: 14.0,
                  //                                               fontWeight: FontWeight.bold,
                  //                                               fontFamily: "NEXA",
                  //                                             )),
                  //                                       ),
                  //                                     ]),
                  //                         ],
                  //                       ),
                  //                       SizedBox(height: 10.0),
                  //                       Padding(
                  //                         padding: const EdgeInsets.all(20.0),
                  //                         child: Text(
                  //                           widget.movie.description,
                  //                           style: TextStyle(
                  //                             fontWeight: FontWeight.bold,
                  //                             fontFamily: "NEXA",
                  //                             color: Colors.white,
                  //                           ),
                  //                           textAlign: TextAlign.center,
                  //                           maxLines: 7,
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
