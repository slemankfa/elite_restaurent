import 'dart:io';

import 'package:elite/core/valdtion_helper.dart';
import 'package:elite/screens/profile_pages/widgtes/profile_custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_form_field.dart';
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

  TextEditingController _userFirstnameTextController = TextEditingController();
  TextEditingController _userLastnameTextController = TextEditingController();
  TextEditingController _userEmailTextController = TextEditingController();
  TextEditingController _userPhoneTextController = TextEditingController();
  TextEditingController _userPasswordTextController = TextEditingController();
  ValidationHelper _validationHelper = ValidationHelper();
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userFirstnameTextController.dispose();
    _userLastnameTextController.dispose();
    _userEmailTextController.dispose();
    _userPhoneTextController.dispose();
    _userPasswordTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                              backgroundImage:
                                  FileImage(File(_userImage!.path)),
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
                const SizedBox(
                  height: 8,
                ),
                ProfileCustomFormField(
                    controller: _userFirstnameTextController,
                    formatter: [],
                    action: TextInputAction.done,
                    hintText: "",
                    textStyle: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    hintStyle: TextStyle(),
                    vladationFunction: _validationHelper.validateField,
                    textInputType: TextInputType.text,
                    isSuffixIconAvalibel: false,
                    isPrefixeIconAvalibel: false,
                    readOnly: false,
                    onTapFuncation: () {},
                    textAlign: TextAlign.start,
                    label: "First name",
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    formFillColor: Colors.white),
                const SizedBox(
                  height: 18,
                ),
                ProfileCustomFormField(
                    controller: _userLastnameTextController,
                    formatter: [],
                    isPrefixeIconAvalibel: false,
                    action: TextInputAction.done,
                    hintText: "",
                    textStyle: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    hintStyle: TextStyle(),
                    vladationFunction: _validationHelper.validateField,
                    textInputType: TextInputType.name,
                    isSuffixIconAvalibel: false,
                    readOnly: false,
                    onTapFuncation: () {},
                    textAlign: TextAlign.start,
                    label: "Last name",
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    formFillColor: Colors.white),
                const SizedBox(
                  height: 18,
                ),
                ProfileCustomFormField(
                    controller: _userEmailTextController,
                    formatter: [],
                    isPrefixeIconAvalibel: false,
                    action: TextInputAction.done,
                    hintText: "",
                    textStyle: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    hintStyle: TextStyle(),
                    vladationFunction: _validationHelper.validateEmail,
                    textInputType: TextInputType.emailAddress,
                    isSuffixIconAvalibel: false,
                    readOnly: false,
                    onTapFuncation: () {},
                    textAlign: TextAlign.start,
                    label: "Email",
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    formFillColor: Colors.white),
                const SizedBox(
                  height: 18,
                ),
                CustomFormField(
                  controller: _userPasswordTextController,
                  formatter: [],
                  textInputType: TextInputType.visiblePassword,
                  vladationFunction: _validationHelper.validatePassword,
                  action: TextInputAction.done,
                  hintText: "",
                  isSecureField: true,
                  textStyle: Styles.mainTextStyle,
                  hintStyle: TextStyle(),
                  labelTextStyle: Styles.mainTextStyle
                      .copyWith(color: Styles.unslectedItemColor, fontSize: 16),
                  label: "Password",
                ),
                const SizedBox(
                  height: 18,
                ),
                ProfileCustomFormField(
                    controller: _userEmailTextController,
                    formatter: [],
                    action: TextInputAction.done,
                    hintText: "",
                    isPrefixeIconAvalibel: true,
                    prefixWidget: Icon(Icons.abc),
                    textStyle: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    hintStyle: TextStyle(),
                    vladationFunction: _validationHelper.validateEmail,
                    textInputType: TextInputType.emailAddress,
                    isSuffixIconAvalibel: false,
                    // suffixWidget: Icon(Icons.add),
                    readOnly: false,
                    onTapFuncation: () {},
                    textAlign: TextAlign.start,
                    label: "Phone number",
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    formFillColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
