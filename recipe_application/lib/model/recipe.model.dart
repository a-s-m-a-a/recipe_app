class Recipe {
  String? docId;
  String? description;  //2 
  String? title;  //10
  num? calories;  //1
  num? prep_time; //7
  num? rating;    //8  
  num? servings;  //9
  String? type;   //11
  Map<String, String>? directions; //3
  List<String>? ingredients; //5
  String? imageUrl; //4
  List<String>? users_ids; //12

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
  }
  Map<String, dynamic> toJson() {
    return {
      'prep_time': prep_time,
      'rating': rating,
      'calories': calories,
      'directions': directions,
      'type': type,
      'servings': servings,
      'ingredients': ingredients,
      "title": title,
      "imageUrl": imageUrl,
      "description": description,
      'users_ids': users_ids,
    };
  }
}
