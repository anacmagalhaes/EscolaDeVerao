import 'package:flutter/foundation.dart';
import 'package:escoladeverao/models/user_model.dart';
import 'package:escoladeverao/services/api_service.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  final ApiService _apiService = ApiService();

  User? get currentUser => _currentUser;

  Future<void> fetchUpdatedUserData(String userId) async {
    try {
      final updatedUser = await _apiService.fetchUserById(userId);
      _currentUser = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void updateUser(User updatedUser) {
    _currentUser = updatedUser;
    notifyListeners();
  }
}
