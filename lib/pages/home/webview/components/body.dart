import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewRoot extends StatefulWidget {
  const WebViewRoot({super.key, required this.url});
  final String url;
  @override
  WebViewRootState createState() => WebViewRootState();
}

class WebViewRootState extends State<WebViewRoot> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
    );
  }
}
