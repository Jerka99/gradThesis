
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_mate/appBar/customBar_connector.dart';
import 'package:travel_mate/main_api.dart';
import 'package:travel_mate/pages/auth/auth_action.dart';
import 'package:travel_mate/redux/myStateObserver.dart';
import 'app_state.dart';
import 'calendar/Calendar.dart';
import 'navigation/my_route_information_parser.dart';
import 'navigation/my_router_delegate.dart';

late GlobalKey<NavigatorState> navigatorKey;
final GlobalKey<AppViewportState> appViewportKey = GlobalKey<AppViewportState>();

Future<void> main() async {
  // setPathUrlStrategy(); has enabled normal routing paths without # (hash) in
  // path. Also return from undefined page is possible. but with hash its SPA
  await dotenv.load(fileName: ".env");
  AppState state = AppState.initialState();
  var store =
      Store<AppState>(initialState: state, stateObservers: [MyStateObserver()]);
  runApp(MyApp(store: store));
}

class MyApp extends StatefulWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final MyRouteInformationParser _routeInformationParser =
      MyRouteInformationParser();
  late final MyRouterDelegate _routeDelegate;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _routeDelegate = widget.store.state.routerDelegate;
    Future.microtask(() async {
      await widget.store.dispatch(LoginAction());
      setState(() {
        loading = false;
      });
    });
    // MainApiClass.initializePlatform(widget.store.state.platformDto);
    navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {

    return StoreProvider<AppState>(
        store: widget.store,
        child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(useMaterial3: true),
            routerDelegate: _routeDelegate,
            routeInformationParser: _routeInformationParser,
            builder: (BuildContext context, Widget? child) {
              return Navigator(
                key: navigatorKey,
                onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (context) => loading ? LoadingScreen() : AppViewport(child: child),
                ),
              );
            }));
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.cyan[50],
        child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                          "TravelMate",
                          style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                CircularProgressIndicator(
                  color: Colors.blue,
                )
              ],
            )),
      ),
    );
  }
}

class AppViewport extends StatefulWidget {
  Widget? child;

  AppViewport({
    this.child,
  }) : super(key: appViewportKey);

  @override
  State<AppViewport> createState() => AppViewportState();
}

class AppViewportState extends State<AppViewport> {

  void informUser(message, [color = Colors.green]) {
       var snackBar = SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        duration: const Duration(milliseconds: 2500),
        backgroundColor: color,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<DateTime?>? showCalendarDialog(dateTime) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Calendar(dateTime: dateTime,);
      },
    ).then((selectedDateTime) {
      if (selectedDateTime != null) {
          return selectedDateTime;
      }
      return null;
    });
  }

  Future<DateTime?>? showLoading(String content) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
       showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.cyan[50],
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: Colors.black,
              ),
              const SizedBox(width: 20),
              Text('Loading $content'),
            ],
          ),
        );      },
    );});
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Set to true to resize the UI to avoid bottom overflow
      body: SafeArea(
        child: Container(
            width: size.width,
            height: size.height,
            color: Colors.cyan[50],
            child: Column(
              children: [
                const CustomBarConnector(),
                Expanded(
                  child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 700, // Set the maximum width here
                      ),
                      width: size.width,
                      height: size.height - 106,
                      color: Colors.cyan[50],
                      child: widget.child),
                ),
              ],
            )),
      ),
    );
  }
}

