import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/reusable_widgets/toast_message.dart';
import 'package:recipe_application/utils/toast_message_status.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe>? _recipesList;
  List<Recipe>? get recipesList => _recipesList;

  List<Recipe>? _recientlyViewedRecipesList;
  List<Recipe>? get recientlyViewedRecipesList => _recientlyViewedRecipesList;
  List<Recipe>? _favoritRecipesList;
  List<Recipe>? get favoritRecipesList => _favoritRecipesList;

  List<Recipe>? _freshRecipesList;
  List<Recipe>? get freshRecipesList => _freshRecipesList;

  List<Recipe>? _recommandedRecipesList;
  List<Recipe>? get recommandedRecipesList => _recommandedRecipesList;
  List<Recipe>? _filteredRecipesList;
  List<Recipe>? get filteredRecipesList => _filteredRecipesList;

  Recipe? openedRecipe;
  Future<void> getRecipes() async {
    try {
      var result = await FirebaseFirestore.instance.collection('recipes').get();
      if (result.docs.isNotEmpty) {
        _recipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recipesList = [];
      notifyListeners();
    }
  }

  Future<void> getFilteredResult(Map selectedUserValue) async {
    var ref = FirebaseFirestore.instance.collection('recipes');
    for (var entry in selectedUserValue.entries) {
      ref.where(entry.key, isEqualTo: entry.value);
    }

    var result = await ref.get();
    if (result.docs.isNotEmpty) {
      _filteredRecipesList = List<Recipe>.from(
          result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
    }
    notifyListeners();
  }

  Future<void> getSelectedRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      if (result.data() != null) {
        openedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }
      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');
    }
  }

  Future<void> getFreshRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('fresh', isEqualTo: true)
          .get();

      if (result.docs.isNotEmpty) {
        _freshRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _freshRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _freshRecipesList = [];
      notifyListeners();
    }
  }

  Future<void> getRecentlyViewedRecipesList() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where("recently_viewd_users_ids",
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (result.docs.isNotEmpty) {
        _recientlyViewedRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recientlyViewedRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recientlyViewedRecipesList = [];
      notifyListeners();
    }
  }

  Future<void> getFavoritRecipesList() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where("users_ids",
              arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (result.docs.isNotEmpty) {
        _favoritRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _favoritRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recientlyViewedRecipesList = [];
      notifyListeners();
    }
  }

  Future<void> addUserToRecipes(bool isAdd, String recipeId) async {
    try {
      OverlayLoadingProgress.start();
      if (isAdd) {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "users_ids":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('recipes')
            .doc(recipeId)
            .update({
          "users_ids":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
      }
      await _updateRecipe(recipeId);
      OverlayLoadingProgress.stop();
    } catch (e) {
      OverlayLoadingProgress.stop();
      OverlayToastMessage.show(
        widget: ToastMessageWidget(
          message: 'Error : ${e.toString()}',
          toastMessageStatus: ToastMessageStatus.faild,
        ),
      );
    }
  }

  Future<void> _updateRecipe(String recipeId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .get();
      Recipe? updatedRecipe;
      if (result.data() != null) {
        updatedRecipe = Recipe.fromJson(result.data()!, result.id);
      } else {
        return;
      }

      var recipesListIndex =
          recipesList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recipesListIndex != -1) {
        recipesList?.removeAt(recipesListIndex!);
        recipesList?.insert(recipesListIndex!, updatedRecipe);
      }

      var freshRecipesListIndex =
          freshRecipesList?.indexWhere((recipe) => recipe.docId == recipeId);

      if (freshRecipesListIndex != -1) {
        freshRecipesList?.removeAt(freshRecipesListIndex!);
        freshRecipesList?.insert(freshRecipesListIndex!, updatedRecipe);
      }

      var recommandedRecipesListIndex = recommandedRecipesList
          ?.indexWhere((recipe) => recipe.docId == recipeId);

      if (recommandedRecipesListIndex != -1) {
        recommandedRecipesList?.removeAt(recommandedRecipesListIndex!);
        recommandedRecipesList?.insert(
            recommandedRecipesListIndex!, updatedRecipe);

        var filteredRecipesListIndex = filteredRecipesList
            ?.indexWhere((recipe) => recipe.docId == recipeId);

        if (filteredRecipesListIndex != -1) {
          filteredRecipesList?.removeAt(filteredRecipesListIndex!);
          filteredRecipesList?.insert(filteredRecipesListIndex!, updatedRecipe);
        }
      }
      notifyListeners();
    } catch (e) {
      print('>>>>>error in update recipe');
    }
  }

  Future<void> getRecommandedRecipes() async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('recipes')
          .where('fresh', isEqualTo: false)
          .get();
      if (result.docs.isNotEmpty) {
        _recommandedRecipesList = List<Recipe>.from(
            result.docs.map((doc) => Recipe.fromJson(doc.data(), doc.id)));
      } else {
        _recommandedRecipesList = [];
      }
      notifyListeners();
    } catch (e) {
      _recommandedRecipesList = [];
      notifyListeners();
    }
  }

  void addRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
            FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
      });
    } catch (e) {}
  }

  void removeRecipeToUserRecentlyViewed(String recipeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .update({
        "recently_viewd_users_ids":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
      });
      notifyListeners();
    } catch (e) {}
  }
}
