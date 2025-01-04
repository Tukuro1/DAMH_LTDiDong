import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Model and API Service Combined
class Exercise {
  final int id;
  final String name;
  final String description;

  Exercise({required this.id, required this.name, required this.description});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
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
  final String baseUrl = "https://smallsageleaf12.conveyor.cloud/api/ExerciseListApi";

  Future<List<Exercise>> getExerciseList() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Exercise.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load exercise list');
      }
    } catch (e) {
      rethrow;
    }
  }
}

// Main Screen
class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late Future<List<Exercise>> futureExercises;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureExercises = apiService.getExerciseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise List'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(exercises[index].name),
                  subtitle: Text(exercises[index].description),
                  onTap: () {
                    // Handle tap if needed
                  },
                );
              },
            );
          } else {
            return Center(child: Text('No exercises found'));
          }
        },
      ),
    );
  }
}


