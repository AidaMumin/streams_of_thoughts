//Aida Mumin
//CSC 4360 - Umoja
//July 25, 2022
//Streams of Thoughts

import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:flutter/material.dart';
import 'package:streams_of_thoughts/service/firestore_service.dart';
import 'package:streams_of_thoughts/pages/create_conversartion.dart';

class searchingDelegate extends SearchDelegate {
  final FirestoreService _fs = FirestoreService();
  final fba.FirebaseAuth _auth = fba.FirebaseAuth.instance;
  List<String> listUsers = addUsersToList();
  List<String> listUsersId = addUsersIdToList();
  List<String> recipients = [];
  
  static List<String> addUsersToList() {
    List<String> list = [];
    for (var users in FirestoreService.userMap.entries) {
      list.add(FirestoreService.userMap[users.value.id]!.name.toString());
    }
    return list;
  }

  static List<String> addUsersIdToList() {
    List<String> list = [];
    for (var users in FirestoreService.userMap.entries) {
      list.add(FirestoreService.userMap[users.value.id]!.id.toString());
    }
    return list;
  }
 
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if(query.isNotEmpty){
            query = '';
          } else {
            close(context, null);
          }
        }, 
        icon: const Icon(Icons.clear)
        )
    ];
  }
 
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  void createConversation() async {
    print("hELLO: "+ recipients.toString());
    _fs.addConversation(recipients);
  }
  
 
  @override
  Widget buildResults(BuildContext context) {
    print(recipients);
    _fs.addConversation(recipients);
    recipients.clear();
    return Center(child: Text("Conversation add. Return to eariler page."));
  }
 
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matches = [];
    for(var index = 0; index < listUsers.length; index++){
      if(listUsers[index].toUpperCase() == query.toUpperCase()){
        matches.add(listUsersId[index]);
      }
    }

    return query.isEmpty ? 
    ListView.builder(
      itemCount: listUsers.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(listUsers[index]),
          onTap: (){
                  if (recipients.length <= 1) {
                    recipients.clear();
                    query = listUsers[index];
                    recipients.add(listUsersId[index]);
                    //showResults(context);
                  } else {
                    query = listUsers[index];
                    recipients.add(listUsersId[index]);
                    //showResults(context);
                  }
          },
        );
      },
    ) :
    ListView.builder(
      itemCount: matches.length,
      itemBuilder:(context, index){
        print("Matches: " + recipients.toString());
        if(recipients.contains(matches[index])){
          recipients.remove(matches[index]);
        } else {
          recipients.add(matches[index]);
        }
        return ListTile(
          title: Text(matches[index]),
          onTap:(){
            if(recipients.contains(matches[index])){
              query = matches[index];
              showResults(context);
            } else{
              query = matches[index];
              recipients.add(matches[index]);
              showResults(context);
            }
          }
        );
        
      }
    )
    ;
  }
}