//Aida Mumin
//CSC 4360 - Umoja
//July 15, 2022
//Streams of Thoughts

import 'package:streams_of_thoughts/forms/postform.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/pages/profile.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';
import 'package:streams_of_thoughts/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';

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
          actions: [
            IconButton(
              onPressed: (){
                logout(context);
              }, icon: const Icon(Icons.logout)),
          ],
          title: const Text("Home"),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: _showPostField, child: const Icon(Icons.post_add)),
        body: StreamBuilder<List<Post>>(
          stream: _fs.post,
          builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshots) {
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
                              title: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile(
                                                observedUser: FirestoreService
                                                        .userMap[
                                                    posts[index].creator]!)));
                                  },
                                  child: Text(FirestoreService.userMap[posts[index].creator]!.name)),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(posts[index].content),
                                    const SizedBox(height: 10),
                                    Text(posts[index]
                                        .createdAt
                                        .toDate()
                                        .toString())
                                  ])));
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


  
  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pop();
  }
}
