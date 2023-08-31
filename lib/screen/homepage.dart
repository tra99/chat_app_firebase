import 'package:chat_app_new_version/helper/heper_function.dart';
import 'package:chat_app_new_version/screen/group_widget.dart';
import 'package:chat_app_new_version/screen/login.dart';
import 'package:chat_app_new_version/screen/profile_screen.dart';
import 'package:chat_app_new_version/screen/search.dart';
import 'package:chat_app_new_version/service/auth.dart';
import 'package:chat_app_new_version/service/database_service.dart';
import 'package:chat_app_new_version/widget/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? group;
  bool _isLoading=false;
  String groupName="";

  String getId(String res){
    return res.substring(0,res.indexOf("_"));
  }
  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                changeScreenReplacement(context, const SearchScreen());
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "GIC Chat",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.account_circle,
                size: 120,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                changeScreenReplacement(
                    context, ProfileScreen(email: email, userName: userName));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Log Out",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: ((context,setState){
            return AlertDialog(
              title: const Text(
                "Create a group",style: TextStyle(color: Color.fromARGB(255, 244, 146, 240),fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading==true? Center(child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),): TextField(
                    onChanged: (value){
                      setState(() {
                        groupName=value;
                      });
                    },
                    style: const TextStyle(color: Color.fromARGB(255, 244, 146, 240)),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor
                        ),
                        borderRadius: BorderRadius.circular(20),
                      )
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text("Cancel"),style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor
                ),),
                ElevatedButton(onPressed: ()async{
                  if(groupName!=""){
                    setState(() {
                      _isLoading=true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(userName, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                      _isLoading=false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(context, Colors.green, "Group created seccessfully.");
                  }
                }, child: const Text("Create"),style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor
                ),),
              ],
              );}
            ),
          );
        }
        );
  }

  groupList() {
    return StreamBuilder(
        stream: group,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data["groups"] != null) {
              if (snapshot.data["groups"].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data["groups"].length,
                  itemBuilder: (context,index){
                    return GroupWidget(groupId: getId(snapshot.data["groups"][index]), groupName: getName(snapshot.data["groups"][index]), userName: snapshot.data["username"]);
                  },
                );
              }
            }
            return noGroupWidget();
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              color: Color.fromARGB(255, 244, 146, 240),
              size: 80,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You haven't joined any group yet, tap the icon to create a group or search group to join!",
             style: TextStyle(color: Color.fromARGB(255, 244, 146, 240),fontSize: 16,fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
