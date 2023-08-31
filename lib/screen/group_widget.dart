import 'package:flutter/material.dart';

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
    return ListTile(
      title: Text(widget.groupId),
      subtitle: Text(widget.groupName),
    );
  }
}
