import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:overlay_kit/overlay_kit.dart';
import 'package:recipe_application/model/ingredient.model.dart';
import 'package:recipe_application/reusable_widgets/toast_message.dart';
import 'package:recipe_application/utils/toast_message_status.dart';

class IngredientProvider extends ChangeNotifier {
  List<Ingredient>? _ingredientList;
  List<Ingredient>? get ingredientList => _ingredientList;

  Future<void> getIngredients() async {
    try {
      var result =
          await FirebaseFirestore.instance.collection('ingredients').get();

      if (result.docs.isNotEmpty) {
        _ingredientList = List<Ingredient>.from(
            result.docs.map((doc) => Ingredient.fromJson(doc.data(), doc.id)));
      } else {
        _ingredientList = [];
      }
      notifyListeners();
    } catch (e) {
      // _ingredientList = [];
      notifyListeners();
    }
  }

  Future<void> addUserToIngredient(bool isAdd, String ingredientId) async {
    try {
      OverlayLoadingProgress.start();
      if (isAdd) {
        await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(ingredientId)
            .update({
          "users_ids":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('ingredients')
            .doc(ingredientId)
            .update({
          "users_ids":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
        });
      }
      OverlayLoadingProgress.stop();
      getIngredients();
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
}
