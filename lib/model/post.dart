//Aida Mumin
//CSC 4360 - Umoja
//July 3, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String content; // The typed message or the url of the image
  final Timestamp createdAt; // Timestamp of message
  final String creator;
  int type;

  Post(
      {required this.id,
      required this.content,
      required this.type,
      required this.createdAt,
      required this.creator});

  factory Post.fromJson(String id, Map<String, dynamic> data) {
    return Post(
        id: id,
        content: data["content"],
        type: data["type"] ?? 0,
        createdAt: data["createdAt"],
        creator: data["creator"]);
  }

  Map<String, dynamic> toJSON() {
    return {"content": content, "type": type ,"createdAt": createdAt, "creator": creator};
  }
}