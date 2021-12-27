import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whosathome/controllers/my_family_controllers.dart';
import 'package:whosathome/routes/app_pages.dart';

class MyAppControllers extends GetxController {
  FirebaseFirestore myFirestore = FirebaseFirestore.instance;
  
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
  );

  RxString displayName  = "".obs;
  RxString googleId     = "".obs;
  RxString email        = "".obs;
  RxString displayPic   = "".obs;
  RxString familyName   = "".obs;

  /// google sign in and save user info
  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        displayName.value = googleAccount.displayName ?? "Unknow";
        googleId.value = googleAccount.id;
        email.value = googleAccount.email;
        displayPic.value = googleAccount.photoUrl ?? "https://i.pravatar.cc/150?img=2";

        await addUsers();

        Get.offAndToNamed(Routes.home);
      }
    } catch (error) {
      debugPrint("ada error sign in google");
      debugPrint(error.toString());
    }
  }

  /// Add user to firebase if never resigter
  Future<void> addUsers() async {
    CollectionReference userCollection = myFirestore.collection('users');
    DocumentReference documentReferencer = userCollection.doc(email.value);
    DocumentSnapshot getUser = await documentReferencer.get(); // get user

    if (!getUser.exists) {
      debugPrint("add new user ..");
      Map<String, dynamic> data = <String, dynamic>{
        "userId": googleId.value,
        "email": email.value,
        "name": displayName.value,
        "familyName": ""
      };

      await documentReferencer
        .set(data)
        .whenComplete(() => debugPrint("User has been added.."))
        .catchError((e) => debugPrint(e));
    } else {
      debugPrint("user already exists!!");
      debugPrint("data user: ${getUser.data()}");
      dynamic userData = getUser.data();
      if (userData['familyName'] != null) {
        debugPrint("userData['familyName'] != null");
        if (userData['familyName'] != "") {
          debugPrint("userData['familyName'] != empty");
          familyName.value = userData['familyName'];
        }
      }
    }
  }
}