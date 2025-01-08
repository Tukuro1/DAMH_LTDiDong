class ExerciselistPost {
  ExerciselistPost({
    required this.id,
    required this.name,
    required this.exerciseTime,
    required this.userId,
  });

  final int? id;
  final String? name;
  final DateTime? exerciseTime;
  final String? userId;

  factory ExerciselistPost.fromJson(Map<String, dynamic> json){
    return ExerciselistPost(
      id: json["id"],
      name: json["name"],
      exerciseTime: DateTime.tryParse(json["exerciseTime"] ?? ""),
      userId: json["userId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "exerciseTime": exerciseTime?.toIso8601String(),
    "userId": userId,
  };

}
