import 'package:flutter/material.dart';
import '../config/api_config.dart';
import 'package:http/http.dart' as http;

class ShowProvider with ChangeNotifier {
  List<dynamic> _shows = [];
  bool _isLoading = true;

  List<dynamic> get shows => _shows;
  bool get isLoading => _isLoading;

  Future<void> fetchShows() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final response = await http.get(Uri.parse(ApiConfig.showsEndpoint));
      _shows = jsonDecode(response.body);
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}