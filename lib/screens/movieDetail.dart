import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_house4/models/moviex.dart';
import 'package:movie_house4/screens/downloadsScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;

  MovieDetail({this.movie});

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    if (widget.movie != null) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () async {
            final status = await Permission.storage.request();

            if (status.isGranted) {
              final externalDir = await getExternalStorageDirectory();
              final id = await FlutterDownloader.enqueue(
                url: widget.movie.downloadLink,
                savedDir: externalDir.path,
                fileName: widget.movie.title,
                showNotification: true,
                openFileFromNotification: true,
              );
            } else {
              print("Permission denied");
            }
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return DownloadsScreen(movie: widget.movie);
            //     },
            //   ),
            // );
          },
          child: SvgPicture.asset(
            'assets/icons/Download.svg',
            height: 20.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: SvgPicture.asset('assets/icons/Back.svg'),
            onPressed: () {
              return Navigator.pop(context);
            },
          ),
          title: Text(widget.movie.title),
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
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            widget.movie.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Action, Drama',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            widget.movie.description,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.start,
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
      );
    }
  }
}
