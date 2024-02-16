class Recipe {
  String? docId;
  String? title;
  String? imageUrl;
  String? description;
  num? servings;
  String? type;
  num? calories;
  num? rating;
  num? prep_time;
  List<String>? ingredients;
  Map<String, String>? directions;
  List<String>? users_ids;
  bool? fresh;

  Recipe();

  Recipe.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    title = data['title'];
    imageUrl = data['imageUrl'];
    description = data['description'];
    servings = data['servings'];
    type = data['type'];
    calories = data['calories'];
    rating = data['rating'];
    prep_time = data['prep_time'];
    ingredients = data['ingredients'] != null
        ? List<String>.from(data['ingredients'].map((e) => e.toString()))
        : null;
    directions = data['directions'] != null
        ? Map<String, String>.from(data['directions'])
        : null;
    users_ids = data['users_ids'] != null
        ? List<String>.from(data['users_ids'].map((e) => e.toString()))
        : null;
    fresh = data['fresh'];
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'servings': servings,
      'type': type,
      'calories': calories,
      'rating': rating,
      'prep_time': prep_time,
      'ingredients': ingredients,
      'directions': directions,
      'users_ids': users_ids,
      'fresh': fresh,
    };
  }
}
