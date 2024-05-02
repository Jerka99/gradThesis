import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/app_state.dart';
import 'package:redux_example/pages/register/register_container.dart';

import '../FormInputs.dart';

class LoginPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onLogin;
  final Function() routeChange;

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
  "password" : ""
};

  // List<> inputs =[
  //
  // ]

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
             child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        padding: EdgeInsets.all(18.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(width: 20.0),
                    ElevatedButton(
                        onPressed: (){
                          widget.routeChange();
                        },
                        child: Text("Register"))
                  ],
                )
              ],
            ),
      ),
    );
  }
}

