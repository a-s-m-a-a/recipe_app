import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_card.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class FilteredRecipesPage extends StatefulWidget {
  final Map? selectedUserValue;
  const FilteredRecipesPage({required this.selectedUserValue, super.key});

  @override
  State<FilteredRecipesPage> createState() => _FilteredRecipesPageState();
}

class _FilteredRecipesPageState extends State<FilteredRecipesPage> {
  @override
  void initState() {
    Provider.of<RecipeProvider>(context, listen: false)
        .getFilteredResult(widget.selectedUserValue!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<RecipeProvider>(
            builder: (ctx, recipesProvider, _) =>
                recipesProvider.filteredRecipesList == null
                    ? const CircularProgressIndicator()
                    : (recipesProvider.filteredRecipesList?.isEmpty ?? false)
                        ? const Text('No Data Found')
                        : FlexibleGridView(
                            axisCount: GridLayoutEnum.twoElementsInRow,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            children: recipesProvider.filteredRecipesList!
                                .map((e) => RecipeWidgetCard(recipe: e))
                                .toList(),
                          )));
  }
}
