import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/pages/favorites.pages.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/ingredients.pages.dart';
import 'package:recipe_application/pages/recently_viewed.pages.dart';
import 'package:recipe_application/reusable_widgets/app_bar_menu_screen.dart';
import 'package:recipe_application/reusable_widgets/profile.dart';
import 'package:recipe_application/reusable_widgets/reusable_list_tile.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';

class SettingsPAge extends StatefulWidget {
  const SettingsPAge({super.key});

  @override
  State<SettingsPAge> createState() => _SettingsPAgeState();
}

class _SettingsPAgeState extends State<SettingsPAge> {
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
                  text: const Text(
                    "Home",
                  ),
                  icon: const Icon(
                    Icons.home,
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
                  text: Text(
                    "Settings",
                    style: TextStyle(color: hexStringToColor("#F45B00")),
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: hexStringToColor("#F45B00"),
                  ),
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Row(children: [
                          Text(
                            "Settings",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ]),
                        Container(
                          width: MediaQuery.sizeOf(context).width,
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: hexStringToColor("f7f8fc")),
                          child: Center(
                            child: ListTile(
                              leading: const Icon(Icons.language),
                              title: const Text("Language"),
                              trailing: Text(
                                "English",
                                style: TextStyle(
                                    color: hexStringToColor("#F45B00"),
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey,
                        ),
                        const Row(children: [
                          Text(
                            "Update your image",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ]),
                        const ProfilePage(),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
