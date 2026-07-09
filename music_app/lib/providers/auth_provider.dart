import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/datasource/local_datasource.dart';
import '../data/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final LocalDataSource localDataSource = LocalDataSource();
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String get error => _error;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final username = prefs.getString('username');
    
    if (userId != null && username != null) {
      _currentUser = User(id: userId, username: username, password: '');
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final userMap = await localDataSource.loginUser(username, password);
      if (userMap != null) {
        _currentUser = User.fromMap(userMap);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', _currentUser!.id!);
        await prefs.setString('username', _currentUser!.username);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid username or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final id = await localDataSource.registerUser(username, password);
      if (id > 0) {
        _isLoading = false;
        notifyListeners();
        return await login(username, password);
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Username might already exist. Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('username');
    notifyListeners();
  }
}
