import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhom6_android_studio/models/exerciselistpost.dart';
import 'add_exerciseslist_screen.dart'; // Import màn hình thêm bài tập
import '../config/config_url.dart'; // Import URL config

class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late Future<List<ExerciselistPost>> futureExercises;

  final String apiUrl = "${Config_URL.baseUrl}ExerciseListApi";

  @override
  void initState() {
    super.initState();
    futureExercises = fetchExerciseList();
  }

  Future<List<ExerciselistPost>> fetchExerciseList() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => ExerciselistPost.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load exercises");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  Future<void> refreshList() async {
    setState(() {
      futureExercises = fetchExerciseList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise List"),
      ),
      body: FutureBuilder<List<ExerciselistPost>>(
        future: futureExercises,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No exercises found"));
          }

          final exerciseList = snapshot.data!;
          return RefreshIndicator(
            onRefresh: refreshList,
            child: ListView.builder(
              itemCount: exerciseList.length,
              itemBuilder: (context, index) {
                final exercise = exerciseList[index];
                return ListTile(
                  title: Text(exercise.name ?? "Unknown"),
                  subtitle: Text(
                    "Time: ${exercise.exerciseTime?.toLocal().toString().split(' ')[0] ?? "Not set"}",
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailScreen(exercise: exercise),
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
            MaterialPageRoute(builder: (context) => AddExerciseScreen()),
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

class ExerciseDetailScreen extends StatelessWidget {
  final ExerciselistPost exercise;

  const ExerciseDetailScreen({Key? key, required this.exercise}) : super(key: key);

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
            Text(
              "Exercise Name: ${exercise.name ?? "Unknown"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "Exercise Time: ${exercise.exerciseTime?.toLocal() ?? "Not set"}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "User ID: ${exercise.userId ?? "Unknown"}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
