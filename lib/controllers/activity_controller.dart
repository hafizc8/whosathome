import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum EventLabel {
  imHome,
  iGo
}

class ActivityController extends GetxController {
  FirebaseFirestore myFirestore = FirebaseFirestore.instance;

  /// Mark user event like (i'm home or i go)
  dynamic markAsEvent({bool isHaveFamily = true, required EventLabel eventLabel}) async {
    GetStorage storage = GetStorage();

    if (!isHaveFamily) {
      Get.showSnackbar(
        const GetSnackBar(
          icon: Icon(Icons.warning),
          title: "Ups!",
          message: "You must have family before click this action",
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );

      return;
    }

    Map<String, dynamic> activity = {
      "eventLabel": eventLabel == EventLabel.iGo ? "I go" : "I'm home",
      "time": DateTime.now().millisecondsSinceEpoch
    };

    // update recent activity in family collection
    String familyName = storage.read("familyName");
    updateRecentActivity(
      familyName: familyName, 
      currentUserEmail: storage.read("email"), 
      data: activity,
    );

    // add recent activity
    await myFirestore.collection("users").doc(storage.read("email")).collection("recentActivities").add(activity);
  }

  dynamic updateRecentActivity({required String familyName, required String currentUserEmail, required Map<String, dynamic> data}) async {
    DocumentReference familyDoc = myFirestore.collection('families').doc(familyName);
    DocumentSnapshot getFamily  = await familyDoc.get();

    // get current users list
    List<Map<String, dynamic>> currentUsers = List<Map<String, dynamic>>.from((getFamily.get("users") as List).map((e) => e));
    currentUsers = currentUsers.map((e) {
      if (e['email'] == currentUserEmail) {
        // update data
        return {
          "email": e['email'],
          "name": e['name'],
          "displayPic": e['displayPic'],
          "recentActivity": data
        };
      }

      return e;
    }).toList();

    // add current user to family list
    await familyDoc
      .set({
        "users": currentUsers
      })
      .whenComplete(() => debugPrint("User activity has been updated. family name: $familyName.."))
      .catchError((e) => debugPrint(e));
  }
}