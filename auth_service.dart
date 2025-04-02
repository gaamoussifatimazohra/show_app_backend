import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await _saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}