//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:streams_of_thoughts/forms/postform.dart';
import 'package:streams_of_thoughts/main.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/model/user.dart';
import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fbAuth.FirebaseAuth _auth = fbAuth.FirebaseAuth.instance;
  final FirestoreService _fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _showPostField, child: const Icon(Icons.post_add)),
        body: StreamBuilder<List<Post>>(
          stream: _fs.post,
          builder:
              (BuildContext context, AsyncSnapshot<List<Post>> snapshots) {
            if (snapshots.hasError) {
              return Center(child: Text(snapshots.error!.toString()));
            } else if (snapshots.hasData) {
              var posts = snapshots.data!;
              return posts.isEmpty
                  ? const Center(child: Text("No Post Yet"))
                  : ListView.builder(
                    itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                            title: Text(posts[index].content),
                            subtitle: Text(posts[index].creator),
                          ));
            }
            return const Loading();
          },
        ));
  }

  void _showPostField() {
    showModalBottomSheet<void>(
        context: context,
        builder: (context) {
          return const PostForm();
        });
  }
}
