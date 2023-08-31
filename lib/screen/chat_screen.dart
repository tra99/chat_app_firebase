import 'package:chat_app_new_version/screen/group_info.dart';
import 'package:chat_app_new_version/service/database_service.dart';
import 'package:chat_app_new_version/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatScreen({Key? key,required this.groupId,required this.groupName,required this.userName}):super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Stream<QuerySnapshot>? chats;
  String admin="";

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }
  getChatandAdmin(){
    DatabaseService().getChats(widget.groupId).then((value){
      setState(() {
        chats=value;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((value){
      setState(() {
        admin=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            changeScreen(context, GroupInfo(adminName: widget.userName, groupName: widget.groupName, groupId: widget.groupId));
          }, icon: Icon(
            Icons.info
          ))
        ],
      ),
    );
  }
}