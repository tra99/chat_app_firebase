import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});

  // reference collections
  final CollectionReference userCollection=FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection=FirebaseFirestore.instance.collection('groups');

  // saving the userdata
  Future savingUserData(String username,String email)async{
    return await userCollection.doc(uid).set({
      "username":username,
      "email":email,
      "group":[],
      "profilePic":"",
      "uid":uid,
    });
  }

  //getting user data
  Future gettingUserData(String email)async{
    QuerySnapshot snapshot=await userCollection.where(
      "email",isEqualTo: email
    ).get();
    return snapshot;
  }
}