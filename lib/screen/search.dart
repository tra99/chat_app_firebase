import 'package:chat_app_new_version/helper/heper_function.dart';
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
                const SizedBox(width: 10), // Add spacing between TextField and Icon
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
    return Text("Hello");
  }
}
