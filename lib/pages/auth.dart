//Aida Mumin
//CSC 4360 - Umoja
//July 3, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/forms/loginform.dart';
import 'package:streams_of_thoughts/forms/registerform.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authentication"),
        ),
        body: const LoginForm());
  }

}
