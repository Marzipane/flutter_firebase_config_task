import 'package:flutter/material.dart';
import 'components/body.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return WebViewRoot(url: url);
  }
}
