//Aida Mumin
//CSC 4360 - Umoja
//July 3, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:streams_of_thoughts/main.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/model/user.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _postStream;
  final List<Post> _posts = [];
  List<User> users = [];

  @override
  void initState() {
    super.initState();

    _postStream = _db.collection("posts").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(onPressed: _showPostField,
        child: const Icon(Icons.post_add)),
        body: StreamBuilder(
          stream: _postStream,
          builder: 
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshots){
              if(snapshots.hasError){
                return Center(child: Text(snapshots.error!.toString()));
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
              return const Loading();
            },
    ));
  }

  void _showPostField() {
  }
}