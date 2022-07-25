//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:streams_of_thoughts/model/conversation.dart';
import 'package:streams_of_thoughts/model/message.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';
import 'package:streams_of_thoughts/style/style.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.conversation, required this.name}) : super(key: key);
  final Conversation conversation;
  final String name;
  final FirestoreService _fs = FirestoreService();
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(children: [
        Text(name),
        RatingBar.builder(
          itemCount: 5,
          onRatingUpdate: (value) {},
          itemBuilder: (BuildContext context, int index) {
            return const Icon(Icons.star, color: Colors.cyan
            );
          },
        ),
      ])
      ),
      body: SafeArea(
          child: Column(
        children: [_messagingArea(context), _inputArea(context)],
      )),
    );
  }

  Widget _messagingArea(BuildContext context) {
    return Expanded(
        child: Container(
            color: Colors.blueAccent,
            width: screenWidth(context),
            child: StreamBuilder<List<Message>>(
              stream: _fs.messages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messages = [];
                  for(var message in snapshot.data!){
                    if(message.conId == conversation.id){
                      messages.add(message);
                    }
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                    bool me = messages[index].fromId == _fs.getUserId();
                    return Container(
                        color: me ? Colors.amberAccent : Colors.cyan,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                                messages[index].content,
                                textAlign:me ? TextAlign.right : TextAlign.left)));
                  });
                } else {
                  return const Center(child: Text("No Messages yet"));
                }
              },
            )));
  }

  Widget _inputArea(BuildContext context) {
    return Container(
      color: Colors.amber,
      width: screenWidth(context),
      child: Row(children: [
        const SizedBox(width: 20),
        Expanded(child: TextField(controller: _message, minLines: 1, maxLines: 3)),
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.send))
      ]),
    );
  }

  void sendMessage(){
    if(_message.text.isNotEmpty){
      _fs.addMessage(_message.text, conversation);
      _message.clear();
    }
  }
}