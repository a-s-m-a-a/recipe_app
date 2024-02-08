import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_application/model/ad.model.dart';

class AdsProvider extends ChangeNotifier {
  Ad? _ad;
  Ad? get ad => _ad;
  List<Ad>? _adsList;

  List<Ad>? get adsList => _adsList;
  CarouselController? carouselController;

  int sliderIndex = 0;

  void initCarousel() {
    carouselController = CarouselController();
  }

  void onPageChanged(int index) {
    sliderIndex = index;
    notifyListeners();
  }

  void disposeCarousel() {
    carouselController = null;
  }

  void onPressArrowLift() {
    carouselController!.previousPage();
    notifyListeners();
  }

  void onPressArrowRight() {
    carouselController!.nextPage();
    notifyListeners();
  }

  void onDotTapped(int position) async {
    await carouselController?.animateToPage(position);
    sliderIndex = position;
    notifyListeners();
  }

  Future<void> getAds() async {
    try {
      var result = await FirebaseFirestore.instance.collection("ads").get();
      if (result.docs.isNotEmpty) {
        _adsList = List<Ad>.from(
            result.docs.map((doc) => Ad.fromJson(doc.data(), doc.id)));
      } else {
        _adsList = [];
      }
      notifyListeners();
    } catch (e) {
      _adsList = [];
      notifyListeners();
    }
  }

  Future<void> getCertinAd(String id) async {
    try {
      var result =
          await FirebaseFirestore.instance.collection('ads').doc(id).get();
      if (result.exists) {
        _ad = Ad.fromJson(result.data() ?? {}, result.id);
      } else {
        _ad = null;
      }
      notifyListeners();
    } catch (e) {
      _ad = null;
      notifyListeners();
    }
  }
}
