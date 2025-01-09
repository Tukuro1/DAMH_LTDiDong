import 'dart:ffi';

class UpdateUserInfoPost {
  UpdateUserInfoPost({
    required this.height,
    required this.weight,
  });

  final int? height;
  final double? weight;

  factory UpdateUserInfoPost.fromJson(Map<String, dynamic> json){
    return UpdateUserInfoPost(
      height: json["height"],
      weight: json["weight"],
    );
  }

  Map<String, dynamic> toJson() => {
    "height": height,
    "weight": weight,
  };

}
