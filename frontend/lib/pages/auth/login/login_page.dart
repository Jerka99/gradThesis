import 'package:flutter/material.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';

import '../../FormInputs.dart';
import '../hyperlink.dart';

class LoginPage extends StatefulWidget {
  final Function(AuthDto) onLogin;
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
  AuthDto inputData = AuthDto(email: "", password: "");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height - 106,
      constraints: const BoxConstraints(
        minHeight: 700.0,
      ),
      child: Center(
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
                  FormInputs(
                      element: "email",
                      inputValueFun: (value) {
                        setState(() {
                          inputData = inputData.copyWith(email: value);
                        });
                      },
                  ),
                  FormInputs(
                    element: "password",
                    obscureText: true,
                    inputValueFun: (value) {
                      setState(() {
                        inputData = inputData.copyWith(password: value);
                      });
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () { widget.onLogin(inputData)
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
      ),
    );
  }
}



