class MeallistPost {
  MeallistPost({
    required this.id,
    required this.name,
    required this.description,
    required this.mealTime,
    required this.userId,
  });

  final int? id;
  final String? name;
  final String? description;
  final DateTime? mealTime;
  final String? userId;

  factory MeallistPost.fromJson(Map<String, dynamic> json){
    return MeallistPost(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      mealTime: DateTime.tryParse(json["mealTime"] ?? ""),
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "mealTime": mealTime?.toIso8601String(),
    "userId": userId,
  };

}
