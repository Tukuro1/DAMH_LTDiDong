import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import thư viện SharedPreferences
import 'package:jwt_decoder/jwt_decoder.dart'; // Import thư viện JwtDecoder để giải mã token JWT

import '../config/config_url.dart';
import 'package:nhom6_android_studio/models/updateuserinfopost.dart'; // Import model UpdateUserInfoPost

class UpdateUserInfoScreen extends StatefulWidget {
  @override
  _UpdateUserInfoScreenState createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? token;

  @override
  void initState() {
    super.initState();
    _checkToken(); // Kiểm tra token khi mở màn hình
  }

  // Kiểm tra token trong SharedPreferences
  Future<void> _checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token != null) {
      // Giải mã token và có thể sử dụng các thông tin trong token
      Map<String, dynamic>? decodedToken = JwtDecoder.decode(token);
      setState(() {
        this.token = token; // Lưu token vào biến state để sử dụng sau này
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Token không hợp lệ hoặc không có")));
    }
  }

  Future<void> updateUserInfo(String token, int? height, double? weight) async {
    final String apiUrl = "${Config_URL.baseUrl}Authenticate/update-info";

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'height': height,
        'weight': weight,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thành công")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cập nhật thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (token == null) {
      return Center(child: CircularProgressIndicator()); // Hiển thị loading khi chưa có token
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cập nhật thông tin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Chiều cao (cm)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chiều cao';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Cân nặng (kg)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập cân nặng';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final int? height = int.tryParse(_heightController.text);
                      final double? weight = double.tryParse(_weightController.text);

                      if (height != null && weight != null && token != null) {
                        updateUserInfo(token!, height, weight);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập dữ liệu hợp lệ")));
                      }
                    }
                  },
                  child: Text('Cập nhật'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
