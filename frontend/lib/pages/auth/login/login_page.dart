import 'package:flutter/material.dart';
import 'package:travel_mate/pages/auth/auth_dto.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';

import '../../FormInputs.dart';
import '../hyperlink.dart';

class LoginPage extends StatefulWidget {
  final Function(AuthDto) onLogin;
  final Function(String) routeChange;
  AuthResponseHandler? authResponseHandler;

  LoginPage({
    super.key,
    required this.onLogin,
    required this.routeChange,
    required this.authResponseHandler,
  });

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  late AuthResponseHandler authResponseHandler;

  @override
  void initState() {
    authResponseHandler = AuthResponseHandler.init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LoginPage oldWidget) {
    authResponseHandler = widget.authResponseHandler!;
    super.didUpdateWidget(oldWidget);
  }

  // final TextEditingController _textEditingController = TextEditingController();
  AuthDto inputData = AuthDto(email: "", password: "");
  final _formKey = GlobalKey<FormState>(); // Key for managing form state

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
          child: Form(
            key: _formKey,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 80.0,
                ),
                FormInputs(
                  element: "email",
                  errorText:
                  authResponseHandler.message == "" ? null : authResponseHandler.message,
                  inputValueFun: (value) {
                    setState(() {
                      inputData = inputData.copyWith(email: value);
                    });
                  },
                  submitOnKey: formSubmit,
                ),
                FormInputs(
                  element: "password",
                  obscureText: true,
                  errorText:
                  authResponseHandler.message == "" ? null : authResponseHandler.message,
                  inputValueFun: (value) {
                    setState(() {
                      inputData = inputData.copyWith(password: value);
                    });
                  },
                  submitOnKey: formSubmit,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: formSubmit,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(18.0),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0))),
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
                        text:
                            "Don't have an account? Join us as out Driving Partner ",
                        linkText: "here",
                        link: () => widget.routeChange("registerDriver")),
                    const SizedBox(
                      height: 20.0,
                    ),
                    HyperLink(
                        text: "Don't have an account? Sign up as a Customer ",
                        linkText: "here",
                        link: () => widget.routeChange("registerCustomer")),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void formSubmit() {
    _formKey.currentState?.validate();
    widget.onLogin(inputData);
  }
}
