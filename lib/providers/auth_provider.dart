import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _userKey = 'user_token';
  static const String _defaultTokenValue = 'logged_in';

  bool _isAuthenticated = false;

  /// Getter for external auth state
  bool get isAuthenticated => _isAuthenticated;

  /// Check if token exists in secure storage
  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: _userKey);
    _isAuthenticated = token != null;
    notifyListeners();
  }

  /// Mark user as authenticated (write token)
  Future<void> markLoggedIn({String token = _defaultTokenValue}) async {
    await _storage.write(key: _userKey, value: token);
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Clear stored token and update auth status
  Future<void> logout() async {
    await _storage.delete(key: _userKey);
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Getter for accessing token directly
  Future<String?> get userToken async {
    return await _storage.read(key: _userKey);
  }

  /// Optional: force state refresh from storage
  Future<void> refresh() => checkLoginStatus();
}
