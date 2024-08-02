import 'package:flutter/material.dart';
import 'package:travel_mate/functions/capitalize.dart';
import 'package:travel_mate/user_role.dart';

import '../../../main.dart';
import '../../FormInputs.dart';
import '../auth_dto.dart';
import '../hyperlink.dart';
import 'package:travel_mate/pages/auth/response_handler_dto.dart';

class RegisterPage extends StatefulWidget {
  Function(AuthDto) onRegister;
  Function(String) routeChange;
  UserRole role;
  ResponseHandler? responseHandler;

  RegisterPage({
    super.key,
    required this.onRegister,
    required this.routeChange,
    required this.role,
    required this.responseHandler,
  });

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  late AuthDto inputData;
  late ResponseHandler responseHandler;

  @override
  void initState() {
    inputData = AuthDto(
        email: "",
        name: "",
        password: "",
        checkPassword: "",
        role: userRoleFromJson(widget.role.name.toUpperCase()));
    responseHandler = ResponseHandler.init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RegisterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    responseHandler = widget.responseHandler!;
    if (responseHandler.detail == "Successfully Registered") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.findAncestorStateOfType<AppViewportState>()?.informUser('Successfully Registered');
        widget.routeChange("login");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Register as a ${capitalize(widget.role.name)}",
                  style: const TextStyle(
                      fontSize: 35.0, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 80.0,
            ),
            FormInputs(
              element: "name",
              errorText: checkError("name"),
              inputValueFun: (value) {
                setState(() {
                  inputData = inputData.copyWith(name: value);
                });
              },
            ),
            FormInputs(
              element: "email",
              errorText: checkError("email"),
              inputValueFun: (value) {
                setState(() {
                  inputData = inputData.copyWith(email: value);
                });
              },
            ),
            FormInputs(
              element: "password",
              obscureText: true,
              errorText: checkError("password"),
              inputValueFun: (value) {
                setState(() {
                  inputData = inputData.copyWith(password: value);
                });
              },
            ),
            FormInputs(
              element: "check password",
              obscureText: true,
              errorText: checkError("password"),
              inputValueFun: (value) {
                setState(() {
                  inputData = inputData.copyWith(checkPassword: value);
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    responseHandler = responseHandler.copyWith(
                        detail: "", description: "");
                  });
                  if (inputData.checkPassword == inputData.password) {
                    inputData = inputData.copyWith(checkPassword: null);
                    widget.onRegister(inputData);
                  } else {
                    setState(() {
                      responseHandler = responseHandler.copyWith(
                          detail: "Passwords do not match",
                          description: "Passwords do not match");
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0))),
                child: const Text(
                  "Register",
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
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperLink(
                      text: "Already have an account? ",
                      linkText: "Login",
                      link: () => widget.routeChange("login")),
                  const SizedBox(
                    height: 20.0,
                  ),
                  HyperLink(
                      text:
                          "Sign up as a ${widget.role.name == "customer" ? "Driver" : "Customer"} ",
                      linkText: "here!",
                      link: () => widget.routeChange(
                          widget.role.name == "customer"
                              ? "registerDriver"
                              : "registerCustomer")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String? checkError(identifier) {
    if (responseHandler.detail != null &&
        responseHandler.detail!.toLowerCase().contains(identifier)) {
      return responseHandler.detail;
    }
    return null;
  }
}
