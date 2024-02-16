import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_card.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_list_tile.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/reusable_widgets/search_box.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class AllRecipesPage extends StatefulWidget {
  const AllRecipesPage({super.key});

  @override
  State<AllRecipesPage> createState() => _AllRecipesPageState();
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  List<Recipe>? _foundedList = [];
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false).getRecipes();
    _foundedList =
        Provider.of<RecipeProvider>(context, listen: false).recipesList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Recipe>? results = [];
    if (enteredKeyword.isEmpty) {
      results = Provider.of<RecipeProvider>(context, listen: false).recipesList;
    } else {
      results = Provider.of<RecipeProvider>(context, listen: false)
          .recipesList!
          .where((item) =>
              item.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundedList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            horisontalSpace(),
            const Text(
              'All Recipes',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
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
                onChanged: (value) {
                  _runFilter(value);
                  setState(() {});
                },
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
            ListView(
              shrinkWrap: true,
              children: [
                for (Recipe foundRecipe in _foundedList!)
                  RecipeWidgetListTile(
                      isFavoritIcon: false, recipe: foundRecipe),
              ],
            ),

            /* FlexibleGridView(
                                axisCount: GridLayoutEnum.twoElementsInRow,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                children: recipesProvider.recipesList!
                                    .map((e) => RecipeWidgetCard(recipe: e))
                                    .toList(),
                              ), */
          ],
        ));
  }
}
