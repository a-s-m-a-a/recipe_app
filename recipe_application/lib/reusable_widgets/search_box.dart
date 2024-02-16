import 'package:flutter/material.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/utils/colors.utils.dart';

class SearchBox extends StatefulWidget {
  final List<Recipe>? recipeList;
  final String? text;
  const SearchBox({required this.recipeList, required this.text, super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  List<Recipe>? _foundedList = [];
  @override
  void initState() {
    _foundedList = widget.recipeList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        horisontalSpace(),
        Text(
          widget.text.toString(),
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        horisontalSpace(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: hexStringToColor("f7f8fc"),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: hexStringToColor("f7f8fc"),
                size: 20,
              ),
              prefixIconConstraints:
                  const BoxConstraints(maxHeight: 20, minWidth: 25),
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _runFilter(String enteredKeyword) {
    List<Recipe> results = [];
    if (enteredKeyword.isEmpty) {
      results = _foundedList!;
    } else {
      results = _foundedList!
          .where((item) =>
              item.type!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    _foundedList = results;

    setState(() {});
  }
}
