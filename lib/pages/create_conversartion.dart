//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/model/user.dart';
import 'package:streams_of_thoughts/pages/conversartions.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';
import 'package:streams_of_thoughts/style/style.dart';

class CreateConversationsPage extends StatefulWidget {
  const CreateConversationsPage({Key? key}) : super(key: key);

  @override
  State<CreateConversationsPage> createState() => _CreateState();
}

class _CreateState extends State<CreateConversationsPage> {
  FirestoreService _fs = FirestoreService();
  List<User> userList = FirestoreService.userMap.values.toList();
  List<User> filterList = [];
  List<String> recipients = [];
  String search = "";

  @override
  void initState(){
    super.initState();
    userList.remove(FirestoreService.userMap[_fs.getUserId()]);
    userList.sort(((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));
    filterList = userList;
  }

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
      body: Column(children:[
        TextField(onChanged: (value){
          List<User> temp = [];
          for(var user in userList){
            if(user.name.toLowerCase().contains(value.toLowerCase())){
              temp.add(user);
            }
          }
          
          setState(() {
            filterList = temp;
          });
        }),
        SizedBox(
          height: 30,
          width: screenWidth(context),child:
        ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recipients.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
            child: Text(FirestoreService.userMap[recipients[index]]!.name),
            );
          }),),
        Expanded(child:
        ListView.builder(
          itemCount: filterList.length,
          itemBuilder: (BuildContext context, int index) {
            var added = recipients.contains(filterList[index].id);
            return ListTile(
              title: Text(filterList[index].name),
              trailing: added
                  ? const Icon(
                      Icons.verified,
                      color: Colors.cyan,
                    )
                  : null,
              onTap: () {
                setState(() {
                  if (added) {
                    recipients.remove(filterList[index].id);
                  } else {
                    recipients.add(filterList[index].id);
                  }
                });
              },
            );
          })),
    ]));
  }

  void createConversation() async{
    FirestoreService _fs = FirestoreService();
    
    _fs.addConversation(recipients);
    Navigator.of(context).pop();
  }
}
