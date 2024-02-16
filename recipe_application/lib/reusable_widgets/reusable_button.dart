import 'package:flutter/material.dart';
import 'package:recipe_application/utils/colors.utils.dart';

class ButtonWidget extends StatefulWidget {
  final double width;
  final double hight;
  final String text;
  final Function onTap;
  final bool isForAuth;
  const ButtonWidget(
      {required this.width,
      required this.hight,
      required this.text,
      required this.onTap,
      required this.isForAuth,
      super.key});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.hight,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: ElevatedButton(
        onPressed: () {
          widget.onTap();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return hexStringToColor("#F45B00");
            }
            return widget.isForAuth
                ? Colors.transparent
                : hexStringToColor("#F45B00");
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black;
            }
            return Colors.white;
          }),
          elevation: const MaterialStatePropertyAll(0),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
