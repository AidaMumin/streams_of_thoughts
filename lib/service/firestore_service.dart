//Aida Mumin
//CSC 4360 - Umoja
//July 4, 2022
//Streams of Thoughts

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:streams_of_thoughts/model/conversation.dart';
import 'package:streams_of_thoughts/model/message.dart';
import 'package:streams_of_thoughts/model/post.dart';
import 'package:streams_of_thoughts/model/user.dart';

class FirestoreService {
  final fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  static Map<String, User> userMap = {};
  static Map<String, Post> postMap = {};

  final Map<String, Conversation> _conversations = {};
  final Map<String, Message> _messages = {};

  String getUserId(){
    return _auth.currentUser!.uid;
  }

  final usersCollection = FirebaseFirestore.instance.collection("users");
  final postsCollection = FirebaseFirestore.instance.collection("posts");
  final conversationsCollection = FirebaseFirestore.instance.collection("conversations");
  final userConversationsCollection = FirebaseFirestore.instance.collection("user_conversations");
  final messagesCollection = FirebaseFirestore.instance.collection("messages");

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();
  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();
  final StreamController<List<Conversation>> _userConversationsController =
      StreamController<List<Conversation>>();
  final StreamController<List<Conversation>> _conversationsController =
      StreamController<List<Conversation>>();
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>();

  Stream<Map<String, User>> get users => _usersController.stream;
  Stream<List<Post>> get post => _postsController.stream;
  Stream<List<Conversation>> get userConversations => _userConversationsController.stream;
  Stream<List<Message>> get messages => _messagesController.stream;
  

  FirestoreService() {
    usersCollection.snapshots().listen(_usersUpdated);
    postsCollection.snapshots().listen(_postsUpdated);
    messagesCollection.snapshots().listen(_messagesUpdated);
    conversationsCollection.snapshots().listen(_conversationsUpdated);
  }

  void setUserConversation(){
    userConversationsCollection.doc(_auth.currentUser!.uid).snapshots().listen(_userConversationsUpdated);
  }

  void setConvoMessages(String convoId){
    messagesCollection.where("conversationId", isEqualTo: convoId).snapshots().listen(_messagesUpdated);
  }

  Stream<List<Message>> convoMessages(){
    return _messagesController.stream;
  }

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    Map<String, User> users = _getUserFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = _getMessagesFromSnapshot(snapshot);
    _messagesController.add(messages);
  }

  void _conversationsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = _getConversationsFromSnapshot(snapshot);
    _conversationsController.add(conversations);
  }

  void _userConversationsUpdated(DocumentSnapshot<Map<String, dynamic>> snapshot) {
   List<Conversation> userConversation = _getUserConsFromSnapshot(snapshot);
   _userConversationsController.add(userConversation);
  }

  Map<String, User> _getUserFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var doc in snapshot.docs) {
      User user = User.fromJson(doc.id, doc.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  List<Post> _getPostsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var doc in snapshot.docs) {
      Post post = Post.fromJson(doc.id, doc.data());
      posts.add(post);
      postMap[post.id] = post;
    }
    return posts;
  }

  List<Message> _getMessagesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = [];
    for (var doc in snapshot.docs) {
      Message message = Message.fromJson(doc.id, doc.data());
      messages.add(message);
      _messages[message.id] = message;
    }
    return messages;
  }

  List<Conversation> _getConversationsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Conversation> conversations = [];
    for (var doc in snapshot.docs) {
      Conversation convo = Conversation.fromJson(doc.id, doc.data());
      _conversations[convo.id] = convo;
      conversations.add(convo);
    }
    return conversations;
  }

  Conversation? getConversationBy(String id){
    return _conversations[id];
  }

  List<Conversation> _getUserConsFromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot){
    List<Conversation> conversations = [];
    if (snapshot.data() != null) {
      for (var key in snapshot.data()!.keys) {
        if(_conversations.containsKey(key)){
          conversations.add(_conversations[key]!);
        }
      }
    }

    return conversations;
  }

  Future<bool> addConversation(List<String> users) async{
    users.add(_auth.currentUser!.uid);
    var data = Conversation(id: "", users: users, createdAt: Timestamp.now());
    try{
      var result = await conversationsCollection.add(data.toJSON());
      for(var user in users){
        userConversationsCollection.doc(user).set({result.id : 1}, SetOptions(merge: true));
      }
      return true;
    } catch (e){
      return false;
    }
  }

  Future<bool> addMessage(String content, Conversation conversation) async{
    var data = Message(
        id: "",
        content: content,
        type: 0,
        conId: conversation.id,
        fromId: _auth.currentUser!.uid,
        createdAt: Timestamp.now());
    try{
      var result = await messagesCollection.add(data.toJSON());
      await conversationsCollection
          .doc(conversation.id)
          .update(Conversation(
          id: conversation.id,
          users: conversation.users,
          createdAt: conversation.createdAt,
          lastMessage: result.id
          ).toJSON());
      return true;
    } catch (e){
      return false;
    }
  }
}
