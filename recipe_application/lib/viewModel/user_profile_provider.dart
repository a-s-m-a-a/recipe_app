import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_application/model/user_profile.model.dart';

class UserProfileProvider extends ChangeNotifier {
  UserProfile? user;

  Future<void> getUser(String docId) async {
    try {
      var result = await FirebaseFirestore.instance
          .collection('userProfile')
          .doc(docId)
          .get();
      if (result.data() != null) {
        user = UserProfile.fromJson(result.data()!, result.id);
      } else {
        return;
      }
      notifyListeners();
    } catch (e) {
      print('>>>>>');
    }
  }
}
