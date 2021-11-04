import 'package:doephone/home.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

import 'package:flutter/material.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'register.dart';
import 'dialpad.dart';
import 'callscreen.dart';
import 'about.dart';
import 'home.dart';

void main() {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  runApp(MyApp());
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper helper, Object arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final SIPUAHelper _helper = SIPUAHelper();
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper helper, Object arguments]) => DialPadWidget(helper),
    '/register': ([SIPUAHelper helper, Object arguments]) => RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper helper, Object arguments]) => CallScreenWidget(helper, arguments as Call),
    '/about': ([SIPUAHelper helper, Object arguments]) => AboutWidget(),
    '/Home': ([SIPUAHelper helper, Object arguments]) => HomeWidget(),
  };

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String name = settings.name;
    final PageContentBuilder pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) =>
                pageContentBuilder(_helper, settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) => pageContentBuilder(_helper));
        return route;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoePhone',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColorDark: Colors.green[900],
        primaryColorLight: Colors.green[100],
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
