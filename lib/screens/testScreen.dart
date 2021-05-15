import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DownloadHome extends StatefulWidget {
  @override
  _DownloadHomeState createState() => _DownloadHomeState();
}

class _DownloadHomeState extends State<DownloadHome> {
  ProgressDialog _progressDialog;
  String taskId;
  String taskIdTwo;
  String path;

  //Whether to hide
  bool _isHidden = true;
  double _progressNum = 0.0;
  String _downloadStatusStr = 'Downloading...';
  bool _isPause = false;

  @override
  void initState() {
    //Global progress bullet box
    _progressDialog =
        ProgressDialog(context, type: ProgressDialogType.Download);

    //Monitor download callback
    FlutterDownloader.registerCallback((id, status, progress) {
      //Global bullet frame
      if (id == taskId) {
        //Show progress bullet box
        _progressDialog.isShowing() ? null : _progressDialog.show();

        if (status == DownloadTaskStatus.running) {
          print('running');
          _progressDialog.update(
            progress: progress.toDouble(),
            message: 'Trying to download...',
          );
        }

        if (status == DownloadTaskStatus.complete) {
          print('Path: $path ');
          //carry out
          _progressDialog.isShowing() ? _progressDialog.hide() : null;
          Fluttertoast.showToast(msg: 'download complete \ npath : $path ');
        }
      } else {
        if (status == DownloadTaskStatus.running) {
          print('running--$progress');
          _progressNum = progress.toDouble();
          _downloadStatusStr = 'Downloading...';
        }
        if (status == DownloadTaskStatus.canceled) {
          print('canceled');
          //cancel
          _progressNum = 0.0;
          _downloadStatusStr = 'Task has been cancelled';
        }
        if (status == DownloadTaskStatus.complete) {
          print('Path: $path ');
          //carry out
          _downloadStatusStr = 'Download completed';
          Fluttertoast.showToast(msg: 'download complete \ npath : $path ');
        }
        if (status == DownloadTaskStatus.paused) {
          print('paused');
          _downloadStatusStr = 'Download Pause';
          Fluttertoast.showToast(msg: 'Pause successfully');
          //time out

        }
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download function'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(
                  Icons.file_download,
                  size: 20,
                ),
                label: Text('New download task'),
                onPressed: () {
                  _isHidden = false;
                  getTaskTwo();
                  setState(() {});
                },
              ),
              RaisedButton.icon(
                icon: Icon(
                  _isPause ? Icons.play_circle_outline : Icons.pause,
                  size: 20,
                ),
                label:
                    _isPause ? Text('Resume download') : Text('Pause download'),
                onPressed: () {
                  if (taskIdTwo == null) {
                    Fluttertoast.showToast(
                        msg: 'Download task has not been started yet');
                    return;
                  }
                  _isPause ? resumeTask() : pauseTask();
                  _isPause = !_isPause;
                },
              ),
              RaisedButton.icon(
                icon: Icon(
                  Icons.cancel,
                  size: 20,
                ),
                label: Text('Cancel download'),
                onPressed: () {
                  taskIdTwo != null
                      ? FlutterDownloader.cancel(taskId: taskIdTwo)
                      : Fluttertoast.showToast(msg: 'No task can be cancelled');
                },
              ),
            ],
          ),
          Offstage(
            offstage: _isHidden,
            child: CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              percent: _progressNum / 100,
              center: new Text(
                "${_progressNum.toInt()}%",
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: new Text(
                _downloadStatusStr,
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.purple,
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    getTask();
                  },
                  child: Text('download of global bullet box'),
                ),
                RaisedButton(
                  onPressed: () {
                    FlutterDownloader.remove(
                        taskId: taskId, shouldDeleteContent: true);
                    FlutterDownloader.remove(
                        taskId: taskIdTwo, shouldDeleteContent: true);
                  },
                  child: Text('Remove all download tasks'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<String> getDocPath() async {
    var docDir = await getApplicationDocumentsDirectory();
    String pathDoc = docDir.path + '/download';
    final targetPath = Directory(pathDoc);
    if (!await targetPath.exists()) {
      targetPath.create();
    }
    return pathDoc;
  }

//Download the configuration and execute
  getTask() async {
    path = await getDocPath();
    taskId = await FlutterDownloader.enqueue(
      url:
          'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4',
      savedDir: path,
    );

    await FlutterDownloader.loadTasksWithRawQuery(query: taskId);
  }

  getTaskTwo() async {
    path = await getDocPath();
    taskIdTwo = await FlutterDownloader.enqueue(
      url:
          'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4',
      savedDir: path,
    );

    await FlutterDownloader.loadTasksWithRawQuery(query: taskIdTwo);
  }

  void resumeTask() async {
    taskIdTwo = await FlutterDownloader.resume(taskId: taskIdTwo);
  }

  void pauseTask() async {
    await FlutterDownloader.pause(taskId: taskIdTwo);
  }
}
