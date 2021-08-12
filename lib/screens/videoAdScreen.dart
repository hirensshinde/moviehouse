import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class FullScreenVideoAd extends StatefulWidget {
  final String link;
  final String videoFile;

  FullScreenVideoAd({this.link, this.videoFile});

  @override
  _FullScreenVideoAdState createState() => _FullScreenVideoAdState();
}

class _FullScreenVideoAdState extends State<FullScreenVideoAd> {
  VideoPlayerController _controller;
  String link;
  String videoFile;

  Timer timer;
  int start = 10;
  Duration _duration;
  Duration _position;
  bool _isEnd = false;
  bool timerEnd = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (start == 0) {
        timerEnd = true;
        timer.cancel();
      } else {
        setState(() {
          start--;
        });
      }
    });

    // BackButtonInterceptor.add(interceptor);

    print("here is video file :::++++ --- >> ${widget.videoFile}");

    Future.delayed(Duration(seconds: 3));

    _controller = VideoPlayerController.network(
        'https://moviehousebucket.s3.amazonaws.com/public/images/${widget.videoFile}')
      ..addListener(() {
        Timer.run(() {
          this.setState(() {
            _position = _controller.value.position;
          });
        });
        setState(() {
          _duration = _controller.value.duration;
        });
        _duration?.compareTo(_position) == -1
            ? this.setState(() {
                _isEnd = true;
              })
            : this.setState(() {
                _isEnd = false;
              });
      })
      ..initialize().then((_) {
        setState(() {
          _controller.value.isInitialized
              ? _controller.play()
              : _controller.pause();
        });
      });
  }

  // bool interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   return true;
  // }

  Future<void> launcher(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          toolbarHeight: 0.0,
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
        ),
        backgroundColor: Colors.black,
        body: _controller.value.isInitialized
            ? Container(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pop("Advertisement");
                    launcher(widget.link);
                    print(
                        "THIS IS THE ADVERTISEMENT LINK: ####>> ${widget.link}");
                  },
                  child: Stack(children: [
                    VideoPlayer(_controller),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: timerEnd
                          ? IconButton(
                              icon: CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.white,
                                  child:
                                      Icon(Icons.close, color: Colors.black)),
                              onPressed: () {
                                return Navigator.of(context)
                                    .pop('Advertisement');
                              },
                            )
                          : IconButton(
                              onPressed: () {},
                              icon: CircleAvatar(
                                radius: 15.0,
                                backgroundColor: Colors.white,
                                child: Text("$start",
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                    ),
                  ]),
                ),
              )
            : Center(
                child: Container(
                child: CircularProgressIndicator(),
              )),
      ),
    );
  }
}
