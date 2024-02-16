import 'package:flutter/material.dart';
import 'package:recipe_application/pages/filter.pages.dart';
import 'package:recipe_application/reusable_widgets/profile.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/utils/colors.utils.dart';

class SearchBarWidget extends StatelessWidget {
  final String text;
  const SearchBarWidget({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        horisontalSpace(),
        Text(
          text,
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        horisontalSpace(),
        Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: hexStringToColor("f7f8fc"),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FilterPage()));
              },
              child: ListTile(
                title: const Text("Search for rcipes"),
                trailing: IconButton(
                  icon: const Icon(Icons.filter),
                  onPressed: () {},
                ),
              ),
            )),
        horisontalSpace(),
      ],
    );
  }
}
