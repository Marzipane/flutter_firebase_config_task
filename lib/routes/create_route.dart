import 'package:flutter/material.dart';

MaterialPageRoute createRoute({settings, required Widget page}) {
  return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings);
}
