import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:direct_link/direct_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_house4/models/genres.dart';
import 'package:movie_house4/models/movies.dart';
import 'package:movie_house4/screens/NewDownloadScreen.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

const int maxFailedLoadAttempts = 3;

class MovieDetail extends StatefulWidget {
  final Movie movie;

  MovieDetail({this.movie});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  RewardedAd rewardedAd;
  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  initState() {
    super.initState();
    _createInterstitialAd();
  }

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

  void _showInterstitialAd() {
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
                    PlayScreen(link: widget.movie.downloadLink)));
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

  void _showInterstitialAdfromDownload() {
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
        return _downloadLink();
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

  @override
  Widget build(BuildContext context) {
    return (widget.movie != null)
        ? Scaffold(
            extendBodyBehindAppBar: true,
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () async {
                    Share.share(
                        "Watch or download ${widget.movie.title} on MovieHouse app for completely FREE. Get this app from this link \n" +
                            "http://demo.gopiui.com/movie");
                  },
                  child: SvgPicture.asset(
                    'assets/icons/Share.svg',
                    height: 30.0,
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  backgroundColor: Colors.blue[800],
                  onPressed: () async {
                    return _showInterstitialAdfromDownload();
                  },
                  child: SvgPicture.asset(
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
                              widget.movie.poster,
                        ),
                        fit: BoxFit.cover,
                      ),
                      // backgroundBlendMode: BlendMode.
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
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 40.0),
                            Text(
                              widget.movie.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.movie.year.toString(),
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(width: 5.0),
                                Row(
                                  children: (widget.movie.genreList.length > 0)
                                      ? widget.movie.genreList
                                          .map((genre) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                child: Text(genre,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ))
                                          .toList()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text('No Genres',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                ),
                                Row(
                                    children: (widget.movie.language.length > 0)
                                        ? widget.movie.language
                                            .map((language) => Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 5.0),
                                                  child: Text(language,
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ))
                                            .toList()
                                        : [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              child: Text('No ',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ]),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                widget.movie.description,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 7,
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
          )
        : Center(child: Container(child: Text('Something went wrong')));
  }
}
