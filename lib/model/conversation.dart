//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> users;
  final Timestamp createdAt; 
  final String? lastMessage;

  Conversation(
      {required this.id,
      required this.users,
      required this.createdAt,
      this.lastMessage});

  factory Conversation.fromJson(String id, Map<String, dynamic> data) {
    List<String> users = [];
    if (data["users"] != null){
      var userData = data["users"] as List<dynamic>;
      for(var user in userData){
        users.add(user as String);
      }
    }

    return Conversation(
        id: id,
        users: users,
        createdAt: data["create_at"],
        lastMessage: data["lastMessage"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "users": users, 
      "create_at": createdAt, 
      "lastMessage": lastMessage};
  }
}
