//Aida Mumin
//CSC 4360 - Umoja
//June 29, 2022
//Streams of Thoughts

import 'dart:html';

import 'package:streams_of_thoughts/pages/auth.dart';
import 'package:streams_of_thoughts/pages/auth.dart';
import 'package:streams_of_thoughts/model/user.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.observedUser.name)),
      body: Center(
        child: Text(widget.observedUser.bio)
      ),
    );
  }
}