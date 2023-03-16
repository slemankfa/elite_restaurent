import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
  static const routeName = "/edit-profile";
}

class _EditProfilePageState extends State<EditProfilePage> {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  XFile? _userImage;

  _pickUserImage() async {
    try {
      _userImage = await _picker.pickImage(source: ImageSource.gallery);
      if (_userImage == null) return;
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

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
              const SizedBox(
                height: 25,
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: _pickUserImage,
                  child: Container(
                    alignment: Alignment.center,
                    width: 128,
                    height: 128,
                    child: _userImage == null
                        ? Image.asset("assets/images/choose_image.png")
                        : CircleAvatar(
                            radius: 128.0,
                            backgroundImage: FileImage(File(_userImage!.path)),
                            backgroundColor: Colors.transparent,
                          ),
                    // ClipRRect(
                    //     borderRadius: BorderRadius.circular(40.0),
                    //     child: Image.file(
                    //       File(
                    //         _userImage!.path,
                    //       ),
                    //       fit: BoxFit.fill,
                    //     )),
                  ),
                ),
              ), 
              
            ],
          ),
        ),
      ),
    );
  }
}
