import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles.dart';

class ProfileCustomFormField extends StatefulWidget {
  ProfileCustomFormField({
    super.key,
    required this.controller,
    required this.formatter,
    required this.action,
    required this.hintText,
    required this.textStyle,
    required this.hintStyle,
    this.maxline,
    this.maxLength,
    required this.vladationFunction,
    required this.textInputType,
    required this.isSuffixIconAvalibel,
    required this.readOnly,
    required this.onTapFuncation,
    this.suffixWidget,
    this.prefixWidget,
    required this.textAlign,
    required this.label,
    required this.labelTextStyle,
    required this.formFillColor,
    required this.isPrefixeIconAvalibel,
  });

  final TextEditingController controller;
  final List<TextInputFormatter> formatter;
  final TextInputAction action;
  final String hintText;

  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextStyle labelTextStyle;
  final String label;
  final int? maxline;
  final int? maxLength;
  final TextInputType textInputType;
  final Function vladationFunction;
  final bool isSuffixIconAvalibel;
  final bool isPrefixeIconAvalibel;
  final bool readOnly;
  final Function onTapFuncation;
  Widget? suffixWidget;
  Widget? prefixWidget;
  TextAlign textAlign;
  final Color formFillColor;

  @override
  State<ProfileCustomFormField> createState() => _ProfileCustomFormFieldState();
}

class _ProfileCustomFormFieldState extends State<ProfileCustomFormField> {
  bool borderColor = false;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.controller.text.trim().isNotEmpty) {
      borderColor = true;
    }
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.trim().isNotEmpty) {
        borderColor = true;
      }
    });
    // is secure for adding password featuers
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: widget.labelTextStyle,
        ),
        Visibility(
          visible: widget.label.trim().isNotEmpty ? true : false,
          child: const SizedBox(
            height: 12,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          inputFormatters: widget.formatter,
          textAlign: widget.textAlign,
          keyboardType: widget.textInputType,
          validator: (value) => widget.vladationFunction(value),
          textInputAction: widget.action,
          style: widget.textStyle,
          maxLines: widget.maxline,
          readOnly: widget.readOnly,
          onTap: () {
             widget.onTapFuncation();
          },
          // onEditingComplete: (() {
          //   print("asdasd");
          // }),
          onChanged: (value) {
            if (value.trim().isNotEmpty) {
              setState(() {
                borderColor = true;
              });
            } else {
              setState(() {
                borderColor = false;
              });
            }
          },
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            isDense: true,
            // fillColor: Styles.fillFormFieldsBackgroundItem,
            suffixIcon: widget.isSuffixIconAvalibel == false
                ? null
                : widget.suffixWidget,
            prefixIcon: widget.isPrefixeIconAvalibel == false
                ? null
                : widget.prefixWidget,
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
                color: borderColor
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
            border: const OutlineInputBorder(),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
          ),
        ),
      ],
    );
  }
}
