import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

//Aida Mumin
//CSC 4360 - Umoja
//June 22, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';

import '../main.dart';

class Auth extends StatefulWidget {
  Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication"),
        ),
        body: loading
            ? const Loading()
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          labelText: "Input Email Please"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty.";
                        } else if (!value.contains('@')) {
                          return "Email must be in the correct format.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(
                          labelText: "Input Password Please"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        } else if (value.length < 8) {
                          return "Password must be 8 or more characters long.";
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    OutlinedButton(onPressed: login,child: Text("LOGIN")),
                    OutlinedButton(onPressed: (){
                      setState(() {
                        register();
                      });
                    }, child: Text("SIGN UP")),
                    OutlinedButton(
                        onPressed: () {}, child: Text("FORGOT PASSWORD")),
                  ],
                )));
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try{
        var responseR = await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);
      } catch(e) {}
      setState(() {
        loading = true;
      });
    }
  }

    void login() {
    if (_formKey.currentState!.validate()) {
      _auth
          .signInWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .whenComplete(() => setState(() {
                loading = false;
                _email.clear();
              }));
      setState(() {
        loading = true;
      });
    }
  }
}
