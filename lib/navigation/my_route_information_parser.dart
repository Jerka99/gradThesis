import 'package:flutter/cupertino.dart';

class MyRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(
      //is reading route and forwarding it to the...
      RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.uri.toString());
    print(uri);
    return routeInformation.uri.path;
  }

  @override
  RouteInformation restoreRouteInformation(String configuration) {
    return RouteInformation(uri: Uri.parse(configuration));
  }
}
