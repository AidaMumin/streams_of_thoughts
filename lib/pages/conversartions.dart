//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/pages/create_conversartion.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateConversationsPage()));
          }, icon: const Icon(Icons.add)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        ],
      ),
      body: const Center(child: Text("Incoming Messages")),
    );
  }
}