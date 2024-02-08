import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class AllRecipesPage extends StatefulWidget {
  const AllRecipesPage({super.key});

  @override
  State<AllRecipesPage> createState() => _AllRecipesPageState();
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false).getRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<RecipeProvider>(
            builder: (ctx, recipesProvider, _) =>
                recipesProvider.recipesList == null
                    ? const CircularProgressIndicator()
                    : (recipesProvider.recipesList?.isEmpty ?? false)
                        ? const Text('No Data Found')
                        : FlexibleGridView(
                            axisCount: GridLayoutEnum.twoElementsInRow,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: recipesProvider.recipesList!
                                .map((e) => RecipeWidget(recipe: e))
                                .toList(),
                          )));
  }
}
