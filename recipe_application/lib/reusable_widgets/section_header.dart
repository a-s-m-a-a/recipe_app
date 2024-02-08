import 'package:flutter/material.dart';
import 'package:recipe_application/pages/all_recipes.pages.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';

class SectionHeader extends StatelessWidget {
  final String sectionName;
  const SectionHeader({required this.sectionName, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Numbers.appHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            sectionName,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AllRecipesPage()));
            },
            child: Text(
              'See All',
              style: TextStyle(
                  fontSize: 15,
                  color: hexStringToColor("f55a00"),
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
