import 'package:flutter/material.dart';
import 'package:redux_example/functions/capitalize.dart';
import 'package:redux_example/user_role.dart';

import '../../FormInputs.dart';
import '../hyperlink.dart';


class RegisterPage extends StatefulWidget {
  Function(Map<String, dynamic>) onRegister;
  Function(String) routeChange;
  UserRole role;

  RegisterPage({
    super.key,
    required this.onRegister,
    required this.routeChange,
    required this.role
  });

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  // final TextEditingController _textEditingController = TextEditingController();

  Map<String, dynamic> inputs = {
    "name" : "",
    "email" : "",
    "password" : "",
    "check password" : "",
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
             Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Register as a ${capitalize(widget.role.name)}",
                  style: const TextStyle(
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
                onPressed: () { widget.onRegister(inputs)
                ; },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)
                    )),
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
                      link:() => widget.routeChange("login")
                  ),
                  const SizedBox(height: 20.0,),
                  HyperLink(
                      text: "Sign up as a ${widget.role.name == "customer" ? "Driver" : "Customer"} ",
                      linkText: "here!",
                      link:() => widget.routeChange(widget.role.name == "customer" ? "registerDriver" : "registerCustomer")
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

