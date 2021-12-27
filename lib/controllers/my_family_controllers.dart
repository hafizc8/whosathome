import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFamilyController extends GetxController {
  FirebaseFirestore myFirestore = FirebaseFirestore.instance;
  TextEditingController newUserEmailC = TextEditingController();

  /// Add to family
  Future<void> addUserToFamilies({required String email}) async {
    String newUserEmail = newUserEmailC.text;
    String familiesName = email.replaceAll(" ", "") + "-family";

    CollectionReference familiesCollection = myFirestore.collection('families');
    DocumentReference documentReferencer = familiesCollection.doc(familiesName);
    DocumentSnapshot getFamily = await documentReferencer.get();

    // add new user to current family
    Map<String, dynamic> newUser = {"email": newUserEmail};
    Map<String, dynamic> myUser = {"email": email};
    
    List<Map<String, dynamic>> currentFamilies = [];
    // if family document not found, create new families with (current user + new user)
    if (getFamily.data() == null) {
      currentFamilies = [newUser, myUser];
    } 
    // if family document exist, just add new user
    else {
      currentFamilies = (getFamily.get('users') as List).map((e) => e as Map<String, dynamic>).toList();
      currentFamilies.add(newUser);
    }
    debugPrint("currentFamilies: ${currentFamilies.toString()}");

    await documentReferencer
      .set({"users": currentFamilies})
      .whenComplete(() => debugPrint("User has been added to $familiesName.."))
      .catchError((e) => debugPrint(e));


    // add families name in my user data
    CollectionReference userCollection = myFirestore.collection('users');
    if (!getFamily.exists) {
      DocumentReference docUser = userCollection.doc(email);
      docUser.update({"familyName": familiesName});
    }

    // add families name in new user data
    DocumentReference newDocUser = userCollection.doc(newUserEmail);
    newDocUser.update({"familyName": familiesName});
  }
}