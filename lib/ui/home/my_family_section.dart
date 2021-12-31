import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whosathome/controllers/my_family_controller.dart';

class MyFamilySection extends StatelessWidget {
  MyFamilySection({Key? key}) : super(key: key);
  final familyC = Get.find<MyFamilyController>();

  @override
  Widget build(BuildContext context) {
    return GetX<MyFamilyController>(
      initState: (state) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          state.controller?.getFamilyData();
        });
      },
      builder: (c) {
        if (c.familyData.isNotEmpty) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Family",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => familyC.formAddUser(context: context),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: c.familyData.length,
                itemBuilder: (ctx, i) {
                  Map<String, dynamic> data = c.familyData[i];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: Image.network(
                            data['displayPic'].toString().isEmpty ? "https://i.pravatar.cc/150?img=$i" : data['displayPic'].toString(),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'] ?? "Unknow user",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data['recentActivity'] != null
                                ? "${data['recentActivity']['eventLabel']} in ${data['recentActivity']['time']}"
                                : "User not joined app"
                              ,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "My Family",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => familyC.formAddUser(context: context),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                "assets/images/3371471-removebg-preview.png",
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 150,
              height: 35,
              child: ElevatedButton(
                onPressed: () => familyC.formAddUser(context: context),
                child: const Text(
                  "Add your family",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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
        );
      },
    );
  }
}
