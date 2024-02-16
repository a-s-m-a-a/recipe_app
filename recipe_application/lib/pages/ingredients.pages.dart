import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/viewModel/ingredients_provider.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  @override
  void initState() {
    Provider.of<IngredientProvider>(context, listen: false).getIngredients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<IngredientProvider>(
          builder: (context, ingredientProvider, child) =>
              ingredientProvider.ingredientList == null
                  ? const CircularProgressIndicator()
                  : (ingredientProvider.ingredientList?.isEmpty ?? false)
                      ? const Text("no data found")
                      : ListView.builder(
                          itemCount: ingredientProvider.ingredientList!.length,
                          itemBuilder: (context, index) => ListTile(
                                leading: Checkbox(
                                    checkColor: hexStringToColor("#F45B00"),
                                    value: ingredientProvider
                                        .ingredientList![index].users_ids
                                        ?.contains(FirebaseAuth
                                            .instance.currentUser?.uid),
                                    onChanged: (value) {
                                      ingredientProvider.addUserToIngredient(
                                          value ?? false,
                                          ingredientProvider
                                              .ingredientList![index].docId!);
                                    }),
                                title: Text(ingredientProvider
                                        .ingredientList![index].name ??
                                    'No Name'),
                              ))),
    );
  }
}
