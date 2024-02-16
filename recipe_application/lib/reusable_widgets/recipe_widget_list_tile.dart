import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/pages/recipe_details.page.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class RecipeWidgetListTile extends StatefulWidget {
  final bool isFavoritIcon;
  final Recipe recipe;

  const RecipeWidgetListTile(
      {required this.recipe, required this.isFavoritIcon, super.key});

  @override
  State<RecipeWidgetListTile> createState() => _RecipeWidgetListTileState();
}

class _RecipeWidgetListTileState extends State<RecipeWidgetListTile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, recipresProvider, child) => Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Numbers.appHorizontalPadding, vertical: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => RecipeDetailsPage(
                          recipe: widget.recipe,
                        )));
          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: hexStringToColor("f7f8fc")),
            child: ListTile(
                leading: Image.network(
                  widget.recipe.imageUrl.toString(),
                  fit: BoxFit.cover,
                  width: 100,
                  height: 86,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.type ?? 'No Type Found',
                      style: TextStyle(
                        color: hexStringToColor("128fae"),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.recipe.title ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: 4,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          updateOnDrag: false,
                          unratedColor: Colors.grey,
                          itemCount: 5,
                          itemSize: 15,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: hexStringToColor("#F45B00"),
                          ),
                          onRatingUpdate: (rating) {},
                        ),
                        const Spacer(),
                        Text(
                          "${widget.recipe.calories.toString()} Calories",
                          style: TextStyle(
                            color: hexStringToColor("#F45B00"),
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.recipe.prep_time.toString()} mins",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.room_service_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.recipe.servings ?? 1} Serving",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                trailing: (widget.isFavoritIcon)
                    ? (widget.recipe.users_ids?.contains(
                                FirebaseAuth.instance.currentUser?.uid) ??
                            false
                        ? const Icon(
                            Icons.favorite,
                            size: 30,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border_rounded,
                            size: 30,
                          ))
                    : IconButton(
                        onPressed: () {
                          recipresProvider.removeRecipeToUserRecentlyViewed(
                              widget.recipe.docId.toString());
                        },
                        icon: const Icon(Icons.delete))),
          ),
        ),
      ),
    );
  }
}
