// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:nhom6_android_studio/config/config_url.dart';
import 'package:nhom6_android_studio/models/exercisepost.dart';
import 'package:nhom6_android_studio/screens/exerciselist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectExerciseScreen extends StatefulWidget {
  const SelectExerciseScreen({super.key, required this.exerciseListId});
  final int exerciseListId;

  @override
  State<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends State<SelectExerciseScreen> {
  List<ExercisePost> selectedExercises = []; // Danh sách bài tập đã chọn
  List<ExercisePost> exercises = []; // Danh sách bài tập còn lại
  bool isLoading = false;

  // xóa bài tập khỏi danh sách đã chọn
  Future<void> _deleteExercise(int exerciseId) async {
    try {
      final response = await http.delete(
        Uri.parse(
            "${Config_URL.baseUrl}ExerciseListExerciseApi/${widget.exerciseListId}/$exerciseId"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 204) {
        print("Success to delete exercise: ${response.body}");
      } else {
        print("Failed to delete exercise: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // thêm bài tập vào danh sách đã chọn
  Future<void> _addExercise(int exerciseId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token != null) {
      try {
        setState(() {
          isLoading = true;
        });
        final response = await http.post(
          Uri.parse("${Config_URL.baseUrl}ExerciseListExerciseApi"),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode({
            "exerciseListId": widget.exerciseListId,
            "exerciseId": exerciseId
          }),
        );
        if (response.statusCode == 201) {
          setState(() {
            isLoading = false;
          });
          print("Success to add exercise: ${response.body}");
        } else {
          setState(() {
            isLoading = false;
          });
          print("Failed to add exercise: ${response.body}");
        }
      } catch (e) {
        print("Error: $e");
      }
    } else {
      print("Token not found");
    }
  }

  // Hàm tải danh sách bài tập
  Future<void> _fetchExercises() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response =
          await http.get(Uri.parse('${Config_URL.baseUrl}ExerciseApi'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          exercises =
              jsonData.map((json) => ExercisePost.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    print('widget.exerciseId${widget.exerciseListId}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Exercise'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Danh sách bài tập đã chọn
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${selectedExercises[index].name}'),
                    trailing: IconButton(
                      onPressed: () async {
                        if (selectedExercises[index].id != null) {
                          setState(() {
                            isLoading = true;
                          });
                          await _deleteExercise(selectedExercises[index].id!)
                              .then(
                            (value) {
                              setState(() {
                                final removedExercise =
                                    selectedExercises.removeAt(index);
                                exercises.add(removedExercise);
                                setState(() {
                                  isLoading = false;
                                });
                                print(
                                    'selectedExercises[index].id${selectedExercises[index].id}');
                              });
                            },
                          );
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: selectedExercises.length,
              ),
              if (selectedExercises.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 3,
                  color: Colors.blueAccent,
                ),

              Expanded(
                child: ListView.separated(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      title: Text('${exercise.name}'),
                      trailing: IconButton(
                        onPressed: () async {
                          await _addExercise(exercise.id ?? 0).then(
                            (value) {
                              setState(() {
                                selectedExercises.add(exercise);
                                exercises.removeAt(index);
                              });
                            },
                          );
                        },
                        icon: const Icon(Icons.add),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const ExerciseListScreen(),
                        ));
                      },
                      child: const Text('Back to ExerciseListScreen')))
            ],
          ),
          if (isLoading) const Center(child: CircularProgressIndicator())
        ],
      ),
    );
  }
}
