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
  // _SeriesDetailState()

  @override
  Widget build(BuildContext context) {
    if (widget.series != null) {
      return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.blue,
        //   onPressed: () async {
        //     // final status = await Permission.storage.request();

        //     if (status.isGranted) {
        //       final externalDir = await getExternalStorageDirectory();
        //       final id = await FlutterDownloader.enqueue(
        //         url: widget.movie.downloadLink,
        //         savedDir: externalDir.path,
        //         fileName: widget.movie.title,
        //         showNotification: true,
        //         openFileFromNotification: true,
        //       );
        //     } else {
        //       print("Permission denied");
        //     }
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(
        //     //     builder: (context) {
        //     //       return DownloadsScreen(movie: widget.movie);
        //     //     },
        //     //   ),
        //     // );
        //   },
        //   child: SvgPicture.asset(
        //     'assets/icons/Download.svg',
        //     height: 20.0,
        //   ),
        // ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/Back.svg'),
            onPressed: () {
              return Navigator.pop(context);
            },
          ),
          title: Text(widget.series.title),
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
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.series.season.length,
                          ),
                        )
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
