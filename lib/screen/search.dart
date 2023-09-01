import 'package:chat_app_new_version/helper/heper_function.dart';
import 'package:chat_app_new_version/screen/chat_screen.dart';
import 'package:chat_app_new_version/screen/homepage.dart';
import 'package:chat_app_new_version/service/database_service.dart';
import 'package:chat_app_new_version/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading=false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearch=false;
  String userName="";
  User? user;
  bool isJoined=false;

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  getCurrentUserIdandName()async{
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName=value!;
      });
    });
    user =FirebaseAuth.instance.currentUser;
  }
  
  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            changeScreen(context, const HomeScreen());
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row( // Use Row to keep TextField and Icon in the same row
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search a group ....",
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 244, 146, 240)),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 244, 146, 240).withOpacity(0.5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10), 
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          _isLoading ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ):groupList(),
        ],
      ),
    );
  }
  initiateSearchMethod()async{
    if(searchController.text.isNotEmpty){
      setState(() {
        _isLoading=true;
      });
      await DatabaseService().searchByName(searchController.text).then((snapshot){
        setState(() {
          searchSnapshot= snapshot;
          _isLoading=false;
          hasUserSearch=true;
        });
      });
    }
  }
  groupList(){
    return hasUserSearch?ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot!.docs.length,
      itemBuilder: (context, index) {
        return groupTile(
          userName,
          searchSnapshot!.docs[index]["groupId"],
          searchSnapshot!.docs[index]["groupName"],
          searchSnapshot!.docs[index]["admin"],
        );
      },
    ):Container();
  }
  Widget groupTile(String userName,String groupId,String groupName,String admin){
    // function to check whether user already exists in group
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0,1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white
            ),
        ),
      ),
      title: Text(groupName,style: const TextStyle(fontWeight: FontWeight.bold),),
      subtitle: Text('Admin: ${getName(admin)}'),
      trailing: InkWell(
        onTap: () async{
          await DatabaseService(uid: user!.uid).togglingGroupJoin(groupId, userName, groupName);
          if(isJoined){
            setState(() {
              isJoined=!isJoined;
            });
            showSnackbar(context, Colors.green, "You have joined the group $groupName");
            Future.delayed(const Duration(seconds: 2),(){
              changeScreen(context, ChatPage(groupId: groupId, groupName: groupName, userName: userName));
            });
          }else{
            setState(() {
              isJoined=!isJoined;
              showSnackbar(context, Colors.red, "$userName left the group");
            });
          }
        },
        child: isJoined?Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 193, 46, 36),
            border: Border.all(color: Colors.white,width: 1)
          ),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: const Text('Joined',style: TextStyle(color: Colors.white),),
        )
        :Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text('Join',style: TextStyle(color: Colors.white),),
        )
      ),
    );
  }
  joinedOrNot(String userName,String groupId,String groupName,String admin)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined=value;
      });
    });
  }
}
