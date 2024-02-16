import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RichTextWidget extends StatelessWidget {
  final int num;
  final List<String> text;
  final List<Color> colors;
  final List<Function> function;

  const RichTextWidget(
      {required this.colors,
      required this.num,
      required this.text,
      required this.function,
      super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      for (int i = 0; i < num; i++)
        TextSpan(
            text: text[i],
            style: TextStyle(
              color: colors[i],
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = function[i] as GestureTapCallback?),
    ]));
  }
}
