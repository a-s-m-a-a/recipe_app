import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/pages/favorites.pages.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/ingredients.pages.dart';
import 'package:recipe_application/pages/settings.pages.dart';
import 'package:recipe_application/reusable_widgets/app_bar_menu_screen.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_list_tile.dart';
import 'package:recipe_application/reusable_widgets/reusable_list_tile.dart';
import 'package:recipe_application/reusable_widgets/search_box.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({super.key});

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
  bool _isListBuilt = false;
  late List<Recipe> recipeList;
  late ZoomDrawerController controller;
  @override
  void initState() {
    controller = ZoomDrawerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.65,
        menuBackgroundColor: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5)],
        disableDragGesture: true,
        mainScreenTapClose: true,
        controller: controller,
        drawerShadowsBackgroundColor: Colors.grey,
        menuScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const AppBarMenuScreen()),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusedListTile(
                  text: const Text("Home"),
                  icon: const Icon(Icons.home),
                  page: const HomePage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text(
                    "Favorites",
                  ),
                  icon: const Icon(
                    Icons.favorite_border_rounded,
                  ),
                  page: const FavouritesPage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: Text(
                    "Recently Viewed",
                    style: TextStyle(color: hexStringToColor("#F45B00")),
                  ),
                  icon: Icon(
                    Icons.pause,
                    color: hexStringToColor("#F45B00"),
                  ),
                  page: const RecentlyViewedPage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text("Settings"),
                  icon: const Icon(Icons.settings),
                  page: const SettingsPAge(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text("Ingredients"),
                  icon: const Icon(Icons.settings_input_component),
                  page: const IngredientPage(),
                  controller: controller,
                ),
                ListTile(
                  selectedColor: hexStringToColor("#F45B00"),
                  onTap: () {
                    Provider.of<AppAuthprovider>(context, listen: false)
                        .signOut(context);
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        ),
        mainScreen: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Numbers.appHorizontalPadding),
              child: InkWell(
                  onTap: () {
                    controller.toggle!();
                  },
                  child: const Icon(Icons.menu)),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .where("recently_viewd_users_ids",
                            arrayContains:
                                FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        if (snapshots.hasError) {
                          return const Text('ERROR WHEN GET DATA');
                        } else {
                          if (snapshots.hasData) {
                            recipeList = snapshots.data?.docs
                                    .map((e) => Recipe.fromJson(e.data(), e.id))
                                    .toList() ??
                                [];

                            return Column(
                              children: [
                                SearchBox(
                                    text: "Reacently Viewed",
                                    recipeList: recipeList),
                                ListView(
                                  shrinkWrap: true,
                                  children: [
                                    for (Recipe foundRecipe in recipeList)
                                      RecipeWidgetListTile(
                                          isFavoritIcon: false,
                                          recipe: foundRecipe),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return const Text('No Data Found');
                          }
                        }
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
