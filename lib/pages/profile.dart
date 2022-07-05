//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/model/user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.observedUser}) : super(key: key);

  final User observedUser;

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.observedUser.name)),
        body: Center(child: Text(widget.observedUser.bio),),
      );
  }
}