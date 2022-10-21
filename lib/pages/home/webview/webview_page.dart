import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewPage(url: url),
    );
  }
}
