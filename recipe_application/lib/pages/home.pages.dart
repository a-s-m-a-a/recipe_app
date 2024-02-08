import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/pages/favorites.pages.dart';
import 'package:recipe_application/pages/ingredients.pages.dart';
import 'package:recipe_application/reusable_widgets/recipe_widget.dart';
import 'package:recipe_application/reusable_widgets/reusable_widgits.dart';
import 'package:recipe_application/reusable_widgets/section_header.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/app_auth_provider.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

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
    Provider.of<RecipeProvider>(context, listen: false).getFreshRecipes();
    Provider.of<RecipeProvider>(context, listen: false).getRecommandedRecipes();
    Provider.of<RecipeProvider>(context, listen: false).getRecipes();
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const IngredientPage()));
                  },
                  leading: const Icon(Icons.food_bank),
                  title: const Text('Ingredients'),
                ),
                ListTile(
                  onTap: () {
                    controller.close?.call();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FavoritesPage()));
                  },
                  leading: const Icon(Icons.food_bank),
                  title: const Text('My favorits'),
                ),
                ListTile(
                  onTap: () {
                    Provider.of<AppAuthprovider>(context, listen: false)
                        .signOut(context);
                  },
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
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
              actions: const [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Numbers.appHorizontalPadding),
                  child: Icon(Icons.notifications),
                )
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
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
                  horisontalSpace(),
                  const Text(
                    "What would you like to cook today?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  horisontalSpace(),
                  Row(
                    children: [
                      Container(
                          width: 310,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: hexStringToColor("f7f8fc"),
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: hexStringToColor("f55a00"),
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: hexStringToColor("bfc3cf"),
                                ),
                                labelText: "Search for recipes",
                                labelStyle: TextStyle(
                                  color: hexStringToColor("bfc3cf"),
                                )),
                          )),
                      const Spacer(),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: hexStringToColor("f7f8fc"),
                        ),
                        child: const Icon(Icons.filter_2_sharp),
                      ),
                    ],
                  ),
                  horisontalSpace(),
                  // const AdsWidget(),
                  const SectionHeader(sectionName: "Today's Fresh Recipes"),
                  SizedBox(
                    height: 300,
                    child: Consumer<RecipeProvider>(
                        builder: (ctx, recipesProvider, _) => recipesProvider
                                    .recipesList ==
                                null
                            ? const CircularProgressIndicator()
                            : (recipesProvider.recipesList?.isEmpty ?? false)
                                ? const Text('No Data Found')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        recipesProvider.recipesList!.length,
                                    itemBuilder: (ctx, index) => RecipeWidget(
                                          recipe: recipesProvider
                                              .recipesList![index],
                                        ))),
                  ),
                ]),
              ),
            )));
  }
}
