//Aida Mumin
//CSC 4360 - Umoja
//June 29, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/forms/loginform.dart';
import 'package:streams_of_thoughts/forms/registerform.dart';

class Auth_2 extends StatelessWidget {
  const Auth_2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication"),
        ),
        body: const RegisterForm());
  }

}