class UserProfile {
  String? docId;
  String? imageUrl;
  String? userId;
  UserProfile();
  UserProfile.fromJson(Map<String, dynamic> data, [String? id]) {
    docId = id;
    userId = data['userId'];
    imageUrl = data['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "imageUrl": imageUrl,
    };
  }
}
