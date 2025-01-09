import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Food {
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

  Food({
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

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
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

class ApiService {
  final String baseUrl = "https://localhost:7289/api/FoodApi"; // URL API của bạn

  // Lấy danh sách món ăn
  Future<List<Food>> getFoodList() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Food.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load food list');
    }
  }

  // Thêm món ăn vào cơ sở dữ liệu
  Future<bool> addFood(Food food) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(food.toJson()),
    );

    if (response.statusCode == 201) {
      return true; // Dữ liệu đã được thêm thành công
    } else {
      throw Exception('Failed to add food');
    }
  }
}
class FoodListScreen extends StatefulWidget {
  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListScreen> {
  late Future<List<Food>> futureFoodList;

  @override
  void initState() {
    super.initState();
    futureFoodList = ApiService().getFoodList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food List'),

      ),
      body: FutureBuilder<List<Food>>(
        future: futureFoodList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No food found.'));
          } else {
            List<Food> foods = snapshot.data!;
            return ListView.builder(
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return ListTile(
                  leading: food.imgFood != null && food.imgFood!.isNotEmpty
                      ? Image.network(food.imgFood!) // Hiển thị hình ảnh từ URL
                      : Icon(Icons.fastfood), // Nếu không có hình ảnh, hiển thị icon
                  title: Text(food.nameFood ?? 'No name'),
                  subtitle: Text(food.descriptionFood ?? 'No description'),
                  onTap: () {
                    // Khi nhấn vào món ăn, điều hướng đến màn hình chi tiết
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailPage(food: food),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FoodDetailPage extends StatelessWidget {
  final Food food;

  FoodDetailPage({required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.nameFood ?? 'Food Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            food.imgFood != null && food.imgFood!.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: food.imgFood!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error, size: 100),
            )
                : Icon(Icons.fastfood, size: 100), // Show default icon if no image
            SizedBox(height: 10),
            Text(
              food.nameFood ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(food.descriptionFood ?? 'No description'),
            SizedBox(height: 20),
            Text(
              'Meal Time: ${food.meal ?? 'Not specified'}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Calories: ${food.calories ?? 0} kcal',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Protein: ${food.protein ?? 0}g',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Fat: ${food.fat ?? 0}g',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

