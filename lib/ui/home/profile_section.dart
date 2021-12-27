import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whosathome/controllers/my_app_controllers.dart';

class ProfileSection extends StatelessWidget {
  ProfileSection({ Key? key }) : super(key: key);

  final controller = Get.find<MyAppControllers>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GetX<MyAppControllers>(
          builder: (c) {
            return Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: Image.network(
                    c.displayPic.value,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.displayName.value,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "You just left 20 minute ago",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        ),
        const SizedBox(height: 15),
        const Text(
          "Mark as: ",
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 100,
              height: 35,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "I go",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xFF818181)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 100,
              height: 35,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "I'm home",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF00AC92),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}