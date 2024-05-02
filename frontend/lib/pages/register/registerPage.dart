import 'package:flutter/material.dart';

import '../FormInputs.dart';

class RegisterPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onRegister;
  final Function() routeChange;

  const RegisterPage({
    super.key,
    required this.onRegister,
    required this.routeChange
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
    "check password" : ""
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
                onPressed: () { widget.onRegister(inputs)
                ; },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(18.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Already have an account?"),
                const SizedBox(width: 20.0),
                ElevatedButton(
                    onPressed: (){
                      widget.routeChange();
                    },
                    child: Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}

