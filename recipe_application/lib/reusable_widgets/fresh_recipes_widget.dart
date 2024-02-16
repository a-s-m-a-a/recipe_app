import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_card.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class FreshRecipesWidget extends StatefulWidget {
  const FreshRecipesWidget({super.key});

  @override
  State<FreshRecipesWidget> createState() => _FreshRecipesWidgetState();
}

class _FreshRecipesWidgetState extends State<FreshRecipesWidget> {
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false).getFreshRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
        builder: (ctx, recipesProvider, _) =>
            recipesProvider.freshRecipesList == null
                ? const CircularProgressIndicator()
                : (recipesProvider.freshRecipesList?.isEmpty ?? false)
                    ? const Text('No Data Found')
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: recipesProvider.freshRecipesList!.length,
                        itemBuilder: (ctx, index) => RecipeWidgetCard(
                              recipe: recipesProvider.freshRecipesList![index],
                            )));
  }
}
