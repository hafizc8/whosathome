import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whosathome/controllers/user_controller.dart';
import 'package:whosathome/routes/app_pages.dart';

class MyAppControllers extends GetxController {
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ],
  );

  RxString displayName  = "".obs;
  RxString googleId     = "".obs;
  RxString email        = "".obs;
  RxString displayPic   = "".obs;
  GetStorage storage = GetStorage();

  @override
  void onInit() {
    checkIsSignin();
    super.onInit();
  }

  /// Check is signed in
  dynamic checkIsSignin() async {
    GoogleSignInAccount? googleAccount;

    if (await _googleSignIn.isSignedIn()) {
      googleAccount = await _googleSignIn.signInSilently();

      if (googleAccount != null) {
        displayName.value = googleAccount.displayName ?? "Unknow";
        googleId.value = googleAccount.id;
        email.value = googleAccount.email;
        displayPic.value = googleAccount.photoUrl ?? "https://i.pravatar.cc/150?img=2";

        saveSessionLogin();

        Get.offAndToNamed(Routes.home);
      }
    }
  }

  /// google sign in and save user info
  /// if [isSignIn] true, will create new user
  Future<void> signInGoogle({bool isSignIn = true}) async {
    try {
      GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();

      if (googleAccount != null) {
        displayName.value = googleAccount.displayName ?? "Unknow";
        googleId.value = googleAccount.id;
        email.value = googleAccount.email;
        displayPic.value = googleAccount.photoUrl ?? "https://i.pravatar.cc/150?img=2";

        saveSessionLogin();

        if (!isSignIn) {
          await UserController().createNewUser();
        }

        Get.offAndToNamed(Routes.home);
      }
    } catch (error) {
      debugPrint("ada error sign in google");
      debugPrint(error.toString());
      _googleSignIn.signOut();
      _googleSignIn.disconnect();
    }
  }

  dynamic saveSessionLogin() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(email.value).get();
    dynamic data = doc.data();
    debugPrint("data['familyName']: ${data['familyName']}");
    // write to session
    storage.write("userId", googleId.value);
    storage.write("email", email.value);
    storage.write("name", displayName.value);
    storage.write("displayPic", displayPic.value);
    storage.write("familyName", data['familyName']);
  }
}