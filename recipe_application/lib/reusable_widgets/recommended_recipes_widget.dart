import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_card.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class RecommendedRecipesWidget extends StatefulWidget {
  const RecommendedRecipesWidget({super.key});

  @override
  State<RecommendedRecipesWidget> createState() =>
      _RecommendedRecipesWidgetState();
}

class _RecommendedRecipesWidgetState extends State<RecommendedRecipesWidget> {
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false).getRecommandedRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
        builder: (ctx, recipesProvider, _) => recipesProvider
                    .recommandedRecipesList ==
                null
            ? const CircularProgressIndicator()
            : (recipesProvider.recommandedRecipesList?.isEmpty ?? false)
                ? const Text('No Data Found')
                : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: recipesProvider.recommandedRecipesList!.length,
                    itemBuilder: (ctx, index) => RecipeWidgetCard(
                          recipe:
                              recipesProvider.recommandedRecipesList![index],
                        )));
  }
}
