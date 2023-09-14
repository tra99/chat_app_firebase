
import 'package:flutter/material.dart';

import '../widget/widget.dart';
import 'chat_screen.dart';

class GroupWidget extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupWidget({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        changeScreen(context, ChatPage(
          groupId: widget.groupId,groupName: widget.groupName,userName: widget.userName,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0,1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,fontWeight: FontWeight.w400
              ),
            ),
          ),
          title: Text(widget.groupName,style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: const Text("Tab here to join conversation",style: TextStyle(fontSize: 14),),
        ),
      ),
    );
  }
}
