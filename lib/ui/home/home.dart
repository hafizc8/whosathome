import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whosathome/controllers/my_app_controllers.dart';
import 'package:whosathome/ui/home/card_recent_history.dart';
import 'package:whosathome/ui/home/my_family_section.dart';
import 'package:whosathome/ui/home/profile_section.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final controller = Get.find<MyAppControllers>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Who's at home?",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileSection(),
              const SizedBox(height: 30),
              const CardRecentHistory(),
              const SizedBox(height: 20),
              const MyFamilySection(),
            ],
          ),
        ),
      ),
    );
  }
}
