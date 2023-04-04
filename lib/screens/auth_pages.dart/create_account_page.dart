import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:elite/core/valdtion_helper.dart';
import 'package:elite/models/city_area_model.dart';
import 'package:elite/screens/profile_pages/widgtes/profile_custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_form_field.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/city_model.dart';
import '../../providers/auth_provider.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
  static const routeName = "/create-account";
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _userFirstnameTextController = TextEditingController();
  TextEditingController _userLastnameTextController = TextEditingController();
  TextEditingController _userEmailTextController = TextEditingController();
  TextEditingController _userPhoneTextController = TextEditingController();
  TextEditingController _userBdTextController = TextEditingController();
  TextEditingController _userPasswordTextController = TextEditingController();
  ValidationHelper _validationHelper = ValidationHelper();
  bool _phoneBorderColor = false;
  bool _genderBorderColor = false;
  bool _stateBorderColor = false;
  bool acceptTerms = false;

  bool _isLoading = false;

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedGenderValue;

  List<CityModel> _citiesList = [];
  List<CityAreaModel> _citiesAreaList = [];

  CityModel? _selectedCity;
  CityAreaModel? _selectedAreaCity;

  String? selectedStateValue;

  @override
  void initState() {
    // TODO: implement initState
    // selectedGenderType = gendersList[0];
    super.initState();
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

  fetchCities() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AuthProvider>(context, listen: false)
          .getCities(
        context: context,
      )
          .then((list) async {
        _citiesList = list;
        if (list.isNotEmpty) {
          _selectedCity = _citiesList[0];
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  fetchCitiesArea() async {
    if (_selectedCity == null) return;
    await Provider.of<AuthProvider>(context, listen: false)
        .getCityAreas(context: context, cityIdenifier: _selectedCity!.id)
        .then((areasList) {
      setState(() {
        _isLoading = false;
      });
      if (areasList.isNotEmpty) {
        _selectedAreaCity = areasList[0];
      }
    });
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
          actions: [],
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    padding: EdgeInsets.all(8),
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
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("State",
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
                        borderSide: BorderSide(
                          color: Styles.mainColor,
                        ),
                      ),
                      // filled: borderColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: _stateBorderColor
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
                    hint: Text("Select State",
                        style: Styles.mainTextStyle
                            .copyWith(color: Styles.grayColor, fontSize: 16)),
                    items: _citiesList
                        .map((item) => DropdownMenuItem<CityModel>(
                              value: item,
                              child: Text(
                                item.name,
                                style: Styles.mainTextStyle.copyWith(
                                    fontSize: 16, color: Styles.mainColor),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select State.';
                      }
                      return null;
                    },
                    onChanged: (value) async {
                      //Do something when changing the item if you want.
                      setState(() {
                        _stateBorderColor = true;
                      });
                      _selectedCity = value;
                      await fetchCitiesArea();
                    },
                    onSaved: (value) {
                      // selectedStateValue = value.toString();
                      _selectedCity = value;
                      // print("savedd");
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 60,
                      padding: EdgeInsets.only(left: 20, right: 10),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down,
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
                    height: 18,
                  ),
                  ProfileCustomFormField(
                      controller: _userBdTextController,
                      formatter: [],
                      action: TextInputAction.done,
                      hintText: "",
                      isPrefixeIconAvalibel: false,
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.midGrayColor),
                      vladationFunction: _validationHelper.validateEmail,
                      textInputType: TextInputType.emailAddress,
                      isSuffixIconAvalibel: true,
                      suffixWidget: Icon(
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
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('MMM dd yyyy').format(pickedDate);
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
                        borderSide: BorderSide(
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
                    },
                    onSaved: (value) {
                      selectedGenderValue = value.toString();
                      print("savedd");
                    },
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
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Styles.mainColor, width: 1),
                        ),
                        child: Theme(
                          // color: Colors.white,
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            // shape:  CircleBorder(),
                            value: acceptTerms,

                            checkColor: Styles.mainColor,
                            // side: BorderSide(
                            //   color: Styles.mainColor,
                            // ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.white),
                            focusColor: Colors.white,
                            tristate: false,
                            // activeColor:Colors.white ,
                            fillColor: MaterialStateProperty.all(Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                acceptTerms = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        // flex: 10,
                        child: RichText(
                          text: TextSpan(
                            text:
                                "By creating an account and clicking on the Create a new account button, you agree to our ",
                            style: Styles.mainTextStyle
                                .copyWith(color: Styles.grayColor),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Privacy Policy',
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.grayColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' and ',
                                style: Styles.mainTextStyle
                                    .copyWith(color: Styles.grayColor),
                              ),
                              TextSpan(
                                text: 'Terms of use',
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.grayColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  CustomOutlinedButton(
                      label: "Join",
                      onPressedButton: acceptTerms ? () {} : null,
                      icon: Container(),
                      isIconVisible: false,
                      rectangleBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backGroundColor: acceptTerms
                          ? Styles.mainColor
                          : Styles.mainColor.withOpacity(0.4),
                      // borderSide: BorderSide(color: Styles.mainColor),
                      textStyle: Styles.mainTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
