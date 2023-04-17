import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField(
      {super.key,
      required this.controller,
      required this.formatter,
      required this.action,
      required this.hintText,
      required this.textStyle,
      required this.hintStyle,
      this.maxline,
      this.maxLength,
      required this.vladationFunction,
      required this.isSecureField,
      required this.textInputType,
      required this.labelTextStyle,
      required this.label});

  final TextEditingController controller;
  final List<TextInputFormatter> formatter;
  final TextInputAction action;
  final String hintText;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final int? maxline;
  final int? maxLength;
  final bool isSecureField;
  final TextInputType textInputType;
  final Function vladationFunction;
  final TextStyle labelTextStyle;
  final String label;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;
  bool borderColor = false;

  changeObscureTextStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    if (widget.controller.text.trim().isNotEmpty) {
      setState(() {
        borderColor = true;
      });
    }
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.trim().isNotEmpty) {
        setState(() {
          borderColor = true;
        });
      } else {
        setState(() {
          borderColor = false;
        });
      }
    });
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
        const SizedBox(
          height: 12,
        ),
        TextFormField(
          obscureText: widget.isSecureField ? _obscureText : false,
          controller: widget.controller,
          inputFormatters: widget.formatter,
          keyboardType: widget.textInputType,
          validator: (value) => widget.vladationFunction(value),
          textInputAction: widget.action,
          style: widget.textStyle,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            isDense: true,
            // contentPadding: EdgeInsets.symmetric(vertical: 50.0),
            suffixIcon: widget.isSecureField == false
                ? null
                : IconButton(
                    icon: Icon(
                      !_obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Styles.midGrayColor,
                    ),
                    onPressed: changeObscureTextStatus,
                  ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: borderColor
                    ? Styles.mainColor
                    : Styles.formFieldBorderColor,
                width: 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Styles.formFieldBorderColor,
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
