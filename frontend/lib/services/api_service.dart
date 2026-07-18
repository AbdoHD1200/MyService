import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // IMPORTANT:
  // When hosting Flutter web on a VM (or inside Docker), `localhost` refers to the browser/container,
  // not the backend container. Provide API_BASE_URL at build time.
  // Example:
  //   flutter build web --release --dart-define=API_BASE_URL=http://<vm-ip>:5000
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static Uri _baseUri() {
    final url = baseUrl.trim();
    if (url.isEmpty) {
      throw StateError('API_BASE_URL is not set. Build with --dart-define=API_BASE_URL=http://<vm-ip>:5000');
    }
    return Uri.parse(url);
  }







  static Future<Map<String, dynamic>> login(String phone, String password) async {

    try {
      final response = await http.post(
        _baseUri().resolve('/api/auth/login'),

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
        _baseUri().resolve('/api/auth/register'),
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
        _baseUri().resolve('/api/orders'),

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
        _baseUri().resolve('/api/orders'),

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
