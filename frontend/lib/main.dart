
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_mate/appBar/customBar_connector.dart';
import 'package:travel_mate/calendar/calendar_connector.dart';
import 'package:travel_mate/pages/auth/auth_action.dart';
import 'package:travel_mate/redux/myStateObserver.dart';

import 'calendar/Calendar.dart';
import 'app_state.dart';
import 'navigation/my_route_information_parser.dart';
import 'navigation/my_router_delegate.dart';

late GlobalKey<NavigatorState> navigatorKey;

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
    widget.store.dispatch(LoginAction());
    Future.microtask(() async {
      await widget.store.dispatch(LoginAction());
      setState(() {
        loading = false;
      });
    });
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
            child: Text(
          "TravelMate",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 40),
        )),
      ),
    );
  }
}

class AppViewport extends StatefulWidget {
  Widget? child;

  AppViewport({
    this.child,
    super.key
  });

  @override
  State<AppViewport> createState() => AppViewportState();
}

class AppViewportState extends State<AppViewport> {

  void informUser(message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
       var snackBar = SnackBar(
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            message,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<DateTime?>? showCalendarDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CalendarConnector();
      },
    ).then((selectedDateTime) {
      if (selectedDateTime != null) {
          return selectedDateTime;
      }
      return null;
    });
  }

  Future<void> showSuccessDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: const Text('Your account has been created successfully!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      // After the dialog is dismissed, navigate to login
      Navigator.of(context).pushNamed('/login');
    });
  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // Set to true to resize the UI to avoid bottom overflow
      body: SafeArea(
        child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              children: [
                Container(
                    color: Colors.cyan[50],
                    child: const CustomBarConnector()),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 20),
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

