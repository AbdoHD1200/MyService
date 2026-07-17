import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api',
  );






  static Future<Map<String, dynamic>> login(String phone, String password) async {

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'password': password}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'فشل الاتصال بالسيرفر'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'فشل الاتصال بالسيرفر'};
    }
  }

  static Future<Map<String, dynamic>> createOrder(
    String token,
    String title,
    String description,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'city': 'Tripoli',
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'فشل الاتصال بالسيرفر'};
    }
  }

  static Future<Map<String, dynamic>> getOrders(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'فشل الاتصال بالسيرفر'};
    }
  }
}
