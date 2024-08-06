import 'package:flutter/material.dart';
import 'package:travel_mate/functions/capitalize.dart';

class FormInputs extends StatelessWidget {

  String? element;
  Function(String)? inputValueFun;
  String? Function(String?)? checkValidity;
  bool obscureText;
  String? errorText;
  VoidCallback? submitOnKey;

  FormInputs({super.key, this.element, this.inputValueFun, this.checkValidity, this.obscureText = false, this.errorText, this.submitOnKey});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          TextFormField(
          obscureText: obscureText,
            validator: checkValidity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: capitalize(element!),
              errorText: errorText,
            ),
            onChanged: (value) => inputValueFun!(value),
            onFieldSubmitted: (_) => submitOnKey?.call(),
        ),
          const SizedBox(
            height: 30.0,
          ),]
    );
  }
}