import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/pages/filtered_recipes.pages.dart';
import 'package:recipe_application/reusable_widgets/reusable_button.dart';
import 'package:recipe_application/reusable_widgets/slider_filter.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  Map<String, dynamic> selectedUserValue = {};
  List<String> labelsServing = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  List<String> labelsPrepTime = [
    '30',
    '60',
    '90',
    '120',
    '150',
  ];
  List<String> labelsCalories = [
    '0',
    '100',
    '200',
    '300',
    '400',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Meal",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              Wrap(
                  // space between chips
                  spacing: 30,
                  // list of chips
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "breakfast";
                        setState(() {});
                      },
                      child: Chip(
                        label: const Text('Breakfast'),
                        backgroundColor:
                            selectedUserValue['type'] == "breakfast"
                                ? hexStringToColor("#F45B00")
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "lunch";
                        setState(() {});
                      },
                      child: Chip(
                        label: const Text('Lunch'),
                        backgroundColor: selectedUserValue['type'] == "lunch"
                            ? hexStringToColor("#F45B00")
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        selectedUserValue['type'] = "dinner";
                        setState(() {});
                      },
                      child: Chip(
                        label: const Text('Dinner'),
                        backgroundColor: selectedUserValue['type'] == "dinner"
                            ? hexStringToColor("#F45B00")
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ]),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Serving",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SliderFilter(
                  labels: labelsServing,
                  variable: 'servings',
                  selectedUserValue: selectedUserValue),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Preperation Time",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SliderFilter(
                  labels: labelsPrepTime,
                  variable: 'prep_time',
                  selectedUserValue: selectedUserValue),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Calories",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SliderFilter(
                  labels: labelsCalories,
                  variable: 'calories',
                  selectedUserValue: selectedUserValue),
              ButtonWidget(
                  width: MediaQuery.of(context).size.width,
                  hight: 50,
                  text: 'Apply',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FilteredRecipesPage(
                                selectedUserValue: selectedUserValue)));
                  },
                  isForAuth: false)
            ],
          ),
        ),
      ),
    );
  }
}
