//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/widgets/loading.dart';

class PostForm extends StatefulWidget {
  const PostForm({Key? key}) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final TextEditingController _content = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _content,
            minLines: 5,
            maxLines: 5,
          ),
          OutlinedButton(
              onPressed: _submitPost, child: const Text("Submit Post"))
        ],
      ),
    ),
    );
  }

  void _submitPost() {
    _db.collection("posts").add(Post(
            id: "",
            content: _content.text,
            createdAt: Timestamp.now(),
            creator: _auth.currentUser!.uid)
        .toJSON()).then((value) => Navigator.of(context).pop());

    
  }
}
