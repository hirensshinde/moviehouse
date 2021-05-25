import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PlayScreen extends StatefulWidget {
  final String link;

  PlayScreen({this.link});

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController pullToRefreshController;

  String url = "";

  double progress = 0;

  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _inAppWebView();
  }

  _inAppWebView() {
    return Container(
        child: Column(children: <Widget>[
      Expanded(
          child: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.link)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
              resources: resources,
              action: PermissionRequestResponseAction.GRANT);
        },
        onLoadStop: (controller, url) async {
          pullToRefreshController.endRefreshing();
          setState(() {
            this.url = url.toString();
            urlController.text = this.url;
          });
        },
        onLoadError: (controller, url, code, message) {
          pullToRefreshController.endRefreshing();
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            pullToRefreshController.endRefreshing();
          }
          setState(() {
            this.progress = progress / 100;
            urlController.text = this.url;
          });
        },
        onDownloadStart: (controller, url) async {
          print("onDownloadStart $url");

          final taskId = await FlutterDownloader.enqueue(
            url: url.toString(),
            savedDir: (await getExternalStorageDirectory()).path,
            showNotification:
                true, // show download progress in status bar (for Android)
            openFileFromNotification:
                true, // click on notification to open downloaded file (for Android)
          );
        },
      ))
    ]));
  }
}
