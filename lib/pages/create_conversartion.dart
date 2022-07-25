//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/model/user.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';

class CreateConversationsPage extends StatefulWidget {
  const CreateConversationsPage({Key? key}) : super(key: key);

  @override
  State<CreateConversationsPage> createState() => _CreateState();
}

class _CreateState extends State<CreateConversationsPage> {
  List<User> userList = FirestoreService.userMap.values.toList();
  List<String> recipients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Messages"),
        actions: recipients.isEmpty ? [] : [
          IconButton(
            onPressed: createConversation, 
            icon: const Icon(Icons.create))
          ],
      ),
      body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (BuildContext context, int index) {
            var added = recipients.contains(userList[index].id);
            return ListTile(
              title: Text(userList[index].name),
              trailing: added
                  ? const Icon(
                      Icons.verified,
                      color: Colors.cyan,
                    )
                  : null,
              onTap: () {
                setState(() {
                  if (added) {
                    recipients.remove(userList[index].id);
                  } else {
                    recipients.add(userList[index].id);
                  }
                });
              },
            );
          }),
    );
  }

  void createConversation() async{
    FirestoreService _fs = FirestoreService();
    
    _fs.addConversation(recipients);
  }
}
