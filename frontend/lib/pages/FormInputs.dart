import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux_example/functions/capitalize.dart';

class FormInputs extends StatelessWidget {

  String? element;
  Function(String)? inputValueFun;

  FormInputs({this.element, this.inputValueFun});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [TextFormField(
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