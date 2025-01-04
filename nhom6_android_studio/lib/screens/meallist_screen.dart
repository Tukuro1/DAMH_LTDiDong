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
  final String baseUrl = "https://funpurpledart82.conveyor.cloud/api/MealListApi";

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
      appBar: AppBar(title: Text('Meal List')),
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
                    // Handle meal tap (e.g., show details)
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


