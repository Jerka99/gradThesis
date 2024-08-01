import 'package:flutter/material.dart';
import 'package:travel_mate/functions/capitalize.dart';

class FormInputs extends StatelessWidget {

  String? element;
  Function(String)? inputValueFun;
  bool obscureText;

  FormInputs({super.key, this.element, this.inputValueFun, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [TextFormField(
          obscureText: obscureText,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: capitalize(element!)
            ),
            onChanged: (value) => inputValueFun!(value)
        ),
          const SizedBox(
            height: 30.0,
          ),]
    );
  }
}