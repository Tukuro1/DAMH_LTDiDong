import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  final List<ExercisePost> exercises = [
    ExercisePost(
      id: 1,
      name: "Push-ups",
      description: "A basic exercise for upper body strength.",
      img: "https://example.com/pushups.jpg",
      instruct: "Keep your back straight.",
      timeOnly: "30s",
      slThucHien: 10,
      reps: 15,
      categoryExerciseId: 1,
    ),
    ExercisePost(
      id: 2,
      name: "Plank",
      description: "Core strengthening exercise.",
      img: "https://example.com/plank.jpg",
      instruct: "Maintain a straight line.",
      timeOnly: "1m",
      slThucHien: 5,
      reps: 0,
      categoryExerciseId: 1,
    ),
    // Add more ExercisePost objects as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise List"),
      ),
      body: ListView.builder(
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
              subtitle: Text(exercise.description ?? "No description available."),
              onTap: () {
                // Navigate to a detailed screen if needed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseDetailScreen(exercise: exercise),
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
            exercise.img != null
                ? Image.network(
              exercise.img!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
                : SizedBox(height: 200, child: Icon(Icons.fitness_center, size: 100)),
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

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "img": img,
    "instruct": instruct,
    "timeOnly": timeOnly,
    "slThucHien": slThucHien,
    "reps": reps,
    "categoryExerciseId": categoryExerciseId,
  };
}
