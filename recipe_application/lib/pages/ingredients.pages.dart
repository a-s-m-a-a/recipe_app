import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/pages/favorites.pages.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/settings.pages.dart';
import 'package:recipe_application/reusable_widgets/app_bar_menu_screen.dart';
import 'package:recipe_application/reusable_widgets/reusable_list_tile.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';
import 'package:recipe_application/viewModel/ingredients_provider.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({super.key});

  @override
  State<IngredientPage> createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  late ZoomDrawerController controller;
  @override
  void initState() {
    controller = ZoomDrawerController();
    Provider.of<IngredientProvider>(context, listen: false).getIngredients();
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
                  text: const Text(
                    "Recently Viewed",
                  ),
                  icon: const Icon(
                    Icons.pause,
                  ),
                  page: const IngredientPage(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: const Text("Settings"),
                  icon: const Icon(Icons.settings),
                  page: const SettingsPAge(),
                  controller: controller,
                ),
                ReusedListTile(
                  text: Text(
                    "Ingredients",
                    style: TextStyle(color: hexStringToColor("#F45B00")),
                  ),
                  icon: Icon(
                    Icons.settings_input_component,
                    color: hexStringToColor("#F45B00"),
                  ),
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
          body: Consumer<IngredientProvider>(
              builder: (context, ingredientProvider, child) =>
                  ingredientProvider.ingredientList == null
                      ? const CircularProgressIndicator()
                      : (ingredientProvider.ingredientList?.isEmpty ?? false)
                          ? const Text("no data found")
                          : ListView.builder(
                              itemCount:
                                  ingredientProvider.ingredientList!.length,
                              itemBuilder: (context, index) => ListTile(
                                    leading: Checkbox(
                                        checkColor: hexStringToColor("#F45B00"),
                                        activeColor: Colors.white,
                                        value: ingredientProvider
                                            .ingredientList![index].users_ids
                                            ?.contains(FirebaseAuth
                                                .instance.currentUser?.uid),
                                        onChanged: (value) {
                                          ingredientProvider
                                              .addUserToIngredient(
                                                  value ?? false,
                                                  ingredientProvider
                                                      .ingredientList![index]
                                                      .docId!);
                                        }),
                                    title: Text(ingredientProvider
                                            .ingredientList![index].name ??
                                        'No Name'),
                                  ))),
        ));
  }
}
