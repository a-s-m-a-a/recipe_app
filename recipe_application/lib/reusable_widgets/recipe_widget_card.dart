import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:recipe_application/model/recipe.model.dart';
import 'package:recipe_application/pages/recipe_details.page.dart';
import 'package:recipe_application/utils/colors.utils.dart';
import 'package:recipe_application/utils/numbers.dart';
import 'package:recipe_application/viewModel/recipes_provider.dart';

class RecipeWidgetCard extends StatefulWidget {
  final Recipe recipe;

  const RecipeWidgetCard({required this.recipe, super.key});

  @override
  State<RecipeWidgetCard> createState() => _RecipeWidgetCardState();
}

class _RecipeWidgetCardState extends State<RecipeWidgetCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Numbers.appHorizontalPadding),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => RecipeDetailsPage(
                            recipe: widget.recipe,
                          )));
            },
            child: Container(
              width: 160,
              height: 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: hexStringToColor("f7f8fc")),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                          onTap: () {
                            Provider.of<RecipeProvider>(context, listen: false)
                                .addUserToRecipes(
                              !(widget.recipe.users_ids?.contains(
                                      FirebaseAuth.instance.currentUser?.uid) ??
                                  false),
                              widget.recipe.docId!,
                            );
                          },
                          child: (widget.recipe.users_ids?.contains(
                                      FirebaseAuth.instance.currentUser?.uid) ??
                                  false
                              ? const Icon(
                                  Icons.favorite_border_rounded,
                                  size: 30,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_rounded,
                                  size: 30,
                                  color: Colors.grey,
                                ))),
                    ),
                    Center(
                      child: Image.network(
                        widget.recipe.imageUrl ?? "",
                        fit: BoxFit.cover,
                        width: 120,
                        height: 60,
                      ),
                    ),
                    Text(
                      widget.recipe.type ?? 'No Type Found',
                      style: TextStyle(
                        color: hexStringToColor("128fae"),
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.recipe.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
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
                      onRatingUpdate: (rating) {
                        //print(rating);
                      },
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      "${widget.recipe.calories.toString()} Calories",
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.recipe.prep_time.toString()} mins",
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.room_service_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.recipe.servings} serving",
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
