import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/pages/home.pages.dart';
import 'package:recipe_application/pages/ingredients.pages.dart';
import 'package:recipe_application/pages/recently_viewed.pages.dart';
import 'package:recipe_application/pages/settings.pages.dart';
import 'package:recipe_application/reusable_widgets/app_bar_menu_screen.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget_list_tile.dart';
import 'package:recipe_application/reusable_widgets/reusable_list_tile.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Recipe> _foundedList = [];
  late ZoomDrawerController controller;
  @override
  void initState() {
    controller = ZoomDrawerController();
    Provider.of<RecipeProvider>(context, listen: false).getFavoritRecipesList();
    _foundedList = Provider.of<RecipeProvider>(context, listen: false)
            .favoritRecipesList ??
        [];
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Recipe>? results = [];
    if (enteredKeyword.isEmpty) {
      results = Provider.of<RecipeProvider>(context, listen: false)
          .favoritRecipesList;
    } else {
      results = Provider.of<RecipeProvider>(context, listen: false)
          .favoritRecipesList!
          .where((item) =>
              item.title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundedList = results ?? [];
    });
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
        appBar:
            AppBar(automaticallyImplyLeading: false, title: AppBarMenuScreen()),
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
                text: Text(
                  "Favorites",
                  style: TextStyle(color: hexStringToColor("#F45B00")),
                ),
                icon: Icon(
                  Icons.favorite_border_rounded,
                  color: hexStringToColor("#F45B00"),
                ),
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
                horisontalSpace(),
                const Text(
                  'My Favorit Recipes',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                horisontalSpace(),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: hexStringToColor("f7f8fc"),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        _runFilter(value);
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(0),
                        prefixIcon: Icon(
                          Icons.search,
                          color: hexStringToColor("f7f8fc"),
                          size: 20,
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(maxHeight: 20, minWidth: 25),
                        border: InputBorder.none,
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  children: [
                    for (Recipe foundRecipe in _foundedList)
                      RecipeWidgetListTile(
                          isFavoritIcon: true, recipe: foundRecipe),
                  ],
                ),
              ],
            ),
          )),

      /* SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: SearchBarWidget(text: "Favorites"),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('recipes')
                        .where("users_ids",
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
                            List<Recipe> recipesList = snapshots.data?.docs
                                    .map((e) => Recipe.fromJson(e.data(), e.id))
                                    .toList() ??
                                [];
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: recipesList.length,
                                itemBuilder: ((context, index) =>
                                    RecipeWidgetListTile(
                                        isFavoritIcon: true,
                                        recipe: recipesList[index])));
                          } else {
                            return const Text('No Data Found');
                          }
                        }
                      }
                    }),
              ],
            ),
          ),)
       */
    );
  }
}
