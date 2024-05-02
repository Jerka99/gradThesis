import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux_example/CustomBar.dart';
import 'package:redux_example/customBar_container.dart';
import 'package:redux_example/redux/myStateObserver.dart';

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
    stateObservers:[MyStateObserver()]
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin{
  final MyRouteInformationParser _routeInformationParser = MyRouteInformationParser();
  late final MyRouterDelegate _routeDelegate;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    _routeDelegate = widget.store.state.routerDelegate;
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              return StoreConnector<AppState, Map>(
                  converter: (store)
              {
                String? userHasRole = store.state.user.role;
                String route = store.state.route;
                return {
                  'userHasRole': userHasRole,
                  'route': route,
                };
              },builder: (context, data) =>
              Scaffold(
                  resizeToAvoidBottomInset: true, // Set to true to resize the UI to avoid bottom overflow
                  // appBar:  AppBar(
                  //   title: const Text("BAR"),
                  //   // data["userHasRole"] ? TabBar(
                  //   //   controller: tabController,
                  //   //   tabs:const [
                  //   //     Tab(icon: Icon(Icons.home), text: 'Home'),
                  //   //     Tab(icon: Icon(Icons.favorite), text: 'Unknown'),
                  //   //     Tab(icon: Icon(Icons.person), text: 'Something'),
                  //   //   ],
                  //   //   onTap: (int index){
                  //   //     final tabs = ["/", "unknown", "something"];
                  //   //     _routeDelegate.myNavigate(tabs[index]);
                  //   //   },
                  //   // ) : null
                  // ) ,
                  body: SafeArea(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        width: size.width,
                          height: size.height,
                          child: Column(
                            children: [
                              Container(
                                child: CustomBarContainer(route:
                                data["route"], userHasRole:
                                data["userHasRole"]),
                              ),
                              Container(
                                width: size.width,
                                height: size.height * 0.88,
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                  color:Colors.cyan[50],
                                  child: child
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ));
            })
    );}
}

