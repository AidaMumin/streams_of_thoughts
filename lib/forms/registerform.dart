//Aida Mumin
//CSC 4360 - Umoja
//July, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/pages/auth.dart';
import 'package:streams_of_thoughts/pages/home.dart';
import 'package:streams_of_thoughts/style/style.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _email,
            decoration: inputDecorating("Please Input Email"),
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
            decoration: inputDecorating("Input Password Please"),
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
          TextFormField(
            controller: _username,
            decoration: inputDecorating("Input Username Please"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Username cannot be empty";
              }
              return null;
            },
          ),
          TextFormField(
            controller: _bio,
            decoration: inputDecorating("Input Biography Please"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Biography cannot be empty";
              }
              return null;
            },
          ),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  register();
                });
              },
              child: const Text("SIGN UP")),
          OutlinedButton(
              onPressed: () {
                setState(() {
                  loading = true;
                  moveToLogin();
                });
              },
              child: const Text("LOGIN")),
        ],
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential responseR = await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);

        _db
            .collection("users")
            .doc(responseR.user!.uid)
            .set({
              "Name": _username.text,
              "Bio": _bio.text,
              "Verified": false,
              "Created": Timestamp.now()
            })
            .then((value) => snackBar(context, "Welcome to the Site, new user!"))
            .then((value) => moveToHome())
            .catchError((error) => snackBar(context, "Failed to add user: $error"));

        responseR.user!.sendEmailVerification();
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  Future<void> moveToHome() async{
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
  }

  Future<void> moveToLogin() async{
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Auth()));
  }
}
