import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_state.dart';
import 'navigation/my_route_information_parser.dart';
import 'navigation/my_router_delegate.dart';


late GlobalKey<NavigatorState> navigatorKey;
Future<void> main() async {
  // setPathUrlStrategy(); has enabled normal routing paths without # (hash) in
  // path. Also return from undefined page is possible. but with hash its SPA
  await dotenv.load(fileName: ".env");
  AppState state = AppState.initialState();

  var store = Store<AppState>(
    initialState: state,
  );
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
  late final MyRouterDelegate _routeDelegate;
  @override
  void initState() {
    super.initState();
    _routeDelegate = widget.store.state.routerDelegate;
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: widget.store,
          child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true
              ),
              routerDelegate: _routeDelegate,
          routeInformationParser: _routeInformationParser,
            builder: (BuildContext context, Widget? child){
                return DefaultTabController(
                  length: 3,
              child: Scaffold(
                appBar:  AppBar(
                  title: const Text("BAR"),
                  bottom: widget.store.state.user.role != null ? TabBar(
                    tabs:const [
                      Tab(icon: Icon(Icons.home), text: 'Home'),
                      Tab(icon: Icon(Icons.favorite), text: 'Unknown'),
                      Tab(icon: Icon(Icons.person), text: 'Login'),
                    ],
                    onTap: (int index){
                      final tabs = ["/", "unknown", "login"];
                      _routeDelegate.myNavigate(tabs[index]);
                    },
                  ) : null
                ) ,
                body: SizedBox(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        color:Colors.cyan[50],
                        child: child
                    )
                ),
              ));
            })
    );}
}
