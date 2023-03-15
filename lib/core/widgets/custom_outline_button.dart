import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  CustomOutlinedButton({
    Key? key,
    required this.label,
    required this.icon,
    this.backGroundColor,
    this.borderSide,
    required this.onPressedButton,
    required this.textStyle,
  }) : super(key: key);

  final String label;
  final Widget icon;
  final Color? backGroundColor;
  final BorderSide? borderSide;
  final Function onPressedButton;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: EdgeInsets.all(0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            side: borderSide, backgroundColor: backGroundColor),
        onPressed: () {
          onPressedButton();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: textStyle,
            ),
            const SizedBox(
              width: 10,
            ),
            icon
          ],
        ),
      ),
    );
  }
}
