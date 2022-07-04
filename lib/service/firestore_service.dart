//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/model/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();
  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();

      Stream<Map<String, User>> get users => _usersController.stream;
      Stream<List<Post>> get post => _postsController.stream;
      FirestoreService(){
        _db.collection("users").snapshots().listen(_usersUpdated);
        _db.collection("post").snapshots().listen(_postsUpdated);
      }

      void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot){
        Map<String, User> users = _getUserFromSnapshot(snapshot);
            _usersController.add(users);
      }

      void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot){
        List<Post> posts = _getPostFromSnapshot(snapshot);
        _postsController.add(posts);
      }

      Map<String, User> _getUserFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot){
        Map<String, User> userMap = {};
        for(var doc in snapshot.docs){
          User user = User.fromJson(doc.id, doc.data());
          userMap[user.id] = user;
        }
        return userMap;
      }

      List<Post> _getPostFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot){
        List<Post> posts = [];

        for(var doc in snapshot.docs){
          Post post = Post.fromJson(doc.id, doc.data());
          posts.add(post);
        }

        return posts;
      }
}
