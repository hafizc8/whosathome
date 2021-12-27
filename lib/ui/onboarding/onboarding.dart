import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whosathome/controllers/my_app_controllers.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  final controller = Get.put(MyAppControllers(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/3687827-removebg-preview.png"),
            const SizedBox(height: 30),
            const Text(
              "Take care your family",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tell your family you are away or at home. So they can see your status.",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => controller.handleSignIn(),
                child: const Text(
                  "Create new account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF2DBF64)),
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => controller.handleSignIn(),
                child: const Text(
                  "I have account",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF2098D1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
