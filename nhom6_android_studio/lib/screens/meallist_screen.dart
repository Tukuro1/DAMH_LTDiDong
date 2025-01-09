import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  factory MeallistPost.fromJson(Map<String, dynamic> json) {
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

class ApiService {
  final String baseUrl = "https://localhost:7289/api/MealListApi";

  // Lấy danh sách các món ăn
  Future<List<MeallistPost>> getMealList() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => MeallistPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load meal list');
    }
  }

  // Thêm món ăn vào cơ sở dữ liệu
  Future<bool> addMeal(MeallistPost meal) async {
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

class MealListScreen extends StatefulWidget {
  const MealListScreen({super.key});

  @override
  _MealListScreenState createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  late Future<List<MeallistPost>> futureMealList;
  final String apiUrl = "https://localhost:7289/api/MealListApi";

  @override
  void initState() {
    super.initState();
    futureMealList = ApiService().getMealList();
  }

  Future<void> refreshList() async {
    setState(() {
      futureMealList = ApiService().getMealList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal List"),
      ),
      body: FutureBuilder<List<MeallistPost>>(
        future: futureMealList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No meals found"));
          }

          final mealList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: mealList.length,
              itemBuilder: (context, index) {
                final meal = mealList[index];
                return ListTile(
                  title: Text(meal.name ?? "No Name"),
                  subtitle: Text(meal.description ?? "No Description"),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(meal: meal),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealPage()),
          );
          if (result == true) {
            refreshList();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MealDetailScreen extends StatelessWidget {
  final MeallistPost meal;

  const MealDetailScreen({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name ?? "Meal Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meal.name ?? "No Name",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Description:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              meal.description ?? "No Description",
              style: const TextStyle(fontSize: 16),
            ),
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

  void _saveMeal() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both name and description')),
      );
      return;
    }

    final meal = MeallistPost(
      id: 0,
      name: name,
      description: description,
      mealTime: DateTime.now(),
      userId: '', // Replace with actual user ID
    );

    try {
      final success = await _apiService.addMeal(meal);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal added successfully')),
        );
        Navigator.pop(context, true); // Return to the previous screen
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
        title: const Text('Add New Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Meal Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Meal Description'),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMeal,
              child: const Text('Save Meal'),
            ),
          ],
        ),
      ),
    );
  }
}
