import 'package:flutter/foundation.dart';
import '../models/users.dart';

class AuthViewModel extends ChangeNotifier {
  final List<User> _users = [
    User(id: '1', email: 'user1@ra.ru', password: '1234'),
    User(id: '2', email: 'user2@ra.ru', password: '5678'),
  ];

  User? _currentUser;

  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    // Имитация задержки при аутентификации
    await Future.delayed(Duration(seconds: 1));

    try {
      _currentUser = _users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid email or password'),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
