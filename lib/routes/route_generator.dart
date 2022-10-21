import 'package:flutter/material.dart';
import 'package:flutter_firebase_config/pages/home/start/start_page.dart';
import 'create_route.dart';
import '../pages/error/error_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        {
          return createRoute(page: const StartPage());
        }
      default:
        {
          return createRoute(page: const ErrorPage());
        }
    }
  }
}
