import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  // updating the userdata
  final CollectionReference userCollection=FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection=FirebaseFirestore.instance.collection('groups');

  // update the userdata
  Future updateUserData(String username,String email)async{
    return await userCollection.doc(uid).set({
      "username":username,
      "email":email,
      "group":[],
      "profilePic":"",
      "uid":uid,
    });
  }
}