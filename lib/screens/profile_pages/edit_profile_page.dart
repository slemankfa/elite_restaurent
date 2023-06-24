import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/valdtion_helper.dart';
import 'package:elite/screens/profile_pages/widgtes/profile_custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_form_field.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

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
  final _formKey = GlobalKey<FormState>();

  late Function showPopUpLoading;
  final HelperMethods _helperMethods = HelperMethods();

  final TextEditingController _userFirstnameTextController =
      TextEditingController();
  final TextEditingController _userLastnameTextController =
      TextEditingController();
  final TextEditingController _userEmailTextController =
      TextEditingController();
  final TextEditingController _userPhoneTextController =
      TextEditingController();
  final TextEditingController _userBdTextController = TextEditingController();
  final TextEditingController _userPasswordTextController =
      TextEditingController();
  final ValidationHelper _validationHelper = ValidationHelper();
  bool _phoneBorderColor = false;
  bool _genderBorderColor = false;

  int loginType = 1;

  _pickUserImage() async {
    try {
      _userImage = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (_userImage == null) return;
      setState(() {});
    } catch (e) {
      print(e.toString());
    }
  }

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedGenderValue;

  @override
  void initState() {
    // TODO: implement initState
    // selectedGenderType = gendersList[0];

    super.initState();
    handleUserInforamtion();
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
    _userBdTextController.dispose();
  }

  handleUserInforamtion() {
    UserModel? userModel =
        Provider.of<AuthProvider>(context, listen: false).userInformation;
    if (userModel == null) return;

    _userFirstnameTextController.text = userModel.firstName;
    _userLastnameTextController.text = userModel.lastName;
    _userEmailTextController.text = userModel.email;
    _userPhoneTextController.text = userModel.userPhone;

    DateTime tempDate =
        DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(userModel.age);
    _userBdTextController.text = DateFormat('M-dd-yyyy').format(tempDate);

    selectedGenderValue =
        userModel.userGender == "1" ? genderItems[0] : genderItems[1];

// Google = 2 ,platform=1

    loginType = userModel.loginType ?? 1;

    print(loginType.toString());
  }

  updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      return;
    }
    // BotToast.showText(text: "Under development");

    try {
      UserModel? fetchedUserModel =
          Provider.of<AuthProvider>(context, listen: false).userInformation;
      if (fetchedUserModel == null) return;
      print(selectedGenderValue.toString());
      UserModel user = UserModel(
          firstName: _userFirstnameTextController.text.trim(),
          lastName: _userLastnameTextController.text.trim(),
          email: _userEmailTextController.text,
          password: _userPasswordTextController.text.trim(),
          age: _userBdTextController.text.trim(),
          cityId: fetchedUserModel.cityId,
          areaId: fetchedUserModel.areaId,
          loginType: null,
          userPhone: _userPhoneTextController.text.trim(),
          userGender: selectedGenderValue == "Male" ? "1" : "2",
          userId: fetchedUserModel.userId);
      showPopUpLoading = _helperMethods.showPopUpProgressIndcator();
      await Provider.of<AuthProvider>(context, listen: false)
          .updateUserData(
              user: user,
              userImage: _userImage,
              // selectedCity: CityModel(id: id, name: name),
              // selectedRegionCity: _selectedRegionCity!,
              context: context)
          .then((value) {
        showPopUpLoading();
        if (value) {
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      print(e.toString());
      showPopUpLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userInformation = Provider.of<AuthProvider>(
      context,
    ).userInformation;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Styles.grayColor),
          title: Text(
            "Edit Profile",
            style: Styles.appBarTextStyle,
          ),
          actions: [
            Container(
              width: 80,
              height: 20,
              margin: const EdgeInsets.all(8),
              child: CustomOutlinedButton(
                  label: "Save",
                  onPressedButton: updateProfile,
                  icon: Container(),
                  isIconVisible: false,
                  borderSide: const BorderSide(color: Styles.mainColor),
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Styles.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                        child: (userInformation != null &&_userImage == null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      userInformation.userImage.toString(),
                                  height: 128,
                                  width: 128,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const FlutterLogo(
                                    size: 100,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          "assets/images/choose_image.png"),
                                ),
                              )
                            : _userImage == null
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
                      formatter: const [],
                      action: TextInputAction.done,
                      hintText: "",
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: const TextStyle(),
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
                      formatter: const [],
                      isPrefixeIconAvalibel: false,
                      action: TextInputAction.done,
                      hintText: "",
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: const TextStyle(),
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
                      formatter: const [],
                      isPrefixeIconAvalibel: false,
                      action: TextInputAction.done,
                      hintText: "",
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: const TextStyle(),
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
                  if (loginType == 1)
                    const SizedBox(
                      height: 18,
                    ),
                  if (loginType == 1)
                    CustomFormField(
                      controller: _userPasswordTextController,
                      formatter: const [],
                      textInputType: TextInputType.visiblePassword,
                      vladationFunction: _validationHelper.validatePassword,
                      action: TextInputAction.done,
                      hintText: "",
                      isSecureField: true,
                      textStyle: Styles.mainTextStyle,
                      hintStyle: const TextStyle(),
                      labelTextStyle: Styles.mainTextStyle.copyWith(
                          color: Styles.unslectedItemColor, fontSize: 16),
                      label: "Password",
                    ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Phone number",
                        style: Styles.mainTextStyle.copyWith(
                            fontSize: 16, color: Styles.midGrayColor)),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: _phoneBorderColor
                                ? Styles.mainColor
                                : Styles.formFieldBorderColor)),
                    child: Row(
                      children: [
                        Container(
                          // padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              SvgPicture.asset("assets/icons/jordan_flag.svg"),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                "(+962)",
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.timeTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _userPhoneTextController,
                            keyboardType: TextInputType.phone,
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            onChanged: (text) {
                              if (text.trim().length == 9) {
                                setState(() {
                                  _phoneBorderColor = true;
                                });
                              } else if (text.trim().length == 8) {
                                setState(() {
                                  _phoneBorderColor = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              focusedBorder: InputBorder.none,
                              // filled: borderColor,
                              enabledBorder: InputBorder.none,
                              // focusColor: Colors.black,
                              focusedErrorBorder: InputBorder.none,
                              hintText: "00-000-0000",
                              hintStyle: Styles.mainTextStyle.copyWith(
                                  fontSize: 16, color: Styles.midGrayColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ProfileCustomFormField(
                      controller: _userBdTextController,
                      formatter: const [],
                      action: TextInputAction.done,
                      hintText: "",
                      isPrefixeIconAvalibel: false,
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.midGrayColor),
                      vladationFunction: _validationHelper.validateField,
                      textInputType: TextInputType.emailAddress,
                      isSuffixIconAvalibel: true,
                      suffixWidget: const Icon(
                        Icons.calendar_today,
                        color: Styles.midGrayColor,
                      ),
                      readOnly: true,
                      onTapFuncation: () async {
                        print("show");
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000  MMM dd yyyy
                          String formattedDate =
                              DateFormat('M-dd-yyyy').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            _userBdTextController.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                      textAlign: TextAlign.start,
                      label: "",
                      labelTextStyle: Styles.mainTextStyle.copyWith(
                          color: Styles.unslectedItemColor, fontSize: 16),
                      formFillColor: Colors.white),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Gender",
                        style: Styles.mainTextStyle.copyWith(
                            fontSize: 16, color: Styles.midGrayColor)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                      //Add isDense true and zero Padding.
                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(
                          color: Styles.mainColor,
                        ),
                      ),
                      // filled: borderColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: _genderBorderColor
                              ? Styles.mainColor
                              : Styles.formFieldBorderColor,
                          width: 1.0,
                        ),
                      ),
                      focusColor: Colors.black,
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      //Add more decoration as you want here
                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                    ),
                    isExpanded: true,
                    value: selectedGenderValue,
                    hint: Text("Select Gender",
                        style: Styles.mainTextStyle
                            .copyWith(color: Styles.grayColor, fontSize: 16)),
                    items: genderItems
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: Styles.mainTextStyle.copyWith(
                                    fontSize: 16, color: Styles.mainColor),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select gender.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      //Do something when changing the item if you want.
                      setState(() {
                        _genderBorderColor = true;
                      });
                      selectedGenderValue = value.toString();
                      print("savedd");
                    },
                    onSaved: (value) {},
                    buttonStyleData: const ButtonStyleData(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, right: 10),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.arrow_drop_down,
                          color: Styles.midGrayColor),
                      iconSize: 30,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 55,
                  ),

                  // FormField<String>(
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //           // labelStyle: textStyle,
                  //           errorStyle: TextStyle(
                  //               color: Colors.redAccent, fontSize: 16.0),
                  //           hintText: 'Please select expense',
                  //           border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(5.0))),
                  //       isEmpty: selectedGenderType == '',
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton<String>(
                  //           value: selectedGenderType,
                  //           isDense: true,
                  //           onChanged: (String? newValue) {
                  //             setState(() {
                  //               selectedGenderType = newValue!;
                  //               state.didChange(newValue);
                  //             });
                  //           },
                  //           items: gendersList.map((String value) {
                  //             return DropdownMenuItem<String>(
                  //               value: value,
                  //               child: Text(value),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
