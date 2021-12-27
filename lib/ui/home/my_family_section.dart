import 'package:flutter/material.dart';

class MyFamilySection extends StatelessWidget {
  const MyFamilySection({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Family",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          child: Image.asset(
            "assets/images/3371471-removebg-preview.png",
            height: 200,
          ),
        ),
        SizedBox(height: 15),
        SizedBox(
          width: 150,
          height: 35,
          child: ElevatedButton(
            onPressed: () {},
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
  }
}