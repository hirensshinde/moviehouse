import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_house4/models/moviex.dart';
import 'package:movie_house4/provider/navigationProvider.dart';
import 'package:movie_house4/widgets/sidebarWidget.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class DownloadsScreen extends StatefulWidget {
  Movie movie;

  DownloadsScreen({this.movie});

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  bool _isDownloading = false;

  String downloadMessage = "Initializing...";

  String size;

  @override
  void initState() {
    super.initState();
    _downloadMovie();
  }

  void _downloadMovie() async {
    var dir = await getExternalStorageDirectory();

    Dio dio = Dio();
    dio.download(widget.movie.downloadLink,
        '${dir.path}' + widget.movie.title.trim() + '.mp4',
        onReceiveProgress: (actualBytes, totalBytes) {
      var percentage = actualBytes / totalBytes * 100;

      if (percentage < 100) {
        setState(() {
          downloadMessage =
              "${filesize(actualBytes)} / ${filesize(totalBytes)}";
          // size = totalBytes.toString();
        });
      } else {
        setState(() {
          downloadMessage = "Completed";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Downloads'),
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/Back.svg'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // centerTitle: true,
      ),
      body: Container(
        // color: Colors.black45,
        child: Container(
          // margin: const EdgeInsets.all(8.0),
          child: ListTile(
            tileColor: Color.fromARGB(255, 25, 27, 45),
            // minVerticalPadding: .0,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://api.moviehouse.download/admin/movie/image/' +
                    widget.movie.poster,
              ),
            ),
            trailing: IconButton(
              icon: SvgPicture.asset(_isDownloading
                  ? 'assets/icons/Pause.svg'
                  : 'assets/icons/Play.svg'),
              onPressed: () {
                setState(
                  () {
                    _isDownloading = !_isDownloading;
                  },
                );
              },
            ),
            title: Text(widget.movie.title,
                style: TextStyle(color: Colors.white, fontSize: 18.0)),
            subtitle: Text(downloadMessage ?? "",
                style: TextStyle(color: Colors.white, fontSize: 14.0)),
          ),
        ),
      ),
    );
  }
}
