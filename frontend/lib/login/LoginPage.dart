import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function(String p1, String p2) onLogin;

  const LoginPage({
    super.key,
    required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // final TextEditingController _textEditingController = TextEditingController();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400.0),
             child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "E-mail",
                  ),
                  onChanged: (value) => setState(() {
                    _email = value;
                  }),
                  // controller: _textEditingController,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password"
                  ),
                  onChanged: (value) => setState(() {
                    _password = value;
                  }),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () { widget.onLogin(_email, _password)
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
                )
              ],
            ),
      ),
    );
  }
}
