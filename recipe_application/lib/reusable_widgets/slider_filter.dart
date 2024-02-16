import 'package:flutter/material.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/utils.dart';

class SliderFilter extends StatefulWidget {
  final List<String>? labels;
  final String? variable;
  final Map? selectedUserValue;
  const SliderFilter(
      {required this.labels,
      required this.variable,
      required this.selectedUserValue,
      super.key});

  @override
  State<SliderFilter> createState() => SliderFilterState();
}

class SliderFilterState extends State<SliderFilter> {
  bool isSelected = false;
  int value1 = 0;
  int index = 0;

  Widget buildLabel({
    required String label,
    required double width,
    required Color color,
  }) =>
      Container(
        width: width,
        child: Text(
          label.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ).copyWith(color: color),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: hexStringToColor("#F45B00"),
        overlayColor: Colors.orange.shade200,
        valueIndicatorColor: hexStringToColor("#F45B00"),

        /// track color
        activeTrackColor: Colors.orange.shade200,
        inactiveTrackColor: Colors.black12,

        /// ticks in between
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: Utils.modelBuilder(
                widget.labels!,
                (index, label) {
                  final selectedColor = hexStringToColor("#F45B00");
                  final unselectedColor = Colors.black.withOpacity(0.3);
                  isSelected = index <= index;
                  final color = isSelected ? selectedColor : unselectedColor;

                  return buildLabel(label: label, color: color, width: 30);
                },
              ),
            ),
          ),
          Slider(
              value: index.toDouble(),
              min: 0,
              max: widget.labels!.length - 1,
              divisions: widget.labels!.length - 1,
              label: widget.labels![index].toString(),
              onChanged: (value) async {
                index = value.toInt();
                var x = num.parse(widget.labels![index]);
                widget.selectedUserValue![widget.variable.toString()] = x;

                setState(() {});
              }),
        ],
      ),
    );
  }

  getUserSelectedValue() {
    return value1;
  }
}
