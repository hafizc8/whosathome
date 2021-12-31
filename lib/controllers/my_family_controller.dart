import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyFamilyController extends GetxController {
  FirebaseFirestore myFirestore       = FirebaseFirestore.instance;
  TextEditingController newUserEmailC = TextEditingController();
  TextEditingController newUserNameC  = TextEditingController();
  RxList<dynamic> familyData          = <dynamic>[].obs;

  /// Get family data
  dynamic getFamilyData() async {
    GetStorage storage                      = GetStorage();
    String familiesName                     = storage.read("familyName");

    if (familiesName.isNotEmpty) {
      DocumentReference documentReferencer    = myFirestore.collection('families').doc(familiesName);
      DocumentSnapshot getFamily              = await documentReferencer.get();
      List<dynamic> data                      = List<dynamic>.from((getFamily.get('users') as List).map((e) => e).toList());
      debugPrint("family data: ${data.toString()}");

      if (data.isNotEmpty) {
        familyData.value = data;
      }
    }
  }

  /// Add to family
  Future<void> addUserToFamilies() async {
    try {
      // Declare
      final storage               = GetStorage();
      String newUserEmail         = newUserEmailC.text;
      String newUserName          = newUserNameC.text;
      String currentUserEmail     = storage.read("email");
      String currentUserName      = storage.read("name");
      String familiesName         = currentUserEmail.replaceAll(" ", "") + "-family";

      DocumentReference familyDoc = myFirestore.collection('families').doc(familiesName);
      DocumentSnapshot getFamily  = await familyDoc.get();
      
      // add current user to family collection
      if (!getFamily.exists) {
        // add current user to family list
        await familyDoc
          .set({
            "users": [
              {"email": currentUserEmail, "name": currentUserName}
            ]
          })
          .whenComplete(() => debugPrint("User $currentUserName has been added to $familiesName.."))
          .catchError((e) => debugPrint(e));

        // update familyName in current user data
        await myFirestore.collection('users').doc(currentUserEmail).update({"familyName": familiesName});
      }

      // check if new user has exists
      DocumentReference newUserDoc  = myFirestore.collection('users').doc(newUserEmail);
      DocumentSnapshot getNewUser   = await newUserDoc.get();

      // new user exists
      if (getNewUser.exists) {
        dynamic newUserData = getNewUser.data();
        if (newUserData['familyName'] == "") {
          // update familyName in new user data
          await myFirestore.collection('users').doc(currentUserEmail).update({"familyName": familiesName});
        }

        else {
          // this user has been have family
          Get.showSnackbar(
            const GetSnackBar(
              icon: Icon(Icons.warning),
              title: "Ups!",
              message: "This user has been family",
              duration: Duration(seconds: 4),
              snackPosition: SnackPosition.BOTTOM,
            ),
          );
        }
      }

      // new user not exists
      else {
        await myFirestore.collection('users').doc(newUserEmail).set({
          "userId": "",
          "email": newUserEmail,
          "name": newUserName,
          "familyName": familiesName
        });
      }

      // add user to family
      await addUserToFamilyCollection(familyName: familiesName, data: {"email": newUserEmail, "name": newUserName, "displayPic": ""});

      Get.showSnackbar(
        const GetSnackBar(
          icon: Icon(Icons.check),
          title: "Yeay!",
          message: "Successfully added user to your family",
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    } catch (e) {
      Get.showSnackbar(
        GetSnackBar(
          icon: const Icon(Icons.warning),
          title: "Ups!",
          message: e.toString(),
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
        ),
      );
    }
  }
  
  /// Form add user to family
  dynamic formAddUser({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add new user'
          ),
          content: Wrap(
            children: [
              Column(
                children: [
                  TextField(
                    controller: newUserEmailC,
                    decoration: const InputDecoration(hintText: 'Type email ..'),
                  ),
                  TextField(
                    controller: newUserNameC,
                    decoration: const InputDecoration(hintText: 'Type name ..'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => addUserToFamilies(), 
              child: const Text("Add new user"),
            ),
          ],
        );
      }
    );
  }

  ///
  dynamic addUserToFamilyCollection({required String familyName, required Map<String, dynamic> data}) async {
    DocumentReference familyDoc = myFirestore.collection('families').doc(familyName);
    DocumentSnapshot getFamily  = await familyDoc.get();

    // get current users list
    List<Map<String, dynamic>> currentUsers = List<Map<String, dynamic>>.from((getFamily.get("users") as List).map((e) => e));
    currentUsers.add(data);

    // add current user to family list
    await familyDoc
      .set({
        "users": currentUsers
      })
      .whenComplete(() => debugPrint("User has been added to $familyName.."))
      .catchError((e) => debugPrint(e));
  }
}