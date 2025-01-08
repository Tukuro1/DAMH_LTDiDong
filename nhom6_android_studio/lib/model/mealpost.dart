class Meallistfood {
  Meallistfood({
    required this.id,
    required this.nameFood,
    required this.descriptionFood,
    required this.imgFood,
    required this.foodAmount,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.meal,
    required this.categoryFoodId,
  });

  final int? id;
  final String? nameFood;
  final String? descriptionFood;
  final String? imgFood;
  final int? foodAmount;
  final int? calories;
  final int? protein;
  final int? fat;
  final String? meal;
  final int? categoryFoodId;

  factory Meallistfood.fromJson(Map<String, dynamic> json){
    return Meallistfood(
      id: json["id"],
      nameFood: json["nameFood"],
      descriptionFood: json["descriptionFood"],
      imgFood: json["imgFood"],
      foodAmount: json["foodAmount"],
      calories: json["calories"],
      protein: json["protein"],
      fat: json["fat"],
      meal: json["meal"],
      categoryFoodId: json["categoryFoodId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nameFood": nameFood,
    "descriptionFood": descriptionFood,
    "imgFood": imgFood,
    "foodAmount": foodAmount,
    "calories": calories,
    "protein": protein,
    "fat": fat,
    "meal": meal,
    "categoryFoodId": categoryFoodId,
  };

}
