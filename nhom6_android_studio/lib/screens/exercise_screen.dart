import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/config_url.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final String apiUrl = "${Config_URL.baseUrl}ExerciseApi";
  List<ExercisePost> exercises = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          exercises = data.map((item) => ExercisePost.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise List"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: exercise.img != null
                  ? Image.network(
                exercise.img!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : Icon(Icons.fitness_center),
              title: Text(exercise.name ?? "Unnamed Exercise"),
              subtitle:
              Text(exercise.description ?? "No description available."),
              onTap: () {
                // Navigate to a detailed screen if needed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ExerciseDetailScreen(exercise: exercise),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ExerciseDetailScreen extends StatelessWidget {
  final ExercisePost exercise;

  ExerciseDetailScreen({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name ?? "Exercise Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              exercise.img ?? '',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Hiển thị icon thay thế nếu không tải được ảnh
                return Icon(Icons.image_not_supported, size: 50);
              },
            )

            ,

            SizedBox(height: 16),
            Text(
              exercise.name ?? "Unnamed Exercise",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(exercise.description ?? "No description available."),
            SizedBox(height: 8),
            Text("Instructions: ${exercise.instruct ?? "No instructions provided."}"),
            SizedBox(height: 8),
            Text("Time: ${exercise.timeOnly ?? "N/A"}"),
            SizedBox(height: 8),
            Text("Reps: ${exercise.reps ?? 0}"),
          ],
        ),
      ),
    );
  }
}

class ExercisePost {
  ExercisePost({
    required this.id,
    required this.name,
    required this.description,
    required this.img,
    required this.instruct,
    required this.timeOnly,
    required this.slThucHien,
    required this.reps,
    required this.categoryExerciseId,
  });

  final int? id;
  final String? name;
  final String? description;
  final String? img;
  final String? instruct;
  final String? timeOnly;
  final int? slThucHien;
  final int? reps;
  final int? categoryExerciseId;

  factory ExercisePost.fromJson(Map<String, dynamic> json) {
    return ExercisePost(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      img: json["img"],
      instruct: json["instruct"],
      timeOnly: json["timeOnly"],
      slThucHien: json["slThucHien"],
      reps: json["reps"],
      categoryExerciseId: json["categoryExerciseId"],
    );
  }
}
