import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MealList {
  final int id;
  final String name;
  final String description;


  MealList({
    required this.id,
    required this.name,
    required this.description,
  });

  factory MealList.fromJson(Map<String, dynamic> json) {
    return MealList(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}

class ApiService {
  final String baseUrl = "https://littleblueroof28.conveyor.cloud/api/MealListApi";

  // Lấy danh sách các món ăn
  Future<List<MealList>> getMealList() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MealList.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meal list');
    }
  }

  // Thêm món ăn vào cơ sở dữ liệu
  Future<bool> addMeal(MealList meal) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(meal.toJson()),
    );

    if (response.statusCode == 201) {
      return true; // Dữ liệu đã được thêm thành công
    } else {
      throw Exception('Failed to add meal');
    }
  }
}

class MealListPage extends StatefulWidget {
  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  late Future<List<MealList>> futureMealList;

  @override
  void initState() {
    super.initState();
    futureMealList = ApiService().getMealList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Điều hướng đến màn hình thêm món ăn mới
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMealPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<MealList>>(
        future: futureMealList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No meals found.'));
          } else {
            List<MealList> meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  title: Text(meal.name),
                  subtitle: Text(meal.description),
                  onTap: () {
                    // Khi nhấn vào món ăn, điều hướng đến màn hình chi tiết
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailPage(meal: meal),
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

class MealDetailPage extends StatelessWidget {
  final MealList meal;

  MealDetailPage({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              meal.description,
              style: TextStyle(fontSize: 16),
            ),
            // Bạn có thể thêm các thông tin chi tiết khác ở đây nếu có
          ],
        ),
      ),
    );
  }
}

class AddMealPage extends StatefulWidget {
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ApiService _apiService = ApiService();

  // Hàm lưu món ăn mới vào cơ sở dữ liệu
  void _saveMeal() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      // Kiểm tra nếu tên hoặc mô tả bị trống
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both name and description')),
      );
      return;
    }

    final meal = MealList(id: 0, name: name, description: description); // id sẽ tự động sinh trong cơ sở dữ liệu
    try {
      final success = await _apiService.addMeal(meal);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal added successfully')),
        );
        Navigator.pop(context); // Quay lại trang trước (MealListPage)
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add meal: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Meal Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Meal Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMeal,
              child: Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
