//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/pages/auth.dart';
import 'package:streams_of_thoughts/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Driver extends StatefulWidget {
  const Driver({Key? key}) : super(key: key);

  @override
  State<Driver> createState() => _State();
}

class _State extends State<Driver> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
      return _auth.currentUser == null 
      ? const Auth()
      : const Home();
  }
}