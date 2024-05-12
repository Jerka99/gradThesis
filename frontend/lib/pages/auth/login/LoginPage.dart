import 'package:flutter/material.dart';

import '../../FormInputs.dart';
import '../hyperlink.dart';

class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onLogin;
  final Function(String) routeChange;

  const LoginPage({
    super.key,
    required this.onLogin,
    required this.routeChange
  });

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // final TextEditingController _textEditingController = TextEditingController();
  Map<String, dynamic> inputs = {
  "email" : "",
  "password" : "",
};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
             child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Login",
                      style: TextStyle(
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold
                      ),
                    )),
                const SizedBox(height: 80.0,),
                ...inputs.keys.map((element) => FormInputs(
                    element: element,
                    inputValueFun: (value) {
                      setState(() {
                        inputs[element] = value;
                      });
                    },
                )).toList(),
                Align(
                  alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () { widget.onLogin(inputs)
                      ; },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18.0),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)
                          )),
                      child: const Text(
                          "Log in",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                      ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HyperLink(
                        text: "Don't have an account? Join us as out Driving Partner ",
                        linkText: "here",
                        link:() => widget.routeChange("registerDriver")
                    ),
                    const SizedBox(height: 20.0,),
                    HyperLink(
                        text: "Don't have an account? Sign up as a Customer ",
                        linkText: "here",
                        link:() => widget.routeChange("registerCustomer")
                    ),
                  ],
                )
              ],
            ),
      ),
    );
  }
}



