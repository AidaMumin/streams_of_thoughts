//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/model/conversation.dart';
import 'package:streams_of_thoughts/pages/chat.dart';
import 'package:streams_of_thoughts/pages/create_conversartion.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  State<ConversationsPage> createState() => _ConversationsState();
}

class _ConversationsState extends State<ConversationsPage>{
  final FirestoreService _fs = FirestoreService();
  @override
  void initState(){
    super.initState();
    _fs.setUserConversation();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateConversationsPage()));
          }, icon: const Icon(Icons.add)),
        ],
      ),
      body: StreamBuilder<List<Conversation>>(
        stream: _fs.userConversations,
        builder: (BuildContext context, AsyncSnapshot<List<Conversation>> snapshot){
          if(snapshot.hasData){
            List<Conversation> convos = snapshot.data!;
            return convos.isEmpty
                  ? Text(_fs.getUserId())
                  : ListView.builder(
                      itemCount: convos.length,
                      itemBuilder: (BuildContext context, int index) {


                        return ListTile(title: Text(conversationName(convos[index])),
                        onTap: () => goToConversation(convos[index]),
                        );
                      });
          } else {
            return const Center(child: Text("No messages"));
          }
      }),
    );
  }

  String conversationName(Conversation convo){
    var convoName = '';
    for(var user in convo.users){
      if(user != _fs.getUserId()){
        if(convoName.isEmpty){
          convoName = FirestoreService.userMap[user]!.name;
        } else {
          convoName += ', ${FirestoreService.userMap[user]!.name}';
        }//
      }
    }
    return convoName;
  }

  void goToConversation(Conversation convo) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            ChatPage(conversation: convo, name: conversationName(convo))));
  }
}