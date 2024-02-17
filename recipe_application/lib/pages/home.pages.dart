import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/pages/favorites.pages.dart';
import 'package:recipe_application/pages/ingredients.pages.dart';
import 'package:recipe_application/pages/recently_viewed.pages.dart';
import 'package:recipe_application/pages/settings.pages.dart';
import 'package:recipe_application/reusable_widgets/ads_widget.dart';
import 'package:recipe_application/reusable_widgets/app_bar_menu_screen.dart';
import 'package:recipe_application/reusable_widgets/fresh_recipes_widget.dart';
import 'package:recipe_application/reusable_widgets/recommended_recipes_widget.dart';
import 'package:recipe_application/reusable_widgets/reusable_list_tile.dart';
import 'package:recipe_application/reusable_widgets/search_bar.dart';
import 'package:recipe_application/reusable_widgets/section_header.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = FirebaseAuth.instance.currentUser?.displayName ?? "";
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
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const AppBarMenuScreen()),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusedListTile(
                  text: Text(
                    "Home",
                    style: TextStyle(color: hexStringToColor("#F45B00")),
                  ),
                  icon: Icon(
                    Icons.home,
                    color: hexStringToColor("#F45B00"),
                  ),
                  page: const HomePage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text("Favorites"),
                  icon: const Icon(Icons.favorite_border_rounded),
                  page: const FavouritesPage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text("Recently Viewed"),
                  icon: const Icon(Icons.pause),
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Bonjour, $name ",
                          style: TextStyle(
                              color: hexStringToColor("bfc3cf"),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        )),
                    const SearchBarWidget(
                        text: "What would you like to cook today ?"),
                    const AdsWidget(),
                    const SectionHeader(sectionName: "Today's Fresh Recipes"),
                    const SizedBox(
                      height: 300,
                      child: FreshRecipesWidget(),
                    ),
                    const SectionHeader(sectionName: "ٌRecommended Recipes"),
                    const SizedBox(
                        height: 300, child: RecommendedRecipesWidget()),
                  ]),
                ),
              ),
            )));
  }
}
