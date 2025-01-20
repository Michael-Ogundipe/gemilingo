import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page.dart';
import '../text_to_text_page.dart';
import 'routes.dart';

class RouteGenerator {

  RouteGenerator() : super();

  Route? routeGenerate(RouteSettings route) {
    switch (route.name) {
      case '/':
        return navigateToRoute(const HomePage());
      case textToText:
        return navigateToRoute(const TextToTextPage());
    }

    return null;
  }

  navigateToRoute(Widget page) {
    if (Platform.isAndroid) {
      return MaterialPageRoute(builder: (context) => page);
    }

    if (Platform.isIOS) {
      return CupertinoPageRoute(builder: (context) => page);
    }
  }
}
