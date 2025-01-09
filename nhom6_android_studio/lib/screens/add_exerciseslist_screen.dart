// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nhom6_android_studio/screens/exercise_screen.dart';
// import 'package:nhom6_android_studio/screens/exerciselist_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Thêm thư viện SharedPreferences
// import '../config/config_url.dart';

// class AddExerciseScreen extends StatefulWidget {
//   @override
//   _AddExerciseScreenState createState() => _AddExerciseScreenState();
// }

// class _AddExerciseScreenState extends State<AddExerciseScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController timeController = TextEditingController();
//   String userId = ""; // Thêm biến userId để lưu thông tin từ token

//   final String apiUrl = "${Config_URL.baseUrl}ExerciseListApi";

//   @override
//   void initState() {
//     super.initState();
//     _loadUserId(); // Lấy userId từ token
//   }

//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('jwt_token');
//     if (token != null) {
//       // Giải mã token để lấy userId
//       final payload = token.split('.')[1];
//       final decodedPayload = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
//       final Map<String, dynamic> tokenData = jsonDecode(decodedPayload);
//       setState(() {
//         userId = tokenData['userId']; // Đảm bảo `userId` là key trong payload
//       });
//     }
//   }

//   Future<void> addExercise() async {
//     if (userId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to retrieve user ID from token')),
//       );
//       return;
//     }

//     final newExercise = {
//       'name': nameController.text,
//       'exerciseTime': timeController.text,
//       'userId': userId, // Sử dụng userId từ token
//     };

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(newExercise),
//     );

//     if (response.statusCode == 201 || response.statusCode == 200) {
//       // Điều hướng đến màn hình hiển thị danh sách bài tập
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ExerciseListScreen()), // Thay ExerciseListScreen bằng widget màn hình của bạn
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add exercise: ${response.body}')),
//       );
//     }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Exercise')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: 'Exercise Name'),
//             ),
//             TextField(
//               controller: timeController,
//               decoration: const InputDecoration(labelText: 'Exercise Time (YYYY-MM-DDTHH:mm:ss)'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: addExercise,
//               child: const Text('Add Exercise'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
