import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserController extends GetxController {
  FirebaseFirestore myFirestore = FirebaseFirestore.instance;
  GetStorage storage = GetStorage();
  
  /// Create new user document
  /// If user has exists and has family, get data family
  /// If user not exists, create new user
  /// This method will return bool. 
  /// [True] is meaning user has family, 
  /// [False] is meaning user not have family
  Future<bool> createNewUser() async {
    CollectionReference userCollection = myFirestore.collection('users');
    DocumentReference documentReferencer = userCollection.doc(storage.read("email"));
    DocumentSnapshot getUser = await documentReferencer.get(); // get user

    // if user exists
    if (!getUser.exists) {
      debugPrint("add new user ..");

      Map<String, dynamic> data = {
        "userId": storage.read("userId"),
        "email": storage.read("email"),
        "name": storage.read("name"),
        "familyName": ""
      };

      await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("User has been added.."))
        .catchError((e) => debugPrint(e));

      return false;
    } 
    // if user already exists
    else {
      debugPrint("user already exists!!, data user: ${getUser.data()}");

      dynamic userData = getUser.data();
      if (userData['familyName'] != null) {
        if (userData['familyName'] != "") {
          storage.write("familyName", userData['familyName']);
        }
      }

      // if googleId null (because invited from another family), update googleId
      if (userData['userId'] == "") {
        await documentReferencer
          .update({"userId": storage.read("userId"), "displayPic": storage.read("displayPic")})
          .whenComplete(() => debugPrint("User has been added.."))
          .catchError((e) => debugPrint(e));

        return true;
      }

      return false;
    }
  }
}