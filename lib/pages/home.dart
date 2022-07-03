//Aida Mumin
//CSC 4360 - Umoja
//July 3, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/model/user.dart' as m;
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _postStream;
  final List<Post> _posts = [];
  List<m.User> users = [];

  @override
  void initState() {
    super.initState();
    getList();
    getStreamList();

    _postStream = _db.collection("posts").snapshots();
  }

  void getStreamList() {
    _db.collection("users").snapshots().listen((snapshots) {
      for (var element in snapshots.docs) {
        setState(() {
          users.add(m.User.fromJson(element.id, element.data()));
        });
      }
    });
  }

  void getList() {
    _db.collection("users").get().then((result) {
      setState(() {
        for (var element in result.docs) {
          users.add(element.data()["name"]);
        }
      });
    });
  }

  void getList2() async {
    var result = await _db.collection("users").get();
    for (var element in result.docs) {
      users.add(element.data()["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: mainLightColor,
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: StreamBuilder(
          stream: _postStream,
          builder: 
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots){
              if(snapshots.hasError){
                return Center(child: Text("An Error has occurred"));
              } else if (snapshots.hasData){
                for(var post in snapshots.data!.docs){
                  _posts.add(Post.fromJson(post.id, post.data() as Map<String, dynamic>));
                }
                return _posts.isEmpty
                ? const Center(child: Text("No Post Yet"))
                : ListView.builder( 
                  itemBuilder: (BuildContext context, int index) => 
                  ListTile(title: Text(_posts[index].content)));
              }
              return Center(child: Text("This is Something"));
            },
    ));
  }
}