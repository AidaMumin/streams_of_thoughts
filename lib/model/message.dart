//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final int type; 
  final Timestamp createdAt; 
  final String fromId;
  final String conId;

  Message(
      {required this.id,
      required this.content,
      required this.type,
      required this.createdAt,
      required this.fromId,
      required this.conId});

  factory Message.fromJson(String id, Map<String, dynamic> data) {
    return Message(
        id: id,
        content: data["content"],
        type: data["type"] ?? 0,
        createdAt: data["createdAt"],
        fromId: data["fromId"],
        conId: data["conversationId"]);
  }

  Map<String, dynamic> toJSON() {
    return {
      "content": content, 
      "type": type,
      "createdAt": createdAt, 
      "fromId": fromId,
      "conversationId": conId};
  }
}
