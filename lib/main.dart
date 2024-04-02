import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/utils/app_routes.dart';
import 'package:redux_example/utils/my_route_information_parser.dart';
import 'package:redux_example/utils/my_router_delegate.dart';

import 'app_state.dart';


late GlobalKey<NavigatorState> navigatorKey;
void main() {
  var store = Store<AppState>(initialState: AppState.initialState());
  runApp(MyApp(store: store));
}


class MyApp extends StatefulWidget {
  final Store<AppState> store;

  const MyApp({
    super.key,
    required this.store
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MyRouteInformationParser _routeInformationParser = MyRouteInformationParser();

  @override
  void initState() {
    super.initState();
    AppRoutes inst = AppRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
        child: ChangeNotifierProvider(
          create: (BuildContext context) => MyRouterDelegate(unsecuredPages:AppRoutes().unsecuredPages),
          builder: (context, child){
          return MaterialApp.router(
          routerDelegate: Provider.of<MyRouterDelegate>(context),
          routeInformationParser: _routeInformationParser,
            );}
        ),
    );
  }
}
