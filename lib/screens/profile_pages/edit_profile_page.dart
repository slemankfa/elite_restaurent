import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
  static const routeName = "/edit-profile";
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Edit Profile",
          style: Styles.appBarTextStyle,
        ),
        actions: [
          Container(
            width: 80,
            height: 20,
            margin: EdgeInsets.all(8),
            child: CustomOutlinedButton(
                label: "Save",
                onPressedButton: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ResturanMenuPage()),
                  // );
                },
                icon: Container(),
                isIconVisible: false,
                borderSide: BorderSide(color: Styles.mainColor),
                textStyle: Styles.mainTextStyle.copyWith(
                    color: Styles.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
}
