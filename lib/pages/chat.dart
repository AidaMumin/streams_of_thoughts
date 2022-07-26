//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path/path.dart';
import 'package:streams_of_thoughts/model/conversation.dart';
import 'package:streams_of_thoughts/model/message.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';
import 'package:intl/intl.dart';
import 'package:streams_of_thoughts/style/style.dart';

class ChatPage extends StatelessWidget {
  ChatPage({Key? key, required this.conversation, required this.name}) : super(key: key);
  final Conversation conversation;
  final String name;
  final FirestoreService _fs = FirestoreService();
  final TextEditingController _message = TextEditingController();
  static Map<String, double> rating = {};
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: RatingBar.builder(
          itemCount: 5,
          allowHalfRating: true,
          onRatingUpdate: (value) {
            _ratingUpdated(conversation.id, value);
          },
          initialRating: rating.isEmpty ? 0 : rating[conversation.id]!,
          itemBuilder: (BuildContext context, int index) {
            return const Icon(Icons.star, color: Colors.cyan);
          },
        ),
      ),
      appBar: AppBar(
          title: Text(name),
          actions: [TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            child: const Text("Close", style: TextStyle(color: Colors.white)))],),
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
                  for (var message in snapshot.data!) {
                    if (message.conId == conversation.id) {
                      messages.add(message);
                    }
                  }
                  return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        bool me = messages[index].fromId == _fs.getUserId();
                        return Container(
                            color: me ? Colors.amberAccent : Colors.cyanAccent,
                            child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children:[
                                      Text(
                                          FirestoreService
                                              .userMap[messages[index].fromId]!
                                              .name,
                                          textAlign: me
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),     
                                      Text(messages[index].content,
                                          textAlign: me
                                              ? TextAlign.right
                                              : TextAlign.left),
                                      Text(
                                          DateFormat('MM/dd/yyyy hh:MM a')
                                              .format(messages[index]
                                                  .createdAt
                                                  .toDate()),
                                          textAlign: me
                                              ? TextAlign.right
                                              : TextAlign.left)
                                    ])));
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

  void _ratingUpdated(String convoId, double rate) {
    if (rating.containsKey(convoId)) {
      rating[convoId] = (rate + rating[convoId]!) / 2;
    } else {
      rating[convoId] = rate;
    }
  }
}
